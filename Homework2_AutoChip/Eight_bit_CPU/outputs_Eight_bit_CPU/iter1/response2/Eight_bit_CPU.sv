module Eight_bit_CPU(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [7:0] address,
    output reg mem_read,
    output reg mem_write
);
    reg [7:0] RAM [0:255]; // Program and data memory
    reg [7:0] PC;          // Program Counter
    reg [7:0] ACC;         // Accumulator
    reg [2:0] current_state; // State for instruction processing
    
    // Define basic states for the FSM
    localparam FETCH = 3'b000,
               DECODE = 3'b001,
               EXECUTE = 3'b010,
               MEM_READ = 3'b011,
               MEM_WRITE = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
            current_state <= FETCH; // Start in FETCH state
        end else begin
            case (current_state)
                FETCH: begin
                    address <= PC;                // Fetch instruction
                    data_out <= RAM[address];     // Outputs current instruction
                    mem_read <= 1'b1;             // Enable read
                    current_state <= DECODE;      // Move to DECODE state
                end
                
                DECODE: begin
                    mem_read <= 1'b0;             // Disable read
                    // Decode the instruction
                    case (data_out[7:4])          // Assume upper nibble is instruction
                        4'b0001: begin              // LOAD
                            ACC <= RAM[data_out[3:0]];
                        end
                        4'b0010: begin              // STORE
                            RAM[data_out[3:0]] <= ACC;
                        end
                        4'b0011: begin              // ADD
                            ACC <= ACC + RAM[data_out[3:0]];
                        end
                        4'b0100: begin              // SUB
                            ACC <= ACC - RAM[data_out[3:0]];
                        end
                        4'b0101: begin              // INC
                            ACC <= ACC + 1;
                        end
                        4'b0110: begin              // DEC
                            ACC <= ACC - 1;
                        end
                        4'b0111: begin              // AND
                            ACC <= ACC & RAM[data_out[3:0]];
                        end
                        4'b1000: begin              // OR
                            ACC <= ACC | RAM[data_out[3:0]];
                        end
                        4'b1001: begin              // NOT
                            ACC <= ~ACC;
                        end
                        4'b1010: begin              // JZ (jump if zero)
                            if (ACC == 8'b0) begin
                                PC <= data_out[3:0];
                            end
                        end
                        // Other instructions can be added here
                    endcase
                    current_state <= EXECUTE;      // Move to EXECUTE state
                end
                
                EXECUTE: begin
                    PC <= PC + 1;                  // Go to next instruction
                    current_state <= FETCH;        // Go back to FETCH state
                end
                
                default: current_state <= FETCH; // Default to FETCH state
            endcase
        end
    end
    
endmodule

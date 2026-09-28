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
    reg [7:0] instruction; // Instruction register
    
    // Memory Initialization
    initial begin
        // Load some sample instructions for testing
        RAM[0] = 8'h01; // LOAD
        RAM[1] = 8'h0E; // Immediate value 14
        RAM[2] = 8'h02; // STORE
        RAM[3] = 8'h0D; // Address location 13
        RAM[4] = 8'h03; // ADD
        RAM[5] = 8'h0F; // Immediate value 15
        RAM[6] = 8'h04; // SUB
        RAM[7] = 8'h0F; // Immediate value 15
        RAM[8] = 8'h05; // INC
        RAM[9] = 8'h06; // DEC
        RAM[10] = 8'h07; // AND
        RAM[11] = 8'h0F; // Immediate value 15
        RAM[12] = 8'h08; // OR
        RAM[13] = 8'h0F; // Immediate value 15
        RAM[14] = 8'h09; // NOT
        RAM[15] = 8'h0A; // JZ
        RAM[16] = 8'h0B; // Address to jump to if zero
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
        end else begin
            mem_read <= 1'b1;  // Enable read for the fetch
            address <= PC;      // Set address for RAM read

            // Fetch instruction from memory
            instruction <= RAM[address];

            case (instruction)
                8'h01: begin // LOAD immediate value from data_in to ACC
                    ACC <= data_in;
                end
                8'h02: begin // STORE ACC to RAM at address
                    RAM[data_in] <= ACC; // Store ACC at address indicated by data_in
                    mem_write <= 1'b1;
                end
                8'h03: begin // ADD immediate value to ACC
                    ACC <= ACC + data_in;
                end
                8'h04: begin // SUB immediate value from ACC
                    ACC <= ACC - data_in;
                end
                8'h05: begin // INC ACC
                    ACC <= ACC + 1;
                end
                8'h06: begin // DEC ACC
                    ACC <= ACC - 1;
                end
                8'h07: begin // AND immediate value with ACC
                    ACC <= ACC & data_in;
                end
                8'h08: begin // OR immediate value with ACC
                    ACC <= ACC | data_in;
                end
                8'h09: begin // NOT ACC
                    ACC <= ~ACC;
                end
                8'h0A: begin // JZ Jump if zero
                    if (ACC == 8'b0) begin
                        PC <= data_in; // Jump to address
                    end
                end
                default: begin // Unrecognized instruction
                    // Do Nothing
                end
            endcase

            if (mem_write) begin
                mem_write <= 1'b0; // Reset mem_write after the write operation
            end

            PC <= PC + 1; // Increment program counter after instruction
            data_out <= ACC; // Output ACC for verification
        end
    end

endmodule

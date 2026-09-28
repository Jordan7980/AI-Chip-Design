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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
            data_out <= 8'b0; // Reset data_out
        end else begin
            address <= PC;      // Fetch current instruction
            mem_read <= 1'b1;   // Enable memory read for fetching

            // Fetch instruction from memory
            case (RAM[address])
                8'h00: begin // NOP (No Operation)
                    mem_read <= 1'b0;
                end
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
                    mem_read <= 1'b0;
                end
            endcase
            
            PC <= PC + 1;       // Increment program counter after instruction
            data_out <= ACC;    // Output ACC for verification
            mem_write <= 1'b0;  // Clear mem_write after operation
        end
    end

endmodule

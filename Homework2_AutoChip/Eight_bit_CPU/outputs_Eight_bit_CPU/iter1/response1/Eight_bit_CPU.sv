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
    reg [7:0] instruction; // Current instruction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
            data_out <= 8'b0;
        end else begin
            address <= PC;            // Address current PC
            mem_read <= 1'b1;         // Enable memory read
            instruction <= RAM[address]; // Fetch instruction
            
            case (instruction[7:4]) // Assuming high nibble represents opcode
                4'b0000: begin // LOAD
                    ACC <= RAM[instruction[3:0]];
                    data_out <= ACC;
                end
                4'b0001: begin // ADD
                    ACC <= ACC + RAM[instruction[3:0]];
                    data_out <= ACC;
                end
                4'b0010: begin // STORE
                    RAM[instruction[3:0]] <= ACC;
                    mem_write <= 1'b1; // Enable memory write for the next cycle
                end
                4'b0011: begin // SUB
                    ACC <= ACC - RAM[instruction[3:0]];
                    data_out <= ACC;
                end
                4'b0100: begin // INC
                    ACC <= ACC + 1;
                    data_out <= ACC;
                end
                4'b0101: begin // DEC
                    ACC <= ACC - 1;
                    data_out <= ACC;
                end
                4'b0110: begin // AND
                    ACC <= ACC & RAM[instruction[3:0]];
                    data_out <= ACC;
                end
                4'b0111: begin // OR
                    ACC <= ACC | RAM[instruction[3:0]];
                    data_out <= ACC;
                end
                4'b1000: begin // NOT
                    ACC <= ~ACC;
                    data_out <= ACC;
                end
                4'b1001: begin // JZ (Jump if Zero)
                    if (ACC == 8'b0) begin
                        PC <= instruction[3:0]; // Jump to address in low nibble
                    end
                end
                // Other operations can be defined here
            endcase
            
            PC <= PC + 1; // Increment program counter every cycle (fetch next instruction)
        end
    end

endmodule

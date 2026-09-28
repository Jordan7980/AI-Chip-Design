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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
        end else begin
            // Fetch instruction only if PC is valid
            address <= PC;
            mem_read <= 1'b1;  // Enable read for the fetch
            
            // Fetch instruction from memory
            instruction <= RAM[address];

            // Decode the instruction
            case (instruction[7:4]) // Use higher nibble for the operation
                4'h1: begin // LOAD immediate value from data_in to ACC
                    ACC <= data_in;
                    mem_read <= 1'b0;
                end
                4'h2: begin // STORE ACC to RAM at address
                    RAM[data_in] <= ACC; // Store ACC at address indicated by data_in
                    mem_write <= 1'b1;
                end
                4'h3: begin // ADD immediate value to ACC
                    ACC <= ACC + data_in;
                end
                4'h4: begin // SUB immediate value from ACC
                    ACC <= ACC - data_in;
                end
                4'h5: begin // INC ACC
                    ACC <= ACC + 1;
                end
                4'h6: begin // DEC ACC
                    ACC <= ACC - 1;
                end
                4'h7: begin // AND immediate value with ACC
                    ACC <= ACC & data_in;
                end
                4'h8: begin // OR immediate value with ACC
                    ACC <= ACC | data_in;
                end
                4'h9: begin // NOT ACC
                    ACC <= ~ACC;
                end
                4'hA: begin // JZ Jump if zero
                    if (ACC == 8'b0) begin
                        PC <= data_in; // Jump to address
                    end
                end
                default: begin 
                    // Do Nothing
                end
            endcase

            PC <= PC + 1;        // Increment program counter after instruction
            data_out <= ACC;     // Output ACC for verification
            mem_write <= 1'b0;   // Clear mem_write after operation
            mem_read <= 1'b0;    // Clear mem_read after fetch
        end
    end

endmodule

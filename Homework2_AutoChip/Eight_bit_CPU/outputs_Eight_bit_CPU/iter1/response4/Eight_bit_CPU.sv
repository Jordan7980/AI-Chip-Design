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

    // Define an opcode
    parameter LOAD_OPCODE = 8'h01, 
              STORE_OPCODE = 8'h02, 
              ADD_OPCODE = 8'h03, 
              SUB_OPCODE = 8'h04,
              INC_OPCODE = 8'h05,
              DEC_OPCODE = 8'h06,
              AND_OPCODE = 8'h07,
              OR_OPCODE = 8'h08,
              NOT_OPCODE = 8'h09,
              JZ_OPCODE = 8'h0A;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
        end else begin
            // Fetch instruction from memory
            address <= PC;
            data_out <= RAM[address]; // Sample read operation
            mem_read <= 1'b1;   // Enable memory read
            mem_write <= 1'b0;  // Disable memory write

            // Simple example based on the instruction value
            case (data_out) 
                LOAD_OPCODE: begin
                    PC <= PC + 1;  // Move to the next instruction
                    ACC <= RAM[RAM[PC]]; // Load data into ACC
                end
                STORE_OPCODE: begin
                    PC <= PC + 1;
                    RAM[RAM[PC]] <= ACC; // Store ACC into memory
                end
                ADD_OPCODE: begin
                    PC <= PC + 1;
                    ACC <= ACC + RAM[RAM[PC]]; // Add data to ACC
                end
                SUB_OPCODE: begin
                    PC <= PC + 1;
                    ACC <= ACC - RAM[RAM[PC]]; // Subtract data from ACC
                end
                INC_OPCODE: begin
                    ACC <= ACC + 1; // Increment ACC
                end
                DEC_OPCODE: begin
                    ACC <= ACC - 1; // Decrement ACC
                end
                AND_OPCODE: begin
                    PC <= PC + 1;
                    ACC <= ACC & RAM[RAM[PC]]; // Bitwise AND
                end
                OR_OPCODE: begin
                    PC <= PC + 1;
                    ACC <= ACC | RAM[RAM[PC]]; // Bitwise OR
                end
                NOT_OPCODE: begin
                    ACC <= ~ACC; // Bitwise NOT
                end
                JZ_OPCODE: begin
                    if (ACC == 8'b0) 
                        PC <= RAM[RAM[PC]]; // Jump if ACC is zero
                    else 
                        PC <= PC + 1; // Otherwise move to next instruction
                end
                default: PC <= PC + 1; // Default case to avoid infinite loops
            endcase
        end
    end

endmodule

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

    // Define an enumeration for the instruction opcodes
    parameter LOAD = 8'h01, ADD = 8'h02, STORE = 8'h03;
    parameter SUB = 8'h04, INC = 8'h05, DEC = 8'h06;
    parameter AND = 8'h07, OR = 8'h08, NOT = 8'h09;
    parameter JZ = 8'h0A, OUT = 8'h0B;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;     // Reset PC
            ACC <= 8'b0;    // Reset ACC
            mem_read <= 1'b0;
            mem_write <= 1'b0;
        end else begin
            case (RAM[PC]) // Fetch the instruction
                LOAD: begin
                    ACC <= RAM[PC + 1]; // Load value into ACC
                    PC <= PC + 2;       // Move to next instruction
                end
                ADD: begin
                    ACC <= ACC + RAM[PC + 1]; // Add value to ACC
                    PC <= PC + 2;             // Move to next instruction
                end
                STORE: begin
                    RAM[RAM[PC + 1]] <= ACC; // Store ACC into RAM
                    PC <= PC + 2;            // Move to next instruction
                end
                SUB: begin
                    ACC <= ACC - RAM[PC + 1]; // Subtract value from ACC
                    PC <= PC + 2;             // Move to next instruction
                end
                INC: begin
                    ACC <= ACC + 1; // Increment ACC
                    PC <= PC + 1;   // Move to next instruction
                end
                DEC: begin
                    ACC <= ACC - 1; // Decrement ACC
                    PC <= PC + 1;   // Move to next instruction
                end
                AND: begin
                    ACC <= ACC & RAM[PC + 1]; // AND operation
                    PC <= PC + 2;             // Move to next instruction
                end
                OR: begin
                    ACC <= ACC | RAM[PC + 1]; // OR operation
                    PC <= PC + 2;             // Move to next instruction
                end
                NOT: begin
                    ACC <= ~ACC; // NOT operation
                    PC <= PC + 1; // Move to next instruction
                end
                JZ: begin
                    if (ACC == 8'b0)
                        PC <= RAM[PC + 1]; // Jump if zero
                    else
                        PC <= PC + 2;       // Move to next instruction
                end
                OUT: begin
                    data_out <= ACC; // Output the contents of ACC
                    PC <= PC + 1;    // Move to next instruction
                end
                default: begin
                    PC <= PC + 1; // Default case, just move to the next instruction
                end
            endcase
            
            address <= PC;   // Set the address for memory access
            mem_read <= 1'b1; // Enable memory read
            mem_write <= 1'b0; // Disable memory write
        end
    end

endmodule

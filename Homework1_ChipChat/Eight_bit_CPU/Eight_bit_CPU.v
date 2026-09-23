
module Eight_bit_CPU (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,   // Input data for I/O
    output reg [7:0] data_out,  // Output data for I/O
    output reg [7:0] address,    // Address line for memory access
    output reg mem_read,         // Memory read enable
    output reg mem_write         // Memory write enable
);

// Registers
reg [7:0] ACC;                // Accumulator
reg [7:0] PC;                 // Program Counter
reg [7:0] IR;                 // Instruction Register
reg [7:0] RAM [0:255];        // Memory (256 x 8-bit)

// Control signals
reg [2:0] state;              // State for FSM

// ALU operation
always @(*) begin
    case (IR[7:4]) // opcode in bits [7:4]
        4'b0000: ACC = ACC;                // NOP
        4'b0001: ACC = RAM[IR[3:0]];       // LOAD
        4'b0010: RAM[IR[3:0]] = ACC;       // STORE
        4'b0011: ACC = ACC + RAM[IR[3:0]]; // ADD
        4'b0100: ACC = ACC - RAM[IR[3:0]]; // SUB
        4'b0101: ACC = ACC & RAM[IR[3:0]]; // AND
        4'b0110: ACC = ACC | RAM[IR[3:0]]; // OR
        4'b0111: ACC = ~ACC;                 // NOT
        4'b1000: ACC = ACC + 1;              // INC
        4'b1001: ACC = ACC - 1;              // DEC
        4'b1010: PC = IR[3:0];               // JMP
        4'b1011: if (ACC == 0) PC = IR[3:0]; // JZ
        4'b1100: data_out = ACC;             // Output
        4'b1101: ACC = data_in;              // Input
        default: ACC = ACC;                   // Default to NOP
    endcase
end

// Main CPU operation
always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC <= 8'h00;         // Reset program counter
        ACC <= 8'h00;        // Reset accumulator
        state <= 3'b000;     // Reset state
    end else begin
        if (state == 3'b000) begin
            mem_read <= 1'b1; // Enable read
            address <= PC;    // Get instruction address
            IR <= RAM[PC];    // Fetch instruction
            state <= 3'b001;  // Move to next state (execute)
        end else if (state == 3'b001) begin
            mem_read <= 1'b0;  // Disable read
            mem_write <= 1'b0; // Ensure no write
            
            // Include the execution logic
            case (IR[7:4]) // opcode in bits [7:4]
                4'b1011: if (ACC == 0) PC <= IR[3:0]; // JZ
                default: PC <= PC + 1;                // Increment for others
            endcase
            
            state <= 3'b000; // Return to fetch next instruction
        end
    end
end

endmodule

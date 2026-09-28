module Eight_bit_CPU(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [7:0] address,
    output reg mem_read,
    output reg mem_write
);
    reg [7:0] RAM [0:255]; // 256 bytes of RAM
    reg [7:0] PC;          // Program Counter
    reg [7:0] ACC;         // Accumulator

    // Initialization
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            RAM[i] = 8'h00; // Initialize RAM to 0
        end
        PC = 8'h00; // Initialize Program Counter
        ACC = 8'h00; // Initialize Accumulator
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'h00; // Reset Program Counter
            ACC <= 8'h00; // Reset Accumulator
            mem_read <= 1'b0;
            mem_write <= 1'b0;
            address <= 8'h00; // Reset address
        end else begin
            // Simple instruction fetch/decode logic (to be implemented)
            address <= PC; // Output address for current PC
            mem_read <= 1'b1; // Set read signal
            data_out <= RAM[address]; // Read data from RAM

            // Assuming a very basic instruction execution
            // For now, just simulate a single instruction
            ACC <= data_in; // Load input to ACC
            
            // Increment PC for the next instruction (in a real design, this would be based on actual instructions)
            PC <= PC + 1;
        end
    end
endmodule

module Eight_bit_CPU(
	input clk,
	input reset,
	input [7:0] data_in,
	output reg [7:0] data_out,
	output reg [7:0] address,
	output reg mem_read,
	output reg mem_write
);
	reg [7:0] RAM [0:255];
	reg [7:0] PC; // Program Counter
	reg [7:0] ACC; // Accumulator

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			PC <= 8'd0;
			ACC <= 8'd0;
			mem_read <= 1'b0;
			mem_write <= 1'b0;
		end else begin
			// Simple instruction fetch and execute cycle
			address <= PC;
			mem_read <= 1'b1; // Indicate we want to read from memory
			data_out <= RAM[address]; // Output data from RAM to data_out
			// Sample operation (commit a simple ADD operation, etc.)
			ACC <= ACC + data_out; // Example operation using ACC
			PC <= PC + 1; // Increment PC to point to the next instruction
			mem_read <= 1'b0;
			mem_write <= 1'b0; // No write operation in this example
		end
	end
endmodule

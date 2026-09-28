module lfsr(
	input clk,
	input reset_n,
	output reg [7:0] data
);

	reg [7:0] lfsr_reg;
	wire feedback;

	assign feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg[3] ^ lfsr_reg[6]; // Taps at locations 1, 4, 6, and 7

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			lfsr_reg <= 8'b10001010; // Initial state
		end else begin
			lfsr_reg <= {lfsr_reg[6:0], feedback};
		end
	end
	
	assign data = lfsr_reg;

endmodule

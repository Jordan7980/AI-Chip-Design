module lfsr(
	input clk,
	input reset_n,
	output reg [7:0] data
);

	// Initial state
	initial begin
		data = 8'b10001010;
	end

	// LFSR tap positions: 1, 4, 6, 7 (0-indexed)
	wire feedback = data[1] ^ data[4] ^ data[6] ^ data[7];

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			data <= 8'b10001010; // reset to initial state
		end else begin
			data <= {data[6:0], feedback}; // shift left and insert feedback
		end
	end

endmodule

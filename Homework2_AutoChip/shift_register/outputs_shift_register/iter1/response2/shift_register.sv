module shift_register(
	input clk,
	input reset_n,
	input data_in,
	input shift_enable,
	output reg [7:0] data_out
);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			data_out <= 8'b0; // Reset the output to 0 on active-low reset
		end else if (shift_enable) begin
			data_out <= {data_out[6:0], data_in}; // Shift left and insert data_in
		end
	end

	// To ensure the first data_in is shifted in at the first enable
	always @(posedge clk) begin
		if (data_out == 8'b0 && shift_enable) begin
			data_out <= {7'b0, data_in}; // Load the first bit
		end
	end

endmodule

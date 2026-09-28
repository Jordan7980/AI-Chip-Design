module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);
  reg [3:0] tens;
  reg [3:0] ones;
  integer i;

  always @(binary_input) begin
    // Initialize BCD output
    bcd_output = 8'b0;
    tens = 4'b0;
    ones = 4'b0;

    // Binary to BCD conversion using shift-and-add-3 algorithm
    for (i = 0; i < 5; i = i + 1) begin
      // Shift the BCD digits left
      if (tens >= 5) begin
        tens = tens + 3;
      end
      if (ones >= 5) begin
        ones = ones + 3;
      end
      tens = {tens[2:0], ones[3]}; // Shift left
      ones = {ones[2:0], binary_input[4 - i]};
    end
    bcd_output = {tens, ones};
  end
endmodule

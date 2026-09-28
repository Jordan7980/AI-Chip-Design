module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);

  integer i;
  reg [3:0] tens, ones;

  always @(*) begin
    // Initialize BCD digits to zero
    tens = 4'd0;
    ones = 4'd0;
    // Shift BCD conversion
    for (i = 0; i < 5; i = i + 1) begin
      // Shift left
      {tens, ones} = {tens, ones} << 1;
      ones[0] = binary_input[4 - i]; // Stage the next input bit
      
      // Adjust for valid BCD digits (greater than 4)
      if (ones >= 4'd5) ones = ones + 4'd3;
      if (tens >= 4'd5) tens = tens + 4'd3;
    end
    // Assign final BCD output
    bcd_output = {tens, ones};
  end

endmodule

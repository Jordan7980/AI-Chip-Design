module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);
  reg [3:0] tens;
  reg [3:0] ones;
  integer i;

  always @* begin
    // Initialize BCD values
    tens = 4'b0000;
    ones = 4'b0000;
    
    // Convert binary to BCD using shift and add method
    for (i = 0; i < 5; i = i + 1) begin
      // Shift left by 1 bit
      {tens, ones} = {tens, ones} << 1; 
      
      // Add 1 to ones if necessary
      if (ones >= 4'b1001) begin
        ones = ones + 4'b0010; // Add 2 to BCD 1's place
      end
      
      // Add 1 to tens if necessary
      if (tens >= 4'b1001) begin
        tens = tens + 4'b0010; // Add 2 to BCD 10's place
      end
      
      // Add the next bit from the binary input
      ones[0] = binary_input[4 - i];
    end
    
    bcd_output = {tens, ones}; // Concatenate tens and ones
  end
endmodule

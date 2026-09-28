module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);
  integer i;

  always @(*) begin
    // Initialize BCD output to zero
    bcd_output = 8'b00000000;
    
    // Convert binary to BCD using double-dabble method
    for (i = 0; i < 5; i = i + 1) begin
      // Shift BCD left by 1 (multiply by 2)
      bcd_output[6:0] = bcd_output[7:1];
      
      // If 10's place is 5 or more, add 3
      if (bcd_output[7:4] >= 5) begin
        bcd_output[7:4] = bcd_output[7:4] + 3;
      end
      
      // If 1's place is 5 or more, add 3
      if (bcd_output[3:0] >= 5) begin
        bcd_output[3:0] = bcd_output[3:0] + 3;
      end

      // Add the next binary digit
      bcd_output[0] = binary_input[4 - i];
    end
  end
endmodule

module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);
  integer i;

  always @(*) begin
    // Initialize BCD output
    bcd_output = 8'b0;

    // Convert binary to BCD using double-dabble method
    for (i = 4; i >= 0; i = i - 1) begin
      // Shift left by 1
      bcd_output = {bcd_output[6:0], binary_input[i]};

      // Add 3 to BCD digits if they are greater than 4
      if (bcd_output[3:0] > 4'b0100) begin
        bcd_output[3:0] = bcd_output[3:0] + 4'b0011;
      end
      if (bcd_output[7:4] > 4'b0100) begin
        bcd_output[7:4] = bcd_output[7:4] + 4'b0011;
      end
    end
  end
endmodule

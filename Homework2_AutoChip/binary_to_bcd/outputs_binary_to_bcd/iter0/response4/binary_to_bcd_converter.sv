module binary_to_bcd_converter(
  input [4:0] binary_input,
  output reg [7:0] bcd_output
);
  integer i;

  always @(*) begin
    // Initialize BCD output
    bcd_output = 8'b0;

    // Convert binary to BCD using double-dabble algorithm
    for (i = 0; i < 5; i = i + 1) begin
      // Shift left and add the new bit
      bcd_output = {bcd_output[6:0], binary_input[4-i]};

      // BCD correction
      if (bcd_output[3:0] > 4'd9) begin
        bcd_output[3:0] = bcd_output[3:0] + 4'd6;
      end
      if (bcd_output[7:4] > 4'd9) begin
        bcd_output[7:4] = bcd_output[7:4] + 4'd6;
      end
    end
  end
endmodule

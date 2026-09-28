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

      // Add 3 to BCD digits if they are 5 or more
      if (bcd_output[3:0] >= 5) begin
        bcd_output[3:0] = bcd_output[3:0] + 4'b0011;
      end
      if (bcd_output[7:4] >= 5) begin
        bcd_output[7:4] = bcd_output[7:4] + 4'b0011;
      end
    end
  end

  // Convert binary_input directly to its BCD equivalent
  always @(*) begin
    case (binary_input)
      5'b00000: bcd_output = 8'b00000000; // BCD for 0
      5'b00001: bcd_output = 8'b00000001; // BCD for 1
      5'b00010: bcd_output = 8'b00000010; // BCD for 2
      5'b00011: bcd_output = 8'b00000011; // BCD for 3
      5'b00100: bcd_output = 8'b00000100; // BCD for 4
      5'b00101: bcd_output = 8'b00000101; // BCD for 5
      5'b00110: bcd_output = 8'b00000110; // BCD for 6
      5'b00111: bcd_output = 8'b00000111; // BCD for 7
      5'b01000: bcd_output = 8'b00001000; // BCD for 8
      5'b01001: bcd_output = 8'b00001001; // BCD for 9
      5'b01010: bcd_output = 8'b00010000; // BCD for 10
      5'b01011: bcd_output = 8'b00010001; // BCD for 11
      5'b01100: bcd_output = 8'b00010010; // BCD for 12
      5'b01101: bcd_output = 8'b00010011; // BCD for 13
      5'b01110: bcd_output = 8'b00010100; // BCD for 14
      5'b01111: bcd_output = 8'b00010101; // BCD for 15
      5'b10000: bcd_output = 8'b00010110; // BCD for 16
      5'b10001: bcd_output = 8'b00010111; // BCD for 17
      5'b10010: bcd_output = 8'b00011000; // BCD for 18
      5'b10011: bcd_output = 8'b00011001; // BCD for 19
      5'b11001: bcd_output = 8'b00100101; // BCD for 25
      5'b11010: bcd_output = 8'b00100110; // BCD for 26
      5'b11011: bcd_output = 8'b00100111; // BCD for 27
      5'b11100: bcd_output = 8'b00101000; // BCD for 28
      5'b11101: bcd_output = 8'b00101001; // BCD for 29
      default: bcd_output = 8'b00000000; // Default case
    endcase
  end
endmodule

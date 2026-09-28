module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  reg [7:0] state;

  // State encoding
  localparam S0 = 8'b00000001; // 0b000
  localparam S1 = 8'b00000010; // 0b001
  localparam S2 = 8'b00000100; // 0b010 (not used but needed for transitions)
  localparam S3 = 8'b00001000; // 0b011
  localparam S4 = 8'b00010000; // 0b100 (not used but needed for transitions)
  localparam S5 = 8'b00100000; // 0b101
  localparam S6 = 8'b01000000; // 0b110
  localparam S7 = 8'b10000000; // Final state (enforces overlapping)

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= S0;
      sequence_found <= 1'b0;
    end else begin
      case (state)
        S0: if (data == 3'b000) state <= S0; else if (data == 3'b001) state <= S1; else if (data == 3'b101) state <= S5;
        S1: if (data == 3'b001) state <= S1; else if (data == 3'b101) state <= S5; else if (data == 3'b110) state <= S6;
        S5: if (data == 3'b101) state <= S5; else if (data == 3'b110) state <= S6; else if (data == 3'b011) state <= S3;
        S6: if (data == 3'b110) state <= S6; else if (data == 3'b011) state <= S3; else if (data == 3'b000) state <= S0;
        S3: if (data == 3'b011) state <= S3; else if (data == 3'b101) state <= S5; else if (data == 3'b110) state <= S6;
        default: state <= S0;
      endcase

      // Set sequence found if we are in any state that indicates a sequence was detected
      sequence_found <= (state == S0 || state == S1 || state == S5 || state == S6 || state == S3);
    end
  end
endmodule

module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);

  reg [2:0] state, next_state;

  // State encoding
  parameter S0 = 3'b000,
            S1 = 3'b001,
            S2 = 3'b010,
            S3 = 3'b011,
            S4 = 3'b100,
            S5 = 3'b101,
            S6 = 3'b110;

  // Sequence detection logic
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      state <= S0; // Reset to initial state
    else
      state <= next_state;
  end

  always @(*) begin
    case (state)
      S0: next_state = (data == 3'b001) ? S1 : S0;
      S1: next_state = (data == 3'b101) ? S2 : S0;
      S2: next_state = (data == 3'b110) ? S3 : S0;
      S3: next_state = (data == 3'b000) ? S4 : S0;
      S4: next_state = (data == 3'b110) ? S5 : S0;
      S5: next_state = (data == 3'b110) ? S5 : S6;
      S6: next_state = (data == 3'b011) ? S7 : S0;
      S7: next_state = (data == 3'b101) ? S0 : S0;
      default: next_state = S0;
    endcase
  end

  // Sequence found output logic
  always @(*) begin
    sequence_found = (state == S7);
  end

endmodule

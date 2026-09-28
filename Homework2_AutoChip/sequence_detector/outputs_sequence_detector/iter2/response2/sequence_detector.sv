module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  reg [2:0] current_state, next_state;

  // State declarations for sequence detection
  localparam S0 = 3'b000,
             S1 = 3'b001,
             S2 = 3'b101,
             S3 = 3'b110,
             S4 = 3'b011;

  // Combinational logic to determine next state
  always @(*) begin
    case (current_state)
      S0: next_state = (data == S1) ? S1 : (data == S2) ? S2 : (data == S3) ? S3 : (data == S4) ? S4 : S0;
      S1: next_state = (data == S2) ? S2 : S0;
      S2: next_state = (data == S3) ? S3 : S0;
      S3: next_state = (data == S4) ? S4 : S0;
      S4: next_state = (data == S1) ? S1 : (data == S2) ? S2 : S0; // Allow detection of the sequence
      default: next_state = S0;
    endcase
  end

  // Sequential logic for state transitions and output
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      current_state <= S0;
      sequence_found <= 0;
    end else begin
      current_state <= next_state;
      sequence_found <= (next_state == S4) ? 1 : 0; // Indicate sequence found
    end
  end
endmodule

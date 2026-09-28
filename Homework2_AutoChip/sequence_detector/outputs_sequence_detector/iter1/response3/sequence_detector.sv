module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t;
  state_t state, next_state;

  // Define the sequence pattern
  localparam SEQUENCE[7:0] = {3'b001, 3'b101, 3'b110, 3'b000, 3'b110, 3'b110, 3'b011, 3'b101};

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      sequence_found <= 0;
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    next_state = state;
    sequence_found = 0;

    case (state)
      S0: if (data == SEQUENCE[0]) next_state = S1; 
      S1: if (data == SEQUENCE[1]) next_state = S2; 
      S2: if (data == SEQUENCE[2]) next_state = S3; 
      S3: if (data == SEQUENCE[3]) next_state = S4; 
      S4: begin
          sequence_found = 1; 
          next_state = S0; // Return to start after finding a sequence
        end
      default: next_state = S0;
    endcase
  end
endmodule

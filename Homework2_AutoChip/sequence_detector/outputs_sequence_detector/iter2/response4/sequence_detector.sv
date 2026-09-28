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

  // Combinational logic to determine next state and output
  always @(*) begin
    next_state = current_state; // Default to hold the state
    sequence_found = 0; // Default output

    case (current_state)
      S0: begin
        if (data == S1) next_state = S1;
      end
      S1: begin
        if (data == S2) next_state = S2;
      end
      S2: begin
        if (data == S3) next_state = S3;
      end
      S3: begin
        if (data == S4) begin
          next_state = S4;
          sequence_found = 1; // Sequence found
        end
      end
      S4: begin
        if (data == S2) begin
          next_state = S2;
          sequence_found = 1; // Sequence found
        end else if (data == S1) begin
          next_state = S1;
          sequence_found = 1; // Sequence found
        end
      end
      default: next_state = S0;
    endcase
  end

  // Sequential logic for state transitions
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      current_state <= S0;
    end else begin
      current_state <= next_state;
    end
  end
endmodule

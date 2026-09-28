module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  reg [2:0] state;

  // Define the state encoding for the sequence detector
  localparam S0 = 3'b000,
             S1 = 3'b001,
             S2 = 3'b101,
             S3 = 3'b110,
             S4 = 3'b011,
             DETECT = 3'b111; // State to indicate a sequence has been detected

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      sequence_found <= 0;
      state <= S0;
    end else begin
      case (state)
        S0: if (data == S1) state <= S1; 
            else if (data == S2) state <= S2;
            else if (data == S3) state <= S3;
            else if (data == S4) state <= S4;

        S1: if (data == S2) state <= S2; else state <= S0;
        S2: if (data == S3) state <= S3; else state <= S0;
        S3: if (data == S4) state <= S4; else state <= S0;
        S4: if (data == S1) begin
              sequence_found <= 1;
              state <= DETECT; // Move to DETECT state
            end else if (data == S2) begin
              sequence_found <= 1;
              state <= DETECT; // Move to DETECT state
            end else begin
              state <= S0;
            end
        
        DETECT: begin
          sequence_found <= 0; // Reset the sequence found signal
          state <= S0; // Transition back to initial state
        end

        default: state <= S0;
      endcase
    end
  end
endmodule

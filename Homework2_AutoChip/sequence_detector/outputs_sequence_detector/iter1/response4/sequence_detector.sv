module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  reg [2:0] state;
  
  // Define the sequence pattern
  localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b101, S3 = 3'b110, S4 = 3'b011;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      sequence_found <= 0;
      state <= S0;
    end else begin
      case (state)
        S0: begin
          if (data == S1) state <= S1;
          else if (data == S2) state <= S2;
          else if (data == S4) state <= S4; // Check for the transition to S4
          else state <= S0;
          sequence_found <= 0;
        end
        S1: begin
          if (data == S2) state <= S2;
          else if (data == S0) state <= S0;
          sequence_found <= 0;
        end
        S2: begin
          if (data == S3) state <= S3;
          else state <= S0;
          sequence_found <= 0;
        end
        S3: begin
          if (data == S4) state <= S4;
          else state <= S0;
          sequence_found <= 0;
        end
        S4: begin
          if (data == S1 || data == S2 || data == S3) begin
            sequence_found <= 1; // Found the sequence
            state <= S0; 
          end else begin
            state <= S0;
          end
        end
        default: state <= S0;
      endcase
    end
  end
endmodule

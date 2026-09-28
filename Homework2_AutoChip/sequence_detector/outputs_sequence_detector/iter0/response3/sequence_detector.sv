module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);
  reg [2:0] state, next_state;
  
  // State encoding
  localparam S0 = 3'b000,
             S1 = 3'b001,
             S2 = 3'b010,
             S3 = 3'b011,
             S4 = 3'b100,
             S5 = 3'b101,
             S6 = 3'b110,
             S7 = 3'b111;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= S0;
      sequence_found <= 0;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    case (state)
      S0: if (data == 3'b001) next_state = S1; else next_state = S0;
      S1: if (data == 3'b101) next_state = S2; else next_state = S0;
      S2: if (data == 3'b110) next_state = S3; else next_state = S0;
      S3: if (data == 3'b000) next_state = S4; else next_state = S0;
      S4: if (data == 3'b110) next_state = S5; else next_state = S0;
      S5: if (data == 3'b110) next_state = S6; else next_state = S0;
      S6: if (data == 3'b011) next_state = S7; else next_state = S0;
      S7: if (data == 3'b101) begin
            sequence_found = 1;
            next_state = S0; 
          end else begin
            next_state = S0; 
            sequence_found = 0;
          end
      default: begin
        next_state = S0;
        sequence_found = 0;
      end
    endcase
  end

endmodule

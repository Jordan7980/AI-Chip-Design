module sequence_detector(
  input clk,
  input reset_n,
  input [2:0] data,
  output reg sequence_found
);

  reg [2:0] state, next_state;

  // State encoding
  parameter IDLE = 3'b000;
  parameter S1   = 3'b001;
  parameter S2   = 3'b101;
  parameter S3   = 3'b110;
  parameter S4   = 3'b000;
  parameter S5   = 3'b110;
  parameter S6   = 3'b110;
  parameter S7   = 3'b011;
  parameter S8   = 3'b101;

  // Sequential logic to update state
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= IDLE;
      sequence_found <= 0;
    end else begin
      state <= next_state;
    end
  end

  // Combinational logic to determine the next state and sequence found
  always @(*) begin
    case (state)
      IDLE: begin
        if (data == 3'b001) begin
          next_state = S1;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S1: begin
        if (data == 3'b101) begin
          next_state = S2;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S2: begin
        if (data == 3'b110) begin
          next_state = S3;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S3: begin
        if (data == 3'b000) begin
          next_state = S4;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S4: begin
        if (data == 3'b110) begin
          next_state = S5;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S5: begin
        if (data == 3'b110) begin
          next_state = S6;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S6: begin
        if (data == 3'b011) begin
          next_state = S7;
          sequence_found = 0;
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      S7: begin
        if (data == 3'b101) begin
          next_state = S8;
          sequence_found = 1; // Sequence found
        end else begin
          next_state = IDLE;
          sequence_found = 0;
        end
      end
      default: begin
        next_state = IDLE;
        sequence_found = 0;
      end
    endcase
  end

endmodule

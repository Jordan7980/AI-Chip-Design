
module sequence_detector (
    input wire clk,
    input wire reset_n,  // Active-low reset
    input wire [2:0] data,  // 3-bit input data
    output reg sequence_found // Output indicating the sequence is found
);

// Define the states using parameters
parameter S0 = 3'b000; // Initial state
parameter S1 = 3'b001; // After receiving 0b001
parameter S2 = 3'b010; // After receiving 0b101
parameter S3 = 3'b011; // After receiving 0b110 first time
parameter S4 = 3'b100; // After receiving 0b000
parameter S5 = 3'b101; // After receiving 0b110 second time
parameter S6 = 3'b110; // After receiving 0b011
parameter S7 = 3'b111; // After receiving 0b101 again

reg [2:0] current_state, next_state;

// Combinational logic for state transition
always @* begin
    case (current_state)
        S0: next_state = (data == 3'b001) ? S1 : S0; // Start with 0b001
        S1: next_state = (data == 3'b101) ? S2 : S0; // After 0b001, expect 0b101
        S2: next_state = (data == 3'b110) ? S3 : S0; // After 0b101, expect 0b110
        S3: next_state = (data == 3'b000) ? S4 : S0; // After 0b110, expect 0b000
        S4: next_state = (data == 3'b110) ? S5 : S0; // After 0b000, expect 0b110
        S5: next_state = (data == 3'b110) ? S5 : S6; // Stay on 0b110
        S6: next_state = (data == 3'b011) ? S7 : S0; // After 0b110, expect 0b011
        S7: next_state = (data == 3'b101) ? S2 : S0; // After 0b011, expect 0b101
        default: next_state = S0;
    endcase
end

// Sequential logic for state update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= S0;
        sequence_found <= 0;
    end else begin
        current_state <= next_state;
        // Output a signal indicating that the complete sequence was found
        sequence_found <= (current_state == S7); // There is a full sequence at S7
    end
end

endmodule

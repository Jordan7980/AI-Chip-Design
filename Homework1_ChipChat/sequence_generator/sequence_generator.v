
module sequence_generator (
    input wire clk,               // Clock input
    input wire reset_n,           // Active-low reset input
    input wire enable,            // Enable input
    output reg [7:0] data         // 8-bit output data
);

// Define states for the FSM using parameters
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam S6 = 3'b110;
localparam S7 = 3'b111;

// Current state variable
reg [2:0] state, next_state;

// Counter for state transitions
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= S0; // Reset to initial state
        data <= 8'b0; // Reset output data to 0 on reset
    end else if (enable) begin
        state <= next_state; // Transition to next state on clock edge if enabled
    end
end

// Define the next state logic and output data depending on the current state
always @(*) begin
    // Default assignments
    next_state = state;

    // Output data and state transition logic based on the current state
    if (enable) begin
        case (state)
            S0: begin
                next_state = S1;
                data = 8'hAF; // 0xAF
            end
            S1: begin
                next_state = S2;
                data = 8'hBC; // 0xBC
            end
            S2: begin
                next_state = S3;
                data = 8'hE2; // 0xE2
            end
            S3: begin
                next_state = S4;
                data = 8'h78; // 0x78
            end
            S4: begin
                next_state = S5;
                data = 8'hFF; // 0xFF
            end
            S5: begin
                next_state = S6;
                data = 8'hE2; // 0xE2
            end
            S6: begin
                next_state = S7;
                data = 8'h0B; // 0x0B
            end
            S7: begin
                next_state = S0; // Go back to the first state
                data = 8'h8D; // 0x8D
            end
            default: begin
                next_state = S0; // Default to first state
                data = 8'b0; // Unused state
            end
        endcase
    end else begin
        // Hold the last value when not enabled
        data = data; // This line helps convey intention but actually has no effect
    end
end

endmodule

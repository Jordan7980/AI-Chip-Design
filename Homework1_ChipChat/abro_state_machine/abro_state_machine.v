
module abro_fsm (
    input wire clk,           // Clock input
    input wire reset_n,      // Active-low reset
    input wire A,            // Input A
    input wire B,            // Input B
    output reg O,            // Main output
    output reg [3:0] state   // Current state output (4 states max)
);

    // State Encoding
    parameter IDLE      = 4'b0001; // State 0
    parameter STATE_A  = 4'b0010; // State 1
    parameter STATE_B  = 4'b0100; // State 2
    parameter STATE_AB = 4'b1000; // State 3

    reg [3:0] current_state, next_state;

    // Sequential logic: State register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE; // Reset to IDLE state
        else
            current_state <= next_state; // Transition to the next state
    end

    // Combinatorial logic: Next state and output logic
    always @(*) begin
        // Default values
        next_state = current_state; // Stay in the current state by default
        O = 1'b0; // Default output to 0

        case (current_state)
            IDLE: begin
                if (A) begin
                    next_state = STATE_A;
                    O = 1'b1; // Output is 1 when transitioning from IDLE to STATE_A
                end
                else if (B) begin
                    next_state = STATE_B;
                    O = 1'b1; // Output is 1 when transitioning from IDLE to STATE_B
                end
            end
            STATE_A: begin
                if (B) begin
                    next_state = STATE_AB;
                    O = 1'b1; // Output 1 when entering STATE_AB
                end
                else if (!A) begin
                    next_state = IDLE; // Back to IDLE if A goes low
                end
            end
            STATE_B: begin
                if (A) begin
                    next_state = STATE_AB;
                    O = 1'b1; // Output 1 when entering STATE_AB
                end
                else if (!B) begin
                    next_state = IDLE; // Back to IDLE if B goes low
                end
            end
            STATE_AB: begin
                if (!A && !B) begin
                    next_state = IDLE; // Back to IDLE if both A and B go low
                end
                // Keep STATE_AB until both inputs are low
            end
            default: begin
                next_state = IDLE; // Default to IDLE state
            end
        endcase
    end

    // State output
    always @(*) begin
        case (current_state)
            IDLE:   state = IDLE;
            STATE_A: state = STATE_A;
            STATE_B: state = STATE_B;
            STATE_AB: state = STATE_AB;
            default: state = IDLE;  // This should not occur
        endcase
    end

endmodule

module abro_state_machine (
    input wire clk,
    input wire rst_n,
    input wire A,
    input wire B,
    output wire O,
    output wire [3:0] State
);
    abro_fsm core (
        .clk(clk),
        .reset_n(rst_n),
        .A(A),
        .B(B),
        .O(O),
        .state(State)
    );
endmodule

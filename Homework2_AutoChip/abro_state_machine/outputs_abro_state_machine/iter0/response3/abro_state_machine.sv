module abro_state_machine(
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    localparam IDLE = 4'b0001;
    localparam STATE_A = 4'b0010;
    localparam STATE_B = 4'b0100;
    localparam STATE_AB = 4'b1000;

    // State register
    reg [3:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE; // Reset to IDLE state
        else
            current_state <= next_state; // Update state
    end

    // Combinational logic for determining next state and output
    always @(*) begin
        // Default values
        next_state = current_state;
        O = 0; // Default output

        case (current_state)
            IDLE: begin
                if (A && !B)
                    next_state = STATE_A;
                else if (!A && B)
                    next_state = STATE_B;
            end
            
            STATE_A: begin
                O = 1; // Output logic for STATE_A
                if (B)
                    next_state = STATE_AB; // Transition to STATE_AB
                else if (!A)
                    next_state = IDLE; // Transition back to IDLE
            end
            
            STATE_B: begin
                O = 1; // Output logic for STATE_B
                if (A)
                    next_state = STATE_AB; // Transition to STATE_AB
                else if (!B)
                    next_state = IDLE; // Transition back to IDLE
            end
            
            STATE_AB: begin
                O = 1; // Output logic for STATE_AB
                if (!A && !B)
                    next_state = IDLE; // Transition back to IDLE
            end
            
            default: next_state = IDLE; // Fallback case
        endcase
    end

    // Output the current state for verification
    always @(*) begin
        State = current_state; // Output the current state
    end

endmodule

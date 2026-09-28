module abro_state_machine(
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);

typedef enum logic [3:0] {
    S0 = 4'b0001, // State 0
    S1 = 4'b0010, // State 1
    S2 = 4'b0100, // State 2
    S3 = 4'b1000  // State 3
} state_t;

state_t current_state, next_state;

// State update logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        current_state <= S0; // Reset to initial state
    else 
        current_state <= next_state;
end

// Next state logic
always_comb begin
    // Default values
    next_state = current_state; // Hold current state
    O = 1'b0; // Default output

    case (current_state)
        S0: begin
            if (A) next_state = S1;
        end
        S1: begin
            if (B) next_state = S2;
        end
        S2: begin
            if (A && B) next_state = S3;
        end
        S3: begin
            O = 1'b1; // Output O high in state S3
            if (A && !B) next_state = S1; // Transition back to S1 if A=1, B=0
            else if (!A && !B) next_state = S2; // Transition to S2 if A=0, B=0
            else next_state = S0; // Transition to S0 if otherwise
        end
        default: next_state = S0; // Safety default
    endcase
end

// Output current state
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        State <= S0; // Start in state S0
    else 
        State <= current_state;
end

endmodule

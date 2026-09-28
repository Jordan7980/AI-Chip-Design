module abro_state_machine(
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);

// State encoding
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
    O = 1'b0;
    next_state = current_state; // Stay in the same state unless conditions change

    case (current_state)
        S0: begin
            if (A) 
                next_state = S1; 
        end
        S1: begin
            O = 1'b0; // Output in S1 is low
            if (B) 
                next_state = S2; 
        end
        S2: begin
            O = 1'b0; // Output in S2 is low
            if (A) 
                next_state = S3; 
        end
        S3: begin
            O = 1'b1; // Output O high in state S3
            next_state = S2; // Transition back to S2
        end
        default: next_state = S0; // Safety default
    endcase
end

// Output current state
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        State <= 4'b0000;
    else 
        State <= current_state;
end

endmodule

module abro_state_machine(
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);

    // State encoding
    parameter S0 = 4'b0001;
    parameter S1 = 4'b0010;
    parameter S2 = 4'b0100;
    parameter S3 = 4'b1000;

    reg [3:0] current_state, next_state;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;  // Reset state
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (A)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (B)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                next_state = S3; // Move to S3 directly on any condition
            end
            S3: begin
                if (!A && !B)
                    next_state = S0; // Return to S0 if both A and B are low
                else
                    next_state = S3;
            end
            default: next_state = S0; // Default to S0
        endcase
    end

    // Output logic
    always @(*) begin
        O = (current_state == S3); // Output high when in state S3
    end

    // Assign current state to output
    always @(*) begin
        State = current_state;
    end

endmodule

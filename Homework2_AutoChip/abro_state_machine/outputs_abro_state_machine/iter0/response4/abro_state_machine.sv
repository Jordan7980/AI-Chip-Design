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

    // Internal state variable
    reg [3:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            S0: begin
                O = 0;
                if (A && !B)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                O = 0;
                if (!A && B)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                O = 1;
                if (A && B)
                    next_state = S3;
                else
                    next_state = S2;
            end
            S3: begin
                O = 1;
                if (!A && !B)
                    next_state = S0;
                else
                    next_state = S3;
            end
            default: next_state = S0;
        endcase
    end

    // Output the current state
    always @(*) begin
        State = current_state;
    end

endmodule

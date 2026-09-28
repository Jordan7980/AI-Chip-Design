module abro_state_machine(
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);

    // State Encoding
    parameter S0 = 4'b0001, // State 0
              S1 = 4'b0010, // State 1
              S2 = 4'b0100, // State 2
              S3 = 4'b1000; // State 3

    // State variable
    reg [3:0] current_state, next_state;

    // Sequential logic: State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Combinational logic: Next state and output logic
    always @(*) begin
        case (current_state)
            S0: begin
                O = 0;
                if (A) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                O = 0;
                if (B) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                O = 1;
                if (A) next_state = S3;
                else next_state = S2;
            end
            S3: begin
                O = 1;
                if (!A) next_state = S0;
                else next_state = S3;
            end
            default: begin
                O = 0;
                next_state = S0;
            end
        endcase
    end

    // Output the current state
    assign State = current_state;

endmodule

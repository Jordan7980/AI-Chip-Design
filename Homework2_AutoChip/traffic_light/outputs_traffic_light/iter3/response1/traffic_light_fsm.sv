module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);

    typedef enum reg [1:0] {RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10} state_t;
    state_t state, next_state;
    reg [5:0] counter; // 6 bits to count up to 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 0;
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state;
                case (next_state)
                    RED: counter <= 32;       // Set counter for RED to GREEN transition
                    GREEN: counter <= 20;     // Set counter for GREEN to YELLOW transition
                    YELLOW: counter <= 7;      // Set counter for YELLOW to RED transition
                endcase
            end
        end
    end

    always @(*) begin
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;
        next_state = state; // Maintain the current state by default

        case (state)
            RED: begin
                red = 1;
                next_state = GREEN; // Prepare to transition to GREEN new state
            end
            GREEN: begin
                green = 1;
                next_state = YELLOW; // Prepare to transition to YELLOW new state
            end
            YELLOW: begin
                yellow = 1;
                next_state = RED; // Prepare to transition back to RED new state
            end
        endcase
    end

    always @(posedge clk) begin
        if (enable) begin
            case (state)
                RED: begin
                    if (counter == 1) next_state <= GREEN; // Transition to GREEN only when counter reaches 1
                end
                GREEN: begin
                    if (counter == 1) next_state <= YELLOW; // Transition to YELLOW only when counter reaches 1
                end
                YELLOW: begin
                    if (counter == 1) next_state <= RED; // Transition to RED only when counter reaches 1
                end
            endcase
        end
    end
endmodule

module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    // State declaration
    typedef enum reg [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;
    integer counter;

    // Sequential block for state transitions
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == RED) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Combinational block for next state logic
    always @(*) begin
        case (current_state)
            RED: begin
                if (counter < 31) begin
                    next_state = RED;
                end else begin
                    next_state = GREEN;
                end
                red = 1;
                yellow = 0;
                green = 0;
            end
            
            GREEN: begin
                if (counter < 19) begin
                    next_state = GREEN;
                end else begin
                    next_state = YELLOW;
                end
                red = 0;
                yellow = 0;
                green = 1;
            end
            
            YELLOW: begin
                if (counter < 6) begin
                    next_state = YELLOW;
                end else begin
                    next_state = RED;
                end
                red = 0;
                yellow = 1;
                green = 0;
            end
            
            default: begin
                next_state = RED;
                red = 1;
                yellow = 0;
                green = 0;
            end
        endcase
    end
endmodule

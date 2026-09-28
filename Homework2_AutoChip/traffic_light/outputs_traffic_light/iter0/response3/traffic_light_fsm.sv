module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    
    typedef enum reg [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;
    
    reg [4:0] counter;  // 5 bits to count up to 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == RED) begin
                counter <= counter + 1;
            end else if (current_state == GREEN) begin
                counter <= counter + 1;
            end else if (current_state == YELLOW) begin
                counter <= counter + 1;
            end
            
            if (current_state == RED && counter >= 32) begin
                counter <= 0;
                next_state <= GREEN;
            end else if (current_state == GREEN && counter >= 20) begin
                counter <= 0;
                next_state <= YELLOW;
            end else if (current_state == YELLOW && counter >= 7) begin
                counter <= 0;
                next_state <= RED;
            end else begin
                next_state <= current_state; // stay in current state
            end
        end
    end

    always @(current_state) begin
        case (current_state)
            RED: begin
                red = 1;
                yellow = 0;
                green = 0;
            end
            GREEN: begin
                red = 0;
                yellow = 0;
                green = 1;
            end
            YELLOW: begin
                red = 0;
                yellow = 1;
                green = 0;
            end
            default: begin
                red = 0;
                yellow = 0;
                green = 0;
            end
        endcase
    end

endmodule

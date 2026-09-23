
module TrafficLightController (
    input wire clk,           // Clock signal
    input wire rst_n,         // Active-low reset
    input wire enable,        // Enable signal
    output reg red,          // Red light output
    output reg yellow,       // Yellow light output
    output reg green         // Green light output
);

    // State definitions
    parameter RED    = 2'b00;
    parameter GREEN  = 2'b01;
    parameter YELLOW = 2'b10;

    reg [1:0] state, next_state;
    reg [4:0] counter; // Counter to track clock pulses

    // Sequential logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;      // Reset to Red state
            counter <= 0;      // Reset the counter
        end else if (enable) begin
            if (counter == get_cycle_count(state)) begin
                state <= next_state; // Go to the next state
                counter <= 0;         // Reset the counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;
        next_state = state; // Default to hold current state

        case (state)
            RED: begin
                red = 1; // Red light is on
                next_state = GREEN; // Next state is green
            end
            GREEN: begin
                green = 1; // Green light is on
                next_state = YELLOW; // Next state is yellow
            end
            YELLOW: begin
                yellow = 1; // Yellow light is on
                next_state = RED; // Next state is red
            end
            default: begin
                next_state = RED; // Default to red in case of unexpected state
            end
        endcase
    end

    // Function to return the count based on the current state
    function [4:0] get_cycle_count(input [1:0] current_state);
        begin
            case (current_state)
                RED:    get_cycle_count = 32;  // Red to Green: 32 cycles
                GREEN:  get_cycle_count = 20;  // Green to Yellow: 20 cycles
                YELLOW: get_cycle_count = 7;   // Yellow to Red: 7 cycles
                default: get_cycle_count = 0;  // Fallback case
            endcase
        end
    endfunction

endmodule

module traffic_light_fsm (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output wire red,
    output wire yellow,
    output wire green
);
    TrafficLightController core (
        .clk(clk),
        .rst_n(reset_n),
        .enable(enable),
        .red(red),
        .yellow(yellow),
        .green(green)
    );
endmodule

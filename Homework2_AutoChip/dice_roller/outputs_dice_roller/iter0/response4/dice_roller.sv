module dice_roller(
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);

    reg [7:0] max_value; // Maximum value based on the selected die
    reg roll_triggered; // Internal flag for roll event

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;
            max_value <= 8'b0;
            roll_triggered <= 1'b0;
        end else begin
            // Set max_value based on die_select
            case (die_select)
                2'b00: max_value <= 4;   // 4-sided die
                2'b01: max_value <= 6;   // 6-sided die
                2'b10: max_value <= 8;   // 8-sided die
                2'b11: max_value <= 20;  // 20-sided die
                default: max_value <= 0;  // Default case
            endcase
            
            // Trigger rolling when roll signal is high
            if (roll && !roll_triggered) begin
                rolled_number <= $urandom % max_value + 1; // Generate random number between 1 and max_value
            end
            roll_triggered <= roll; // Update roll_triggered to the current roll state
        end
    end
endmodule

module dice_roller(
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);
    reg [7:0] max_value;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;
        end else if (roll) begin
            case (die_select)
                2'b00: max_value = 4;    // 4-sided die
                2'b01: max_value = 6;    // 6-sided die
                2'b10: max_value = 8;    // 8-sided die
                2'b11: max_value = 20;   // 20-sided die
                default: max_value = 4; // Default to 4-sided die
            endcase
            rolled_number <= $urandom_range(1, max_value); // Generate random number
        end
    end
endmodule


module shift_register (
    input wire clk,          // Clock input
    input wire reset_n,       // Active-low reset
    input wire data_in,     // 1-bit data input
    input wire shift_enable, // Shift enable signal
    output reg [7:0] data_out // 8-bit data output
);

// On the rising edge of the clock
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // If reset is active (low), clear the shift register
        data_out <= 8'b0;
    end else if (shift_enable) begin
        // Shift data to the left and insert new data at the LSB
        data_out <= {data_out[6:0], data_in}; // Shift left and add data_in at LSB
    end
end

endmodule

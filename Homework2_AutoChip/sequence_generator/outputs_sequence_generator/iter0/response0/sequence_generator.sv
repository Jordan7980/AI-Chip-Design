module sequence_generator(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);
    // State definition
    reg [2:0] state;
    reg [7:0] seq [0:7]; // Sequence array to hold the predefined values

    initial begin
        seq[0] = 8'hAF;
        seq[1] = 8'hBC;
        seq[2] = 8'hE2;
        seq[3] = 8'h78;
        seq[4] = 8'hFF;
        seq[5] = 8'hE2;
        seq[6] = 8'h0B;
        seq[7] = 8'h8D;
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 3'b000; // Reset state
            data <= 8'h00;   // Set data to initial value
        end else if (enable) begin
            data <= seq[state]; // Output the current sequence value
            state <= (state + 1) % 8; // Increment state and wrap around after 7
        end
    end
endmodule

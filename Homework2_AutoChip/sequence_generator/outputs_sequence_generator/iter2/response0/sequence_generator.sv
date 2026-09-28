module sequence_generator(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);
    reg [2:0] state;

    // Define the states for the sequence
    localparam S0 = 3'b000; // 0xAF
    localparam S1 = 3'b001; // 0xBC
    localparam S2 = 3'b010; // 0xE2
    localparam S3 = 3'b011; // 0x78
    localparam S4 = 3'b100; // 0xFF
    localparam S5 = 3'b101; // 0xE2
    localparam S6 = 3'b110; // 0x0B
    localparam S7 = 3'b111; // 0x8D

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= S0; // Reset to the first state
            data <= 8'hAF; // Initial data value
        end else if (enable) begin
            case (state)
                S0: begin
                    data <= 8'hAF;
                    state <= S1;
                end
                S1: begin
                    data <= 8'hBC;
                    state <= S2;
                end
                S2: begin
                    data <= 8'hE2;
                    state <= S3;
                end
                S3: begin
                    data <= 8'h78;
                    state <= S4;
                end
                S4: begin
                    data <= 8'hFF;
                    state <= S5;
                end
                S5: begin
                    data <= 8'hE2;
                    state <= S6;
                end
                S6: begin
                    data <= 8'h0B;
                    state <= S7;
                end
                S7: begin
                    data <= 8'h8D;
                    state <= S0; // Loop back to first state
                end
            endcase
        end
    end

    // In case the generator is disabled, maintain the last output value
    always @(posedge clk) begin
        if (!enable) begin
            // Do nothing, hold the current data value
        end
    end
endmodule

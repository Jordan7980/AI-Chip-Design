module sequence_generator(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);

    reg [2:0] count;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 3'b000;
            data <= 8'h00;
        end else if (enable) begin
            case (count)
                3'b000: data <= 8'hAF;
                3'b001: data <= 8'hBC;
                3'b010: data <= 8'hE2;
                3'b011: data <= 8'h78;
                3'b100: data <= 8'hFF;
                3'b101: data <= 8'hE2;
                3'b110: data <= 8'h0B;
                3'b111: data <= 8'h8D;
            endcase
            count <= count + 1'b1;
            if (count == 3'b111) begin
                count <= 3'b000;
            end
        end
    end

endmodule

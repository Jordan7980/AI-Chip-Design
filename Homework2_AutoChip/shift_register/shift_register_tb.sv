`timescale 1ns/1ps

module tb;                       // renamed from tb_shift_register
integer errors = 0;              // count errors instead of stopping

    reg clk;
    reg reset_n;
    reg data_in;
    reg shift_enable;
    wire [7:0] data_out;

    shift_register dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    always begin
        #5 clk = ~clk;
    end

    // Test case data (bit i / byte i is used on step i)
    reg [7:0]  test_case_reset_n      = 8'b10111111;
    reg [7:0]  test_case_data_in      = 8'b11001011;
    reg [7:0]  test_case_shift_enable = 8'b10111110;
    reg [63:0] test_case_data_out     = 64'h80002850a0408000;

    integer i = 0;

    initial begin
        clk = 0;
        reset_n = 0;
        data_in = 0;
        shift_enable = 0;

        @(posedge clk)
        @(negedge clk)

        for (i = 0; i < 8; i = i + 1) begin
            reset_n <= test_case_reset_n[i];
            data_in <= test_case_data_in[i];
            shift_enable <= test_case_shift_enable[i];
            @(negedge clk)

            if (data_out !== test_case_data_out[8*i+:8]) begin
                $display("Error: Test case %0d failed (reset_n=%b, data_in=%b, shift_enable=%b). Expected: %b, Got: %b",
                         i, test_case_reset_n[i], test_case_data_in[i], test_case_shift_enable[i],
                         test_case_data_out[8*i+:8], data_out);
                
                errors = errors + 1;     // was: $finish;
                
            end
        end

        $finish;
    end


final begin
    $display("Mismatches: %0d in %0d samples", errors, 8);
end

endmodule

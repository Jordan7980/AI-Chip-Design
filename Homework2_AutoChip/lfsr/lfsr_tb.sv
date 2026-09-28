`timescale 1ns / 1ps
//==================================================
module tb;                       // renamed from tb_lfsr
integer errors = 0;              // count errors instead of stopping
//==================================================
    reg clk;
    reg reset_n;
    wire [7:0] data;

    lfsr lfsr_inst (
        .clk(clk),
        .reset_n(reset_n),
        .data(data)
    );

    always begin
        #5 clk = ~clk;
    end

    integer i;
    reg [7:0] data_expected;

    function [7:0] reference_lfsr_output;
        input [7:0] current_state;
        begin
            reference_lfsr_output = {current_state[6:0], current_state[0] ^ current_state[3] ^ current_state[5] ^ current_state[6]};
        end
    endfunction

    initial begin
        clk = 0;
        reset_n = 0;

        #5 reset_n = 1;

        // Initial state check
        if (data !== 8'b10001010) begin
            $display("Error: At time %t, data = %b, expected = 10001010", $time, data);
            //==================================================
            errors = errors + 1;     // was: $finish;
            //==================================================
        end

        data_expected = 8'b10001010;

        for (i = 0; i < 256; i = i + 1) begin
            data_expected = reference_lfsr_output(data_expected);

            #10;

            if (data !== data_expected) begin
                //==================================================
                if (errors < 10)             // only print the first 10 errors
                //==================================================
                $display("Error: At time %t, data = %b, expected = %b", $time, data, data_expected);
                //==================================================
                errors = errors + 1;     // was: $finish;
                //==================================================
            end
        end

        $finish;
    end

//==================================================
final begin
    $display("Mismatches: %0d in %0d samples", errors, 257);
end
//==================================================
endmodule

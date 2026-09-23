`timescale 1ns/1ps

module tb_shift_register();
    reg clk;
    reg reset_n;
    reg data_in;
    reg shift_enable;
    wire [7:0] data_out;

    // Instantiate the shift_register
    shift_register dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    
    // ADDED: reference model - what data_out SHOULD be each cycle
    reg [7:0] expected;
    integer i;
    integer errors;
    

    // Test runner
    initial begin
        clk = 1;
        reset_n = 1;
        data_in = 0;
        shift_enable = 0;

        // ADDED: reset first so data_out has a known value
        errors = 0;
        reset_n <= 0;
        @(posedge clk);
        #1;
        expected = 8'b0;
        if (data_out !== expected) begin
            $display("Error: Reset failed. Expected: %b, Got: %b", expected, data_out);
            errors = errors + 1;
        end
        reset_n <= 1;

        // Drive random inputs, update the model, then compare
        for (i = 0; i < 20; i = i + 1) begin
            data_in      <= $random;
            shift_enable <= $random;
            @(posedge clk);
            #1; // let the DUT's nonblocking update finish before checking

            if (shift_enable)
                expected = {expected[6:0], data_in};

            if (data_out !== expected) begin
                $display("Error: Test case %0d failed. Expected: %b, Got: %b", i, expected, data_out);
                errors = errors + 1;
            end
        end

        // Mid-run reset check
        reset_n <= 0;
        #1;
        expected = 8'b0;
        if (data_out !== expected) begin
            $display("Error: Async reset failed. Expected: %b, Got: %b", expected, data_out);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("All test cases passed!");
        else
            $display("%0d test case(s) failed.", errors);
        $finish;
      
    end
endmodule
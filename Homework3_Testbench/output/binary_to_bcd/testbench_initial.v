module tb_binary_to_bcd_converter;

    // Declare testbench signals
    reg [4:0] binary_input;
    wire [7:0] bcd_output;

    // Instantiate the module under test
    binary_to_bcd_converter uut (
        .binary_input(binary_input),
        .bcd_output(bcd_output)
    );

    initial begin
        // Test case 1: Minimum input value
        binary_input = 5'b00000;
        #10;
        $display("Test 1: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 2: Maximum input value
        binary_input = 5'b11111;
        #10;
        $display("Test 2: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 3: Boundary value (just before 10 in decimal)
        binary_input = 5'b01001;
        #10;
        $display("Test 3: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 4: Boundary value (10 in decimal)
        binary_input = 5'b01010;
        #10;
        $display("Test 4: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 5: Typical use case (13 in decimal)
        binary_input = 5'b01101;
        #10;
        $display("Test 5: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 6: Edge case (1 in decimal)
        binary_input = 5'b00001;
        #10;
        $display("Test 6: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 7: Random value
        binary_input = 5'b00111;
        #10;
        $display("Test 7: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 8: Random value
        binary_input = 5'b10100;
        #10;
        $display("Test 8: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 9: Random value
        binary_input = 5'b10001;
        #10;
        $display("Test 9: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        // Test case 10: Random value
        binary_input = 5'b01011;
        #10;
        $display("Test 10: binary_input = %b, bcd_output = %b", binary_input, bcd_output);

        $finish;
    end

endmodule
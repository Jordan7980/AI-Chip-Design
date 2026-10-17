module tb_priority_encoder8;
    reg [7:0] req;
    wire [2:0] idx;
    wire valid;
    integer passed_tests, failed_tests;

    // Instantiate the module under test
    priority_encoder8 uut (
        .req(req),
        .idx(idx),
        .valid(valid)
    );

    initial begin
        passed_tests = 0;
        failed_tests = 0;

        // Test Pattern 1: Corner case - no request
        req = 8'b00000000;
        #10;
        $display("Test 1: req = %b", req);
        if (idx === 3'b000 && valid === 1'b0) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 000), valid = %b (expected 0)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        // Test Pattern 2: Corner case - all requests
        req = 8'b11111111;
        #10;
        $display("Test 2: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        // Test Pattern 3-10: One-hot values
        req = 8'b00000001;
        #10;
        $display("Test 3: req = %b", req);
        if (idx === 3'b000 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 000), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00000010;
        #10;
        $display("Test 4: req = %b", req);
        if (idx === 3'b001 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 001), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00000100;
        #10;
        $display("Test 5: req = %b", req);
        if (idx === 3'b010 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 010), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00001000;
        #10;
        $display("Test 6: req = %b", req);
        if (idx === 3'b011 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 011), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00010000;
        #10;
        $display("Test 7: req = %b", req);
        if (idx === 3'b100 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 100), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00100000;
        #10;
        $display("Test 8: req = %b", req);
        if (idx === 3'b101 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 101), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b01000000;
        #10;
        $display("Test 9: req = %b", req);
        if (idx === 3'b110 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 110), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b10000000;
        #10;
        $display("Test 10: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        // Test Pattern 11-18: Bit 0 with one higher bit set
        req = 8'b00000011;
        #10;
        $display("Test 11: req = %b", req);
        if (idx === 3'b001 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 001), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00000101;
        #10;
        $display("Test 12: req = %b", req);
        if (idx === 3'b010 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 010), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00001001;
        #10;
        $display("Test 13: req = %b", req);
        if (idx === 3'b011 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 011), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00010001;
        #10;
        $display("Test 14: req = %b", req);
        if (idx === 3'b100 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 100), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00100001;
        #10;
        $display("Test 15: req = %b", req);
        if (idx === 3'b101 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 101), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b01000001;
        #10;
        $display("Test 16: req = %b", req);
        if (idx === 3'b110 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 110), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b10000001;
        #10;
        $display("Test 17: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00000001;
        #10;
        $display("Test 18: req = %b", req);
        if (idx === 3'b000 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 000), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        // Test Pattern 19-28: Random values
        req = 8'b11010101;
        #10;
        $display("Test 19: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b10101010;
        #10;
        $display("Test 20: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b11100000;
        #10;
        $display("Test 21: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00111100;
        #10;
        $display("Test 22: req = %b", req);
        if (idx === 3'b101 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 101), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b11111100;
        #10;
        $display("Test 23: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b01111110;
        #10;
        $display("Test 24: req = %b", req);
        if (idx === 3'b110 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 110), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b11101111;
        #10;
        $display("Test 25: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b00011111;
        #10;
        $display("Test 26: req = %b", req);
        if (idx === 3'b100 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 100), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b10110011;
        #10;
        $display("Test 27: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        req = 8'b11011011;
        #10;
        $display("Test 28: req = %b", req);
        if (idx === 3'b111 && valid === 1'b1) begin
            $display("  ✓ idx = %b, valid = %b", idx, valid);
            passed_tests = passed_tests + 1;
        end else begin
            $display("  ✗ idx = %b (expected 111), valid = %b (expected 1)", idx, valid);
            failed_tests = failed_tests + 1;
        end

        // Test summary
        $display("Test Summary: Total = %d, Passed = %d, Failed = %d", passed_tests + failed_tests, passed_tests, failed_tests);

        $finish;
    end
endmodule
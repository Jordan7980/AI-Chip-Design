`timescale 1ns/1ps

module tb;                       // renamed from tb_sequence_detector
integer errors = 0;              // count errors instead of stopping

    reg clk;
    reg reset_n;
    reg [2:0] data;
    wire sequence_found;

    sequence_detector dut (
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .sequence_found(sequence_found)
    );

    always begin
        #5 clk = ~clk;
    end

    task apply_stimulus;
        input [2:0] data_value;
        input integer delay_cycles;
        begin
            data <= data_value;
            repeat (delay_cycles) @(posedge clk);
        end
    endtask

    task check_output;
        input integer cycle;
        input expected_value;
        begin
            if (sequence_found !== expected_value) begin
                $display("Error: Cycle %0d (data=%b), Expected: %b, Got: %b", cycle, data, expected_value, sequence_found);
                
                errors = errors + 1;     // was: $finish;
                
            end
        end
    endtask

    initial begin
        clk <= 0;
        reset_n <= 0;
        data <= 3'b000;

        @(posedge clk);
        reset_n <= 1;

        // Correct sequence
        apply_stimulus(3'b001, 1); check_output(1, 1'b0);
        apply_stimulus(3'b101, 1); check_output(2, 1'b0);
        apply_stimulus(3'b110, 1); check_output(3, 1'b0);
        apply_stimulus(3'b000, 1); check_output(4, 1'b0);
        apply_stimulus(3'b110, 1); check_output(5, 1'b0);
        apply_stimulus(3'b110, 1); check_output(6, 1'b0);
        apply_stimulus(3'b011, 1); check_output(7, 1'b0);
        apply_stimulus(3'b101, 1); check_output(8, 1'b1);

        // Incorrect sequence
        apply_stimulus(3'b001, 1); check_output(9, 1'b0);
        apply_stimulus(3'b101, 1); check_output(10, 1'b0);
        apply_stimulus(3'b010, 1); check_output(11, 1'b0);
        apply_stimulus(3'b000, 1); check_output(12, 1'b0);

        $finish;
    end


final begin
    $display("Mismatches: %0d in %0d samples", errors, 12);
end

endmodule

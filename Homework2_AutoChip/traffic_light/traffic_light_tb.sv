`timescale 1ps/1ps
//==================================================
module tb;                       // renamed from tb_traffic_light_fsm
//==================================================

reg clk;
reg reset_n;
reg enable;
wire red;
wire yellow;
wire green;

integer error_count;

traffic_light_fsm traffic_light (
    .clk(clk),
    .reset_n(reset_n),
    .enable(enable),
    .red(red),
    .yellow(yellow),
    .green(green)
);

always begin
    #5 clk = ~clk;
end

task check_output;
    input integer cycle;
    input logic exp_red;
    input logic exp_yellow;
    input logic exp_green;
    input integer test_case;
begin
    @(negedge clk);
    if (red !== exp_red || yellow !== exp_yellow || green !== exp_green) begin
        $display("Error: Test case %0d failed - FSM did not transition to %s after %0d clock cycles. Got red=%b yellow=%b green=%b", test_case, exp_red ? "RED" : (exp_yellow ? "YELLOW" : "GREEN"), cycle, red, yellow, green);
        error_count = error_count + 1;
    end else begin
        $display("Test case %0d passed - FSM transitioned to %s after %0d clock cycles.", test_case, exp_red ? "RED" : (exp_yellow ? "YELLOW" : "GREEN"), cycle);
    end
end
endtask

initial begin
    clk = 0;
    reset_n = 0;
    enable = 1;

    error_count = 0;

    check_output(0, 1, 0, 0, 1);

    #5 reset_n = 1;

    repeat (32) @(posedge clk);
    check_output(32, 0, 0, 1, 2);

    repeat (20) @(posedge clk);
    check_output(20, 0, 1, 0, 3);

    repeat (7) @(posedge clk);
    check_output(7, 1, 0, 0, 4);

    if (error_count > 0) begin
        $display("Error: %0d test cases failed.", error_count);
    end else begin
        $display("All test cases passed!");
    end
    $finish;
end

//==================================================
final begin
    $display("Mismatches: %0d in %0d samples", error_count, 4);
end
//==================================================
endmodule

`timescale 1ns / 1ps
//==================================================
module tb;                       // renamed from tb_dice_roller
//==================================================
    reg clk;
    reg rst_n;
    reg [1:0] die_select;
    reg roll;
    wire [7:0] rolled_number;

    dice_roller dut (
        .clk(clk),
        .rst_n(rst_n),
        .die_select(die_select),
        .roll(roll),
        .rolled_number(rolled_number)
    );

    always begin
        #5 clk = ~clk;
    end

    integer i;
    integer j;
    integer error_count;
    reg [31:0] roll_counts [0:20];

    initial begin
        clk = 0;
        rst_n = 0;
        die_select = 0;
        roll = 0;

        #10 rst_n = 1;
        #10 roll = 1;

        error_count = 0;

        for (i = 0; i < 4; i++) begin
            die_select = i;

            for (j = 1; j <= 20; j++) begin
                roll_counts[j] = 0;
            end

            for (j = 0; j < 1000; j++) begin
                #10;
                roll = 0;
                #10;
                roll = 1;
                #10;
                roll = 0;
                #10;

                case (die_select)
                    2'b00: begin
                        if (rolled_number < 1 || rolled_number > 4) begin
                            //==================================================
                            if (error_count < 10)    // only print the first 10 errors
                            //==================================================
                            $display("Error: Invalid roll result for 4-sided die: %d", rolled_number);
                            error_count = error_count + 1;
                        end
                    end
                    2'b01: begin
                        if (rolled_number < 1 || rolled_number > 6) begin
                            //==================================================
                            if (error_count < 10)
                            //==================================================
                            $display("Error: Invalid roll result for 6-sided die: %d", rolled_number);
                            error_count = error_count + 1;
                        end
                    end
                    2'b10: begin
                        if (rolled_number < 1 || rolled_number > 8) begin
                            //==================================================
                            if (error_count < 10)
                            //==================================================
                            $display("Error: Invalid roll result for 8-sided die: %d", rolled_number);
                            error_count = error_count + 1;
                        end
                    end
                    2'b11: begin
                        if (rolled_number < 1 || rolled_number > 20) begin
                            //==================================================
                            if (error_count < 10)
                            //==================================================
                            $display("Error: Invalid roll result for 20-sided die: %d", rolled_number);
                            error_count = error_count + 1;
                        end
                    end
                endcase

                roll_counts[rolled_number] = roll_counts[rolled_number] + 1;
            end

            $display("Results for die_select %b:", die_select);
            for (j = 1; j <= 20; j++) begin
                if (roll_counts[j] > 0) begin
                    $display("  Rolled %d: %d times", j, roll_counts[j]);
                end
            end
        end

        if (error_count == 0) begin
            $display("Testbench completed successfully.");
        end else begin
            $display("Testbench completed with %d errors.", error_count);
        end

        $finish;
    end

//==================================================
final begin
    $display("Mismatches: %0d in %0d samples", error_count, 4000);
end
//==================================================
endmodule

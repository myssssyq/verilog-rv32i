module cpu_tb;
    reg clk = 0;
    reg btn_n = 1;
    always #5 clk = !clk;

    cpu dut(
        .clk(clk),
        .btn_n(btn_n),
        .led(),
        .uart_tx_pin()
    );

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);
    end

    initial begin
        #3500;
        if (dut.inst5.regs[1] !== 32'd5)
            $display("FAIL: x1 = %0d, expected 5", dut.inst5.regs[1]);
        else
            $display("PASS: x1 = 5");

        if (dut.inst5.regs[2] !== 32'd10)
            $display("FAIL: x2 = %0d, expected 10", dut.inst5.regs[2]);
        else
            $display("PASS: x2 = 10");

        if (dut.inst5.regs[3] !== 32'd15)
            $display("FAIL: x3 = %0d, expected 15", dut.inst5.regs[3]);
        else
            $display("PASS: x3 = 15 (ADD)");

        if (dut.inst5.regs[4] !== 32'd5)
            $display("FAIL: x4 = %0d, expected 5", dut.inst5.regs[4]);
        else
            $display("PASS: x4 = 5 (SUB)");

        if (dut.inst5.regs[5] !== 32'd0)
            $display("FAIL: x5 = %0d, expected 0", dut.inst5.regs[5]);
        else
            $display("PASS: x5 = 0 (AND)");

        if (dut.inst5.regs[6] !== 32'd15)
            $display("FAIL: x6 = %0d, expected 15", dut.inst5.regs[6]);
        else
            $display("PASS: x6 = 15 (OR)");

        if (dut.inst5.regs[7] !== 32'd15)
            $display("FAIL: x7 = %0d, expected 15", dut.inst5.regs[7]);
        else
            $display("PASS: x7 = 15 (XOR)");

        if (dut.inst5.regs[8] !== 32'd1)
            $display("FAIL: x8 = %0d, expected 1", dut.inst5.regs[8]);
        else
            $display("PASS: x8 = 1 (SLT)");

        if (dut.inst9.mem[0] !== 32'd15)
            $display("FAIL: mem[0] = %0d, expected 15", dut.inst9.mem[0]);
        else
            $display("PASS: mem[0] = 15 (SW)");

        if (dut.inst5.regs[9] !== 32'd15)
            $display("FAIL: x9 = %0d, expected 15", dut.inst5.regs[9]);
        else
            $display("PASS: x9 = 15 (LW)");

        if (dut.inst5.regs[10] !== 32'hABCD0123)
            $display("FAIL: x10 = %h, expected ABCD0123", dut.inst5.regs[10]);
        else
            $display("PASS: x10 = ABCD0123 (LUI+ADDI)");

        if (dut.inst5.regs[11] !== 32'd42)
            $display("FAIL: x11 = %0d, expected 42", dut.inst5.regs[11]);
        else
            $display("PASS: x11 = 42 (BEQ taken)");

        if (dut.inst5.regs[13] !== 32'h48)
            $display("FAIL: x13 = %h, expected 48", dut.inst5.regs[13]);
        else
            $display("PASS: x13 = 0x48 (JAL)");

        if (dut.inst5.regs[15] !== 32'h54)
            $display("FAIL: x15 = %h, expected 54", dut.inst5.regs[15]);
        else
            $display("PASS: x15 = 0x54 (JALR)");

        $display("Finished simulation");
        #100 $finish;
    end
endmodule

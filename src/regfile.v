module regfile(
    input         clk,
    input         weIn,
    input  [4:0]  rdAddrIn,
    input  [31:0] rdIn,
    input  [4:0]  rs1AddrIn,
    input  [4:0]  rs2AddrIn,
    output [31:0] rs1Out,
    output [31:0] rs2Out
);
    reg [31:0] regs [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'h00000000;
    end
    always @(posedge clk) begin
        if (weIn && rdAddrIn != 5'b00000)
            regs[rdAddrIn] <= rdIn;
    end
    assign rs1Out = (rs1AddrIn == 5'b00000) ? 32'b0 : regs[rs1AddrIn];
    assign rs2Out = (rs2AddrIn == 5'b00000) ? 32'b0 : regs[rs2AddrIn];
endmodule

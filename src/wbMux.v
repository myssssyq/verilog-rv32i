module wbMux(
    input [1:0]  wbSel,
    input [31:0] aluIn,
    input [31:0] pcPlus4In,
    input [31:0] memIn,
    output reg [31:0] wbOut
);
    always @(*) begin
        case (wbSel)
            2'b00: wbOut = aluIn;
            2'b01: wbOut = pcPlus4In;
            2'b10: wbOut = memIn;
            default: wbOut = 32'h00000000;
        endcase
    end
endmodule

module bMux(
    input bMuxSel,
    input [31:0] rs2In,
    input [31:0] immIn,
    output reg [31:0] bMuxOut
);
    always @(*) begin
        bMuxOut = bMuxSel ? immIn : rs2In;
    end
endmodule

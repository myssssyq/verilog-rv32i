module aMux(
    input aMuxSel,
    input [31:0] rs1In,
    input [31:0] pcIn,
    output reg [31:0] aMuxOut
);
    always @(*) begin
        aMuxOut = aMuxSel ? pcIn : rs1In;
    end
endmodule

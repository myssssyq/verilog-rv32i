module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0]  aluOp,
    output reg [31:0] aluOut,
    output reg        aluFlagZ,
    output reg        aluFlagLT
);
    always @(*) begin
        case (aluOp)
            4'h0: aluOut = a + b;
            4'h1: aluOut = a - b;
            4'h2: aluOut = a & b;
            4'h3: aluOut = a | b;
            4'h4: aluOut = a ^ b;
            4'h5: aluOut = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            4'h6: aluOut = b;
            default: aluOut = 32'h00000000;
        endcase
        aluFlagZ  = (aluOut == 32'h00000000);
        aluFlagLT = ($signed(a) < $signed(b));
    end
endmodule

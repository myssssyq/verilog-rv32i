module immgen(
    input  [31:0] instrIn,
    input  [2:0]  immSel,
    output reg [31:0] immOut
);
    always @(*) begin
        case (immSel)
            3'b000: immOut = {{20{instrIn[31]}}, instrIn[31:20]};
            3'b001: immOut = {{20{instrIn[31]}}, instrIn[31:25], instrIn[11:7]};
            3'b010: immOut = {{19{instrIn[31]}}, instrIn[31], instrIn[7], instrIn[30:25], instrIn[11:8], 1'b0};
            3'b011: immOut = {instrIn[31:12], 12'b0};
            3'b100: immOut = {{11{instrIn[31]}}, instrIn[31], instrIn[19:12], instrIn[20], instrIn[30:21], 1'b0};
            default: immOut = 32'h00000000;
        endcase
    end
endmodule

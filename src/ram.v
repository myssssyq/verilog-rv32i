module ram(
    input         clk,
    input         weIn,
    input  [31:0] addrIn,
    input  [31:0] dataIn,
    output reg [31:0] dataOut
);
    reg [31:0] mem [0:1023];
    always @(posedge clk) begin
        if (weIn)
            mem[addrIn[11:2]] <= dataIn;
    end
    always @(*) begin
        dataOut = mem[addrIn[11:2]];
    end
endmodule

module imem(
    input [31:0] addrIn,
    output reg [31:0] instrOut
);
    reg [31:0] rom [0:1023];
    initial $readmemh("program.hex", rom);
    always @(*) begin
        instrOut = rom[addrIn[11:2]];
    end
endmodule

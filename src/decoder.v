module decoder(
    input  [31:0] instrIn,
    output [4:0]  rs1Addr,
    output [4:0]  rs2Addr,
    output [4:0]  rdAddr,
    output [2:0]  funct3,
    output        funct7b5,
    output reg    regWrite,
    output reg    memWrite,
    output reg    aluSrcA,
    output reg    aluSrcB,
    output reg [1:0] wbSel,
    output reg    branch,
    output reg    jump,
    output reg [3:0] aluOp,
    output reg [2:0] immSel
);
    assign rs1Addr  = instrIn[19:15];
    assign rs2Addr  = instrIn[24:20];
    assign rdAddr   = instrIn[11:7];
    assign funct3   = instrIn[14:12];
    assign funct7b5 = instrIn[30];

    wire [6:0] opcode = instrIn[6:0];

    always @(*) begin
        regWrite = 0;
        memWrite = 0;
        aluSrcA  = 0;
        aluSrcB  = 0;
        wbSel    = 2'b00;
        branch   = 0;
        jump     = 0;
        aluOp    = 4'h0;
        immSel   = 3'b000;

        case (opcode)
            7'b0110111: begin
                regWrite = 1;
                aluSrcB  = 1;
                aluOp    = 4'h6;
                immSel   = 3'b011;
            end
            7'b0010011: begin
                regWrite = 1;
                aluSrcB  = 1;
                immSel   = 3'b000;
                case (funct3)
                    3'b000: aluOp = 4'h0;
                    3'b111: aluOp = 4'h2;
                    3'b110: aluOp = 4'h3;
                    3'b100: aluOp = 4'h4;
                    3'b010: aluOp = 4'h5;
                    default: aluOp = 4'h0;
                endcase
            end
            7'b0110011: begin
                regWrite = 1;
                case (funct3)
                    3'b000: aluOp = funct7b5 ? 4'h1 : 4'h0;
                    3'b111: aluOp = 4'h2;
                    3'b110: aluOp = 4'h3;
                    3'b100: aluOp = 4'h4;
                    3'b010: aluOp = 4'h5;
                    default: aluOp = 4'h0;
                endcase
            end
            7'b1101111: begin
                regWrite = 1;
                aluSrcA  = 1;
                aluSrcB  = 1;
                wbSel    = 2'b01;
                jump     = 1;
                aluOp    = 4'h0;
                immSel   = 3'b100;
            end
            7'b1100111: begin
                regWrite = 1;
                aluSrcB  = 1;
                wbSel    = 2'b01;
                jump     = 1;
                aluOp    = 4'h0;
                immSel   = 3'b000;
            end
            7'b1100011: begin
                aluSrcA  = 1;
                aluSrcB  = 1;
                branch   = 1;
                aluOp    = 4'h0;
                immSel   = 3'b010;
            end
            7'b0000011: begin
                regWrite = 1;
                aluSrcB  = 1;
                wbSel    = 2'b10;
                aluOp    = 4'h0;
                immSel   = 3'b000;
            end
            7'b0100011: begin
                memWrite = 1;
                aluSrcB  = 1;
                aluOp    = 4'h0;
                immSel   = 3'b001;
            end
            default: begin
            end
        endcase
    end
endmodule

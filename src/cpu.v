module cpu(
    input  wire clk, btn_n,
    output wire [5:0] led,
    output wire uart_tx_pin
);
    wire rst, uart_busy;
    reg uart_wr = 1'b0;
    reg [7:0] uart_data;

    wire [31:0] pcOut, instrOut, immOut;
    wire [31:0] rs1Out, rs2Out, aluAIn, aluBIn, aluOut, memOut, wbOut;
    wire [31:0] pcPlus4, branchTarget, jalrTarget, pcNext;
    wire [4:0]  rs1Addr, rs2Addr, rdAddr;
    wire [2:0]  funct3, immSel;
    wire [3:0]  aluOp;
    wire [1:0]  wbSel;
    wire        regWrite, memWrite, aluSrcA, aluSrcB;
    wire        branch, jump, funct7b5;
    wire        aluFlagZ, aluFlagLT;

    wire rs1FwdZ = (rs1Addr == 5'b00000);
    wire rs2FwdZ = (rs2Addr == 5'b00000);
    wire [31:0] rs1Val = rs1FwdZ ? 32'b0 : rs1Out;
    wire [31:0] rs2Val = rs2FwdZ ? 32'b0 : rs2Out;

    wire branchEq  = (rs1Val == rs2Val);
    wire branchNeq = !branchEq;
    wire takeBranch = jump
        | (branch & (funct3 == 3'b000) &  branchEq)
        | (branch & (funct3 == 3'b001) &  branchNeq);

    assign pcPlus4      = pcOut + 32'd4;
    assign branchTarget = pcOut + immOut;
    assign jalrTarget   = (rs1Val + immOut) & ~32'd1;

    wire isJalr = jump & (instrOut[6:0] == 7'b1100111);
    assign pcNext = takeBranch
        ? (isJalr ? jalrTarget : branchTarget)
        : pcPlus4;

    reset_gen u_rst(.clk(clk), .btn_n(btn_n), .rst(rst));
    pc inst1(.clk(clk), .rst(rst), .pcIn(pcNext), .pcOut(pcOut));
    imem inst2(.addrIn(pcOut), .instrOut(instrOut));
    decoder inst3(.instrIn(instrOut), .rs1Addr(rs1Addr), .rs2Addr(rs2Addr),
        .rdAddr(rdAddr), .funct3(funct3), .funct7b5(funct7b5),
        .regWrite(regWrite), .memWrite(memWrite),
        .aluSrcA(aluSrcA), .aluSrcB(aluSrcB),
        .wbSel(wbSel), .branch(branch), .jump(jump),
        .aluOp(aluOp), .immSel(immSel));
    immgen inst4(.instrIn(instrOut), .immSel(immSel), .immOut(immOut));
    regfile inst5(.clk(clk), .weIn(regWrite), .rdAddrIn(rdAddr), .rdIn(wbOut),
        .rs1AddrIn(rs1Addr), .rs2AddrIn(rs2Addr),
        .rs1Out(rs1Out), .rs2Out(rs2Out));
    aMux inst6(.aMuxSel(aluSrcA), .rs1In(rs1Val), .pcIn(pcOut), .aMuxOut(aluAIn));
    bMux inst7(.bMuxSel(aluSrcB), .rs2In(rs2Val), .immIn(immOut), .bMuxOut(aluBIn));
    alu inst8(.a(aluAIn), .b(aluBIn), .aluOp(aluOp),
        .aluOut(aluOut), .aluFlagZ(aluFlagZ), .aluFlagLT(aluFlagLT));
    ram inst9(.clk(clk), .weIn(memWrite), .addrIn(aluOut),
        .dataIn(rs2Val), .dataOut(memOut));
    wbMux inst10(.wbSel(wbSel), .aluIn(aluOut), .pcPlus4In(pcPlus4),
        .memIn(memOut), .wbOut(wbOut));
    uart_tx #(.DIV(234)) u_uart(.clk(clk), .wr(uart_wr), .data(uart_data),
        .busy(uart_busy), .tx(uart_tx_pin));

    always @(posedge clk) begin
        uart_wr <= 1'b0;
        if (!uart_busy && (pcOut == 32'h00000024)) begin
            uart_data <= aluOut[7:0];
            uart_wr   <= 1'b1;
        end
    end

    reg [24:0] blink = 0;
    always @(posedge clk) blink <= blink + 1;
    assign led[0] = ~blink[24];
    assign led[1] = (pcOut == 32'h00000000) ? 1'b0 : 1'b1;
    assign led[2] = ~uart_tx_pin;
    assign led[3] = ~blink[24];
    assign led[4] = 1'b1;
    assign led[5] = 1'b1;
endmodule

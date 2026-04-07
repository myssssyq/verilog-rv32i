module pc(
    input clk,
    input rst,
    input [31:0] pcIn,
    output reg [31:0] pcOut
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pcOut <= 32'h00000000;
        else
            pcOut <= pcIn;
    end
endmodule

//***************************************************************/
//模块名: register
//作 者: Hang Liu

//用 途: 异步使能寄存器
//版本说明:
//***************************************************************/
module register (
    input en,clk,
    input [7:0] in,
    output reg[7:0] out
);
reg [7:0] val;
always @(posedge clk) begin
    val<=in;
end

always @(en,val) begin
    if(en==1'b1) out<=val;
    else ;
end

endmodule //register
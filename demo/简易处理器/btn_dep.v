//***************************************************************/
//模块名: fpga_step_ctrl
//作 者: Hang Liu

//用 途: FPGA调试部分按键消抖
//版本说明:
//***************************************************************/
module btn_dep (
    input clk,
    input rst,
    input btn,

    output btn_out
);
//分频得到190Hz,周期5MS；
wire clk_190Hz;
reg [17:0] clk_div;
always @(posedge clk or posedge rst) begin
    if(rst) clk_div<=0;
    else clk_div<=clk_div+1;
end
assign clk_190Hz=clk_div[17];

reg btn_r,btn_rr,btn_rrr;
always @(posedge rst or posedge clk_190Hz) begin
    if(rst)begin
        btn_r<=0;
        btn_rr<=0;
        btn_rrr<=0;
    end
    else begin
        {btn_rrr,btn_rr,btn_r}<={btn_rr,btn_r,btn};
    end
end
assign btn_out=btn_r&btn_rr&btn_rrr;
endmodule //btn_dep
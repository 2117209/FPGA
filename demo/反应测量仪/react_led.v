//***************************************************************/
//模块名: react_led
//作 者: Hang Liu

//用 途: 随机点亮LED；
//版本说明:
//***************************************************************/
module react_led (
    input   clk,
    input   rst,
    input   btn,
    output reg LED
);
//分频1.5KHz:
reg [11:0] cnt;
wire clk_1k5Hz;
reg [14:0] clk_div;
always @(negedge clk or posedge rst) begin
    if(rst) clk_div <=0;
    else clk_div <=clk_div + 1;
end
assign clk_1k5Hz=clk_div[14];//2**15约等于1.5kHZ;

//随机控制LED亮：
always @(negedge clk_1k5Hz or posedge rst) begin
    if(rst) begin
        LED<=0;
        cnt<=0;
    end
    else begin
        cnt<=cnt+1;
        if(cnt==4000) LED<=1;
        else if(btn==1) begin
            LED<=0;
            cnt<=0;
        end
    end
end
endmodule //react_led
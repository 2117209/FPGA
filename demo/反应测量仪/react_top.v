//***************************************************************/
//模块名: react_top
//作 者: Hang Liu

//用 途: 顶层调用；
//版本说明:
//***************************************************************/
module react_top (
    input           clk ,
    input           rst,
    input           BTN0,
    output          LED0,
    output [7:0]    SEG,
    output [3:0]    AN

);
wire [15:0]    disp;

react_led u1(
    .clk(clk),
    .rst(rst),
    .btn(BTN0),
    .LED(LED0)
);

react_timer u2(
    .clk(clk),
    .rst(rst),
    .LED(LED0),
    .btn(BTN0),
    .disp(disp)
);

react_seg7 u3(
    .clk(clk),
    .rst(rst),
    .dat(disp),
    .SEG(SEG),
    .AN(AN)
);

endmodule //react_top
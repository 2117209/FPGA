//***************************************************************/
//模块名: motor_top
//作 者: Hang Liu

//用 途: 步进电机顶层模块
//版本说明:
//***************************************************************/
module motor_top (
    intput clk,
    input rstn,

    input start,
    input direct,
    input acce,
    input dece,

    output [3:0] step_ctr,
    output [1:0] led_show
);
wire start_key,direct_key,acce_key,dece_key;
key_detect u1(
    .clk(clk),
    .rstn(rstn),
    .pin_in(start),
    .pin_out(start_key)
);
key_detect u2(
    .clk(clk),
    .rstn(rstn),
    .pin_in(direct),
    .pin_out(direct_key)
);
key_detect u3(
    .clk(clk),
    .rstn(rstn),
    .pin_in(acce),
    .pin_out(acce_key)
);
key_detect u4(,
    .clk(clk),
    .rstn(rstn),
    .pin_in(dece),
    .pin_out(dece_key)
);
wire startstopsig,directsig;
wire [3:0] speeddata;
ctrol_module u5(
    .clk(clk)
    .rstn(rstn)
    .keystart(start_key)
    .keydirect(direct_key),
    .keyacce(acce_key),
    .keydece(dece_key),
    .startstopsig(startstopsig),
    .directsig(directsig),
    .speeddata(speeddata),
    .ledstatus(led_show)
);
motorctrl u6(
    .clk(clk)
    .rstn(rstn)
    .startsig(startstopsig),
    .directsig(directsig),
    .speed(speeddata),
    .stepmotor(step_ctr)
);
endmodule //motor_top
//***************************************************************/
//模块名: fpga_step_ctrl
//作 者: Hang Liu

//用 途: FPGA调试部分
//版本说明:
//***************************************************************/
module fpga_step_ctrl (
    input clk,rst,
    input [1:0] key,
    input [39:0] rf_data,
    input [7:0] pc,
    input [15:0] ir,

    output [7:0] duan,
    output [3:0] wei,
    output start
);
wire [2:0] key_v;
wire [15:0] data;

cpu_btn_ctr u1(
    .clk(clk),
    .rst(rst),
    .key(key),
    .start(start),
    .key_v(key_v)
);

cpu_disp_data u2(
    .key_v(key_v),
    .pc(pc),
    .ir(ir),
    .rf_data(rf_data),
    .dsp(data)
);

react_seg7 u3(
    .clk(clk),
    .rst(rst),
    .dat(data),
    .SEG(duan),
    .AN(wei)
);
endmodule //fpga_step_ctrl
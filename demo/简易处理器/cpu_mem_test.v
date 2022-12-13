//***************************************************************/
//模块名: cpu_mem_test
//作 者: Hang Liu

//用 途: 顶层调用；分为CPU和FPGA调试两个部分
//版本说明:
//***************************************************************/
module cpu_mem_test (
    input clk,rst;
    input [1:0] key;

    output [7:0] duan;
    output [3:0] wei;
);
wire[39:0] rf_data;
wire[7:0] pc;
wire start;
wire[15:0] ir;

cpu_mem u1(
    .clk(clk),
    .rst(rst),
    .start(start),
    .rf_data(rf_data),
    .pc(pc),
    .ir(ir)
);

fpga_step_ctrl u2(
    .clk(clk),
    .rst(rst),
    .key(key),
    .start(start),
    .duan(duan),
    .wei(wei),
    .pc(pc),
    .ir(ir),
    .rf_data(rf_data)
);

endmodule //cpu_mem_test
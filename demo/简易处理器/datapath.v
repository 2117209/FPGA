//***************************************************************/
//模块�?: datapath
//�? �?: Hang Liu

//�? �?: 数据路径的顶层文件；
//版本说明:
//***************************************************************/
module datapath (
    input rst,clk,r_wf,en_rf,en_reg,en_alu,en_imm,
    input [7:0] imm,
    input [2:0] sel_alu,
    input [3:0] sel_rf,
    input sel_mux,

    output [39:0] rf_data,
    output alu_zero,
    output [7:0] alu_out
);
wire [7:0] op1,op2,out_rf,out_imm;
register u8(
    .clk(clk),
    .en(en_reg),
    .in(op1),
    .out(op2)
);

register u9(
    .clk(clk),
    .en(en_imm),
    .in(imm),
    .out(out_imm)
);

mux21 u10(
    .sel(sel_mux),
    .in1(out_imm),
    .in2(out_rf),
    .out(op1)
);

alu u11(
    .clk(clk),
    .en(en_alu),
    .sel(sel_alu),
    .in1(op1),
    .in2(op2),
    .out(alu_out),
    .alu_zero(alu_zero)
);

rf u12(
    .rst(rst),
    .clk(clk),
    .r_w(r_wf),
    .enb(en_rf),
    .in(alu_out),
    .sel(sel_rf),
    .out(out_rf),
    .rf_data(rf_data)
);
endmodule //datapath
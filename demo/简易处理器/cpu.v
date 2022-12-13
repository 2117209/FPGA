//***************************************************************/
//模块名: cpu
//作 者: Hang Liu

//用 途: CPU内部设计划分
//版本说明:
//***************************************************************/
module cpu (
    input clk,rst;
    input start;
    input [15:0] ir;

    output [7:0] pc;
    output rom_en;
    output wr_ram,cs_ram;
    output [7:0] addr_ram;
    output [7:0] alu_out;
    output [39:0] rf_data;
);
wire[7:0] imm;
wire[3:0] sel_rf;
wire[2:0] sel_alu;
wire      sel_mux;
wire      r_wf,en_rf,en_reg,en_alu,en_imm,alu_zero;

wire clk_n;
assign clk_n=~clk;

datapath u6(
    .clk(clk_n),
    .rst(rst),
    .r_wf(r_wf),
    .en_reg(en_reg),
    .en_rf(en_rf),
    .en_alu(en_alu),
    .en_imm(en_imm),
    .sel_rf(sel_rf),
    .sel_alu(sel_alu),
    .sel_mux(sel_mux),
    .imm(imm),
    .alu_zero(alu_zero),
    .alu_out(alu_out),
    .rf_data(rf_data)
);

controller u7(
    .clk(clk_n),
    .rst(rst),
    .start(start),
    .alu_zero(alu_zero),
    .r_wf(r_wf),
    .en_reg(en_reg),
    .en_rf(en_rf),
    .en_alu(en_alu),
    .en_imm(en_imm),
    .sel_rf(sel_rf),
    .sel_alu(sel_alu),
    .sel_mux(sel_mux),
    .imm(imm),
    .pc(pc),
    .ir(ir),
    .rom_en(rom_en),
    .wr_ram(wr_ram),
    .cs_ram(cs_ram),
    .addr_ram(addr_ram)
);
endmodule //cpu
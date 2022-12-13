//***************************************************************/
//模块名: cpu_mem
//作 者: Hang Liu

//用 途: 含有RAM以及ROM的CPU设计顶层
//版本说明:
//***************************************************************/
module cpu_mem (
    input clk,rst,
    input start,

    output [39:0] rf_data,
    output [7:0]    pc,
    output [15:0]  ir
);

wire rom_en;
wire[15:0] ir;
wire wr_ram,cs_ram;
wire [7:0] addr_ram;
wire[7:0] alu_out;
wire clk_n;
assign clk_n=~clk;

cpu u3(
    .clk(clk),
    .rst(rst),
    .rom_en(rom_en),
    .ir(ir),
    .pc(pc),
    .start(start),
    .rf_data(rf_data),
    .wr_ram(wr_ram),
    .cs_ram(cs_ram),
    .addr_ram(addr_ram),
    .alu_out(alu_out)
);

rom u4(
    .clk(clk_n),
    .rst(rst),
    .rd(rom_en),
    .rom_data(ir),
    .rom_addr(pc)
);

ram u5(
    .clk(clk_n),
    .wr(wr_ram),
    .cs(cs_ram),
    .addr(addr_ram),
    .data_in(alu_out)
);



endmodule //cpu_mem
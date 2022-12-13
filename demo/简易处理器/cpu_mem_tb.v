`timescale 1ns/1ps
module cpu_mem_tb;
reg clk ;
reg rst;
reg start;

wire [39:0] rf_data;
wire [7:0] pc;
wire [15:0] ir;

cpu_mem uut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .rf_data(rf_data),
    .pc(pc),
    .ir(ir)
);

initial fork
    clk =0;
    forever #10 clk=~clk;
    rst=0;
    #35 rst=1;
    #65 rst=0;
    start=1'b1;
    join

endmodule //cpu_mem_tb
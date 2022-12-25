//***************************************************************/
//模块名: sdram_ini
//作 者: Hang Liu

//用 途: sdram 初始化 200微秒后，预充电，模式寄存器
//版本说明:
//***************************************************************/
module sdram_init (
    input clk,
    input rstn,

    output reg [3:0] cmd_reg,
    output wire[11:0] sdram_addr,
    output wire flag_init_end
);
localparam DELAY_200US =10000;
localparam NOP=4'b0111;
localparam PRE=4'b0010;
localparam ARPE=4'b0001;
localparam MSET=4'b0000;
////////////////////////////////////
reg [13:0] cnt_200us;
wire flag_200us;
reg [3:0] cnt_cmd;
//////////////////////////////////////
//cnt_200us
always @(posedge clk or negedge rstn) begin
    if(!rstn) cnt_200us<=0;
    else cnt_200us<=(flag_200us==1'b1)?cnt_200us:cnt_200us+1;
end 
always @(posedge clk or negedge rstn) begin
    if(!rstn) cnt_cmd<=0;
    else cnt_cmd<=(flag_200us==1'b1&&flag_init_end==1'b0)?cnt_cmd+1:cnt_cmd;
end
//cmd_reg
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_reg<=NOP;
    else if(flag_200us==1'b1)
        case(cnt_cmd)
        0:cmd_reg<=PRE;
        1:cmd_reg<=AREF;
        5:cmd_reg<=AREF;
        9:cmd_reg<=MSET;
        default:cmd_reg<=NOP;
        endcase
end
assign flag_init_end=(cnt_cmd>'d10)?1'b1:1'b0;
assign sdram_addr=(cmd_reg==MSET)?12'b0000_0011_0010:12'b0100_0000_0000;
assign flag_200us=(cnt_200us>DELAY_2000US)?1'b1:1'b0;
endmodule //sdram_init
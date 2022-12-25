//***************************************************************/
//模块名: sdram_read
//作 者: Hang Liu

//用 途: sdram 读模块
//版本说明:
//***************************************************************/
module sdram_read (
    input clk,rstn,
    input rd_en,
    input [5:0] state,
    input ref_req,
    input key_rd,
    input [15:0] rd_dq,

    output reg [3:0] sdram_cmd,
    output reg [11:0] sdram_addr,
    output reg [1:0] sdram_bank,
    output reg rd_req,
    output reg flag_rd_end 
);
parameter NOP=4'b011,PRE=4'b0010,ACT=4'b0011,RD=4'b0101,CMD_END=4'd12,
        COL_END=9'D508,ROW_END=12'd4095,AREF=6'b10_0000,READ=6'b01_0000; 
reg [11:0] row_addr;
reg [8:0] col_addr;
reg [3:0] cmd_cnt;
reg flag_act;
//flag_act
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_act<=1'b0;
    else if(flag_rd_end==1'b1&&ref_req==1'b1) flag_act<=1'b1;
    else if(flag_rd_end==1'b1) flag_act<=1'b0;
end
//rd_req
always @(posedge clk or negedge rstn) begin
    if(!rstn) rd_req<=1'b0;
    else if(rd_en==1'b1) rd_req<=1'b0;
    else if(key_rd==1'b1&&state!=READ) rd_req<=1'b1;
end
//CMD_CNT
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_cnt<=4'd0;
    else if(state==READ) cmd_cnt<=cmd_cnt+1'b1;
    else cmd_cnt<=4'd0;
end
//flag_rd_end
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_rd_end<=1'b0;
    else if(cmd_cnt==CMD_CNT) flag_rd_end<=1'b1;
    else flag_rd_end<=1'b0;
end
//row_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) row_addr<=12'd0;
    else if(row_addr==ROW_END&&col_addr==COL_END&&flag_rd_end==1'b1) 
        row_addr<=12'd0;
    else if(col_addr==COL_END&&flag_rd_end==1'b1)
        row_addr<=row_addr+1'b1;
end
//col_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) col_addr<=9'd0;
    else if(col_addr==COL_END&&flag_rd_end==1'b1)
        col_addr<=9'd0;
    else if(flag_rd_end==1'b1)
        col_addr<=col_addr+3'd4;
end
//cmd_cnt
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_cnt<=4'd0;
    else if(state==READ) cmd_cnt<=cmd_cnt+1'b1;
    else cmd_cnt<=4'd0;
end
//sdram_cmd
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_cmd<=NOP;
    else 
        case(cmd_cnt)
        4'd2:if(col_addr==9'd0) sdram_cmd<=PRE;
            else sdram_cmd<=NOP;
        4'd3:if(flag_act==1'b1||col_addr==9'd0) sdram_cmd<=ACT;
            else sdram_cmd<=NOP;
        4'd4:sdram_cmd<=RD;
        default:sdram_cmd<=NOP;
        endcase
end
//sdram_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_addr<=12'd0;
    else 
        case(cmd_cnt)
        4'd4:sdram_addr<={3'd0,col_addr};
        default:sdram_addr<=row_addr;
        endcase
end
//sadram_bank;
always @(posedge clk or negedge rstn) begin
    if(!rstn) sadram_bank<=2'd0;
end
endmodule //sdram_read
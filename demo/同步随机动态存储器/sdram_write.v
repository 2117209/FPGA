//***************************************************************/
//模块名: sdram_write
//作 者: Hang Liu

//用 途: sdram 写模块
//版本说明:
//***************************************************************/
module sdram_write (
    input clk,rstn,
    input key_wr,
    input wr_en,
    input ref_req,
    input [5:0] state,

    output reg [15:0] sdram_dq,
    output reg [3:0] sdram_dqm,
    output reg [11:0] sdram_addr,
    output reg [1:0] sdram_bank,
    output reg [3:0] sdram_cmd,
    output reg  wr_req,
    output reg flag_wr_end 
);
parameter NOP=4'b0111,ACT=4'b0011,WR=4'b0100,PRE=4'b0010,CMD_END=4'd8,
          COL_END=9'd508,ROW_END=12'd4095,AREF=6'b10_0000,WRITE=6'b00_1000;
//////////////////////////////////////////////////////////////////////////////
reg flag_act;
reg [3:0] cmd_cnt;
reg [11:0] row_addr;
reg [11:0] row_addr_reg;
reg [8:0] col_addr;
reg flag_pre; //在SDRAM内部为写状态需要给预充电命令标志；
//flag_pre
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_pre<=1'b0;
    else if(col_addr==9'd0&&flag_wr_end==1'b1) flag_pre<=1'b1;
    else if(flag_wr_end==1'b1) flag_pre<=1'b0;
end
//flag_act
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_act<=1'b0;
    else if(flag_wr_end==1'b1) flag_act<=1'b0;
    else if(ref_req==1'b1&&state==AREF) flag_act<=1'b1;
end
//wr_req
always @(posedge clk or negedge rstn) begin
    if(!rstn) wr_req<=1'b0;
    else if(wr_en==1'b1) wr_req<=1'b0;
    else if(state!=WRITE&&key_wr==1'b1) wr_req<=1'b1;
end
//flag_wr_end
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_wr_end<=1'b0;
    else if(cmd_cnt==CMD_END) flag_wr_end<=1'b1;
    else flag_wr_end<=1'b0;
end
//cmd_cnt;
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_cnt<=4'd0;
    else if(state==WRITE) cmd_cnt<=cmd_cnt+1'b1;
    else cmd_cnt<=4'd0;
end
//sdram_cmd
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_cmd<=1'b0;
    else 
        case(cmd_cnt)
        3'd1:
            if(flag_pre==1'b1) sdram_cmd<=PRE;
            else sdram_cmd<=NOP;
        3'd2:
            if(flag_act==1'b1||col_addr==9'd0) sdram_cmd<=ACT;
            else sdram_cmd<=NOP;
        3'd3:
            sdram_cmd<=WRITE;
        default:sdram<=NOP;
        endcase
end
//sdram_dq
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_dq<=16'd0;
    else 
        case(cmd_cnt)
        3'd3:sdram_dq<=16'h0012;
        3'd4:sdram_dq<=16'h1203;
        3'd5:sdram_dq<=16'h562f;
        3'd6:sdram_dq<=16'hfe12;
        default:sdram_dq<=16'd0;
        endcase
end
//row_addr_reg
always @(posedge clk or negedge rstn) begin
    if(!rstn) row_addr_reg<=12'd0;
    else if(row_addr_reg==ROW_END&&col_addr==COL_END&&cmd_cnt==CMD_END)
        row_addr_reg<=12'd0;
    else if(col_addr==COL_END&&flag_wr_end==1'b1)
        row_addr_reg<=row_addr_reg+1'b1;
end
//row_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) row_addr<=12'd0;
    else 
    case(cmd_cnt)
    3'd2:row_addr<=12'd0;    
    default:row_addr<=row_addr_reg;
    endcase
end
//col_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) col_addr<=9'd0;
    else if(col_addr==COL_END&&cmd_cnt==CMD_END) col_addr<=9'd0;
    else if(cmd_cnt==CMD_END) col_addr<=col_addr+3'd4;
end
//sdram_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_addr<=12'd0;
    else 
        case(cmd_cnt)
        3'd2:sdram_addr<=row_addr;
        3'd3:sdram_addr<=col_addr;
        default:sdram_addr<=row_addr;
        endcase
end
//sdram_bank
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_bank<=2'b00;
end


endmodule //sdram_write
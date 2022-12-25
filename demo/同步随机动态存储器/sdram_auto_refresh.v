//***************************************************************/
//模块名: sdram_auto_fresh
//作 者: Hang Liu

//用 途: sdram 自动刷新模块
//版本说明:
//***************************************************************/
module sdram_auto_refresh (
    input clk, rstn,
    input ref_en,
    input flag_init_end,

    output reg [11:0] sdram_addr,
    output reg [1:0] sdram_bank,
    output reg ref_req,
    output reg [3:0] cmd_reg,
    output reg flag_ref_end
);
parameter BANK=12'b0100_0000_0000,CMD_END=4'd10,CNT_END=10'd749,
            NOP=4'b0111,PRE=4'b0010,AREF=4'b0001;
reg [9:0] cnt_15ms;
reg flag_ref;
reg flag_start;
reg [3:0] cmd_cnt;
//flag_start
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_start<=1'b0;
    else if(flag_init_end==1'b1) flag_start<=1'b1；
end
//cnt_15ms
always @(posedge clk or negedge rstn) begin
    if(!rstn) cnt_15ms<=10'd0;
    else if(cnt_15ms==CNT_END) cnt_15ms<=10'd0;
    else if(flag_start) cnt_15ms<=cnt_15ms+1'b1;
end
//flag_ref
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_ref<=1'b0;
    else if(cmd_cnt==CMD_END) flag_ref<=1'b0;
    else if(ref_en==1'b1) flag_ref<=1'b1;
end
//cmd_cnt
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_cnt<=4'd0;
    else if(flag_ref==1'b1) cmd_cnt<=cmd_cnt+1'b1;
    else cmd_cnt<=4'd0;
end
//flag_ref_end
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_ref_end<=1'b0;
    else if(cmd_cnt==CMD_END) flag_ref_end<=1'b1;
    else flag_ref_end<=1'b0;
end
//cmd_reg
always @(posedge clk or negedge rstn) begin
    if(!rstn) cmd_reg<=NOP;
    else 
        case(cmd_cnt)
        3'd0:
            if(flag_ref==1'b1) cmd_reg<=PRE;
            else cmd_reg<=NOP;
        3'd1:cmd_reg<=AREF;
        3'd5:cmd_reg<=AREF;
        default:cmd_reg<=NOP;
        endcase
end
//sdram_addr
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_addr<=12'd0;
    else 
        case(cmd_cnt)
        4'd0: sdram_addr<=BANK;
        deafult:sdram_addr<=12'd0;
        endcase
end
//sdram_bank
always @(posedge clk or negedge rstn) begin
    if(!rstn) sdram_bank<=2'b00;
end
//ref_req
always @(posedge clk or negedge rstn) begin
    if(!rstn) ref_req<=1'b0;
    else if(ref_en==1'b1) ref_req<=1'b0;
    else if(cmd_cnt==CMD_END) ref_req<=1'b1; 
end
//flag_rf_end
always @(posedge clk or negedge rstn) begin
    if(!rstn) flag_rf_end<=1'b0;
    else if(cmd_cnt==EMD_END) flag_rf_end<=1'b1;
    else flag_rf_end<=1'b0;
end
endmodule //sdram_auto_refresh
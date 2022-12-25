//***************************************************************/
//模块名: arbit
//作 者: Hang Liu

//用 途: sdram 仲裁模块核心代码
//状态: 整体未完成
//版本说明:
//***************************************************************/
module arbit (
    input flag_init_end,
    input flag_rd_end,
    input flag_wr_end,
    input flag_ref_end,

    input rd_req,
    input wr_req,
    input ref_req,

    output wr_en,
    output rd_en,
    output ref_en,

    input key//启动开关
);

//核心代码：
parameter IDLE=3'd0,INIT=3'd1,ARBIT=3'd2,READ=3'd3,WRITE=3'd4,AREF=3'd5;
reg [2:0] c_state,n_state;
always @(posedge clk or negedge rstn) begin
    if(!rstn) c_state<=IDLE;
    else c_state<=n_state;
end

always @(*) begin
    if(!rstn) n_state<=IDLE;
    else begin
        case(c_state)
        IDLE:
            if(key==1'b1) n_state<=INIT;
            else n_state<=IDLE;
        INIT:
            if(flag_init_end==1'b1) n_state<=ARBIT;
            else n_state<=INIT;
        ARBIT:
            if(ref_req==1'b1) n_state<=AREF;
            else if(ref_req==1'b0&&rd_req) n_state<=READ;
            else if(ref_req==1'b0&&wr_req) n_state<=WRITE;
            else n_state<=ARBIT; 
        READ:
            if(flag_rd_end==1) n_state<=ARBIT;
            else n_state<=READ;
        WRITE:
            if(flag_wr_end==1) n_state<=ARBIT;
            else n_state<=WRITE;
        AREF:
            if(flag_ref_end==1) n_state<=ARBIT;
            else n_state<=AREF;
        default:n_state<=IDLE;
        endcase
    end
end
assign wr_en=(c_state==WRITE?1'b1:1'b0);
assign r_en=(c_state==READ?1'b1:1'b0);
assign ref_en=(c_state==AREF?1'B1:1'b0);

endmodule //arbit
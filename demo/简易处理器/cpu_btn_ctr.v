//***************************************************************/
//模块名: cpu_btn_ctr
//作 者: Hang Liu

//用 途: FPGA调试部分btn
//版本说明:
//***************************************************************/
module cpu_btn_ctr (
    input clk,rst,
    input [1:0] key,

    output reg start,
    output reg[2:0] key_v
);
wire [1:0] key_out;

btn_dep u1(
    .clk(clk),
    .rst(rst),
    .btn(key[0]),
    .btn_out(key_out[0])
);
btn_dep u2(
    .clk(clk),
    .rst(rst),
    .btn(key[1]),
    .btn_out(key_out[1])
);

reg delay;
always @(posedge clk or posedge rst) begin
    if(rst) delay<=0;
    else delay<=key_out[0];
end

always @(posedge key_out[1] or posedge rst) begin
    if(rst) key_v<=0;
    else key_v<=key_v+1;
end
always @(posedge clk or posedge rst) begin
    if(rst) start<=0;
    else begin
        if((key_out[0]==1)&(delay==0)) start<=1;
        else start<=0;
    end
end

endmodule //cpu_btn_ctr
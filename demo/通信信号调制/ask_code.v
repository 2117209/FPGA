//***************************************************************/
//模块名: ask_code
//作 者: Hang Liu

//用 途: 2ASK 2进制幅值键控（基带信号为零，输出为零；基带信号为1，输出特定频率信号）
//版本说明:
//***************************************************************/
module ask_code (
    input clk,
    input rst_n,
    input data_in,
    output ask_code_out
);
wire clk, rst_n, data_in
reg [2:0] clk_cnt;
reg clk_div;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        clk_cnt<=0;
        clk_div<=0;
    end
    else begin
        if(clk_cnt==3'd1)begin
            clk_div<=~clk_div;
            clk_cnt<=0;
        end
        else clk_cnt<=clk_cnt+1;
    end
end

assign ask_code_out=data_in?clk_div:1'b0;

endmodule //ask
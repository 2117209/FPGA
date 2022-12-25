//***************************************************************/
//模块名: fsk
//作 者: Hang Liu

//用 途: 2FSK 2进制幅值键控（基带信号为零，输出特定频率信号f1；基带信号为1，输出特定频率信号f2）
//版本说明:
//***************************************************************/
module fsk_code (
    input clk,
    input m_ser_code_in,
    output fsk_code_sin_out 
);
wire clk;
wire m_ser_code_in;
reg [2:0] cnt;
wire f1;
reg f2;

always @(posedge clk) begin
    if(cnt==3'd2)begin
        cnt<=3'd0;
        f2<=~f2;
    end
    else cnt<=cnt+3'd1;
end

assign f1=clk;
assign fsk_code_sin_out=(m_ser_code_in)?f1:f2;

endmodule //fsk_code
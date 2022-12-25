//***************************************************************/
//模块名: m_ser
//作 者: Hang Liu

//用 途: 伪随机信号发生器；线性反馈移位寄存器
//版本说明:
//***************************************************************/
module m_ser (
    input clk,
    input rst_n,
    input load,
    output m_ser_out
);
wire clk ;
wire rst_n;
wire load;
reg m_ser_out;
reg [2:0] m_code;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        m_code<=3'b000;
        m_ser_out<=1'b0;
    end
    else begin
        if(load)begin
            m_code<=3'b001;
            m_ser_out<=m_code[2];
        end
        else begin
            m_code[2:1]<=m_code[1:0];
            m_code[0]<=m_code[2]^m_code[0];
            m_ser_out<=m_code[2];
        end
    end
end

endmodule //m_ser
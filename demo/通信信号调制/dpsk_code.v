//***************************************************************/
//模块名: ask_code
//作 者: Hang Liu

//用 途: 2ASK 2进制幅值键控（基带信号为零，输出为零；基带信号为1，输出特定频率信号）
//版本说明:
//***************************************************************/
module dpsk_code (
    input clk,
    input rst_n,
    input m_ser_code_in,
    input [9:0] dds_sin_data_in2,
    input [9:0] dds_sin_data_in3,
    input [9:0] dpsk_data_sin_out,
    output dpsk_code_out
);
reg dpsk_code_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) dpsk_code_out_reg<=1'b0;
    else dpsk_code_reg<=dpsk_code_out_reg^m_ser_code_in;
end

assign dpsk_code_out=dpsk_code_out_reg;
assign dpsk_data_sin_out=(dpsk_code_reg)?dds_sin_data_in3:dds_sin_data_in2;    
endmodule //dpsk_code
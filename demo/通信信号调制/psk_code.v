//***************************************************************/
//模块名: psk
//作 者: Hang Liu

//用 途: 2PSK 2进制幅值键控（基带信号为零，输出180度相位正弦信号；基带信号为1，输出0度相位正弦信号）
//版本说明:
//***************************************************************/
module psk_code (
    input clk,
    input m_ser_code_in,
    input [9:0] dds_sin_data_in2,
    input [9:0] dds_sin_data_in3,
    input [9:0] psk_data_sin_out
);
assign psk_data_sin_out=(m_ser_code_in)?dds_sin_data_in2:dds_sin_data_in3;

endmodule //psk_code
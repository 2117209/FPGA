//***************************************************************/
//模块名: fpga_step_ctrl
//作 者: Hang Liu

//用 途: FPGA调试部分数据显示
//版本说明:
//***************************************************************/
module cpu_disp_data (
    input [2:0] key_v,
    input [7:0]pc,
    input [15:0] ir,
    input [39:0] rf_data,

    output reg [15:0] dsp
);
always @(*) begin
    case(key_v)
    0:dsp<={8'h0,pc};
    1:dsp<=ir;
    2:dsp<={4'ha,4'h0,rf_data[7:0]};
    3:dsp<={4'ha,4'h0,rf_data[15:8]};
    4:dsp<={4'ha,4'h0,rf_data[23:16]};
    5:dsp<={4'ha,4'h0,rf_data[31:24]};
    6:dsp<={4'ha,4'h0,rf_data[39:32]};
    7:dsp<=16'heeee;
    endcase
end
endmodule //cpu_disp_data
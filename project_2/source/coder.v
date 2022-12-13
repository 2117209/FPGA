
//************************************************************
//模块名: coder
//作 者: Hang Liu
//工 程：
//用 途: 汉明码编码、扩频、信道编码
//版本说明:
//************************************************************
module coder(
    input wire clk1,
    input wire clk31,
    input wire rst_n,
    input wire send_ena, //发送信号使能
    input wire in_data,
    output reg insourse_ena, // 获取数据，用于与 mcu 握手
    output wire [1:0] out_data // 输入数据。
    );

    parameter idle=4'b0001,body=4'b0010;
    reg in_data_buf;
    reg out_data_flag;
    reg check1,check2,check3;//三位监督位;
    reg [4:0] m_coder;  //m系列编码组，最低位输出作m序列;
    reg flag;
    reg [3:0] state1;
    reg [7:0] data_number;
    reg [3:0] state;
    reg [3:0] state_m;
/***************************************************
作为输出使能模块，并进行信道编码
***************************************************/
assign out_data=(send_ena&&out_data_flag)?(((in_data_buf^m_coder[0])==1b'1)?2'b01:2'b11):2'b10;

reg ll;
always @(posedge clk1) begin
    if(!rst_n)begin
        ll<=0;
    end
    else ll<=in_data_buf;
end
/***********************************************
 主状态机，发送头同步->数据帧同步->数据
 每发送 128 个数据又跳转到发送数据帧同步 Start
***********************************************/
always @(posedge clk1) begin
    if(!rst_n)
        sys_reset;
    else if(send_ena)
        case(state)// synthesis full_case
            4'h0 : head; //产生头同步信号 11111111110
            4'h1 : data_frames; //数据帧同步信号 0000+000
            4'h2 : ready_data; //数据发送
            default :state<=4'h0;
        endcase
    else sys_reset;
end
/***************
 复位 Start
****************/
task sys_reset;
    begin
        in_data_buf<=1'b0;
        insourse_ena <= 1'b0;
        data_number<=8'b0;
        out_data_flag<=1'b0;
        flag<=1'b0;
        state<=4'h0;
        state1<=4'h0;
        check1<=1'b0;
        check2<=1'b0;
        check3<=1'b0;
    end
endtask;
/*****************************************
 发送数据帧同步信号 0000+000 Start
*****************************************/
task head;
    begin
        case(state1)
            0,1,2,3,4,5,6,7,8,9:
            begin
                out_data_flag<=1'b1;
                flag<=1'b1;
                in_data_buf<=1'b1;
                state1<=state1+1'b1;
            end
            10:begin
                in_data_buf<=1'b0;
                state<=4'h1;
                state1<=4'h0;
            end
        endcase
    end
endtask;
/*****************************************
 发送数据帧同步信号 0000+000 Start
*****************************************/
task data_frames;
    begin
        case(state1)
            0,1,2,3,4,5:begin
                in_data_buf<=1'b0;
                state1<=state1+1'b1;
            end
            6:begin
                in_data_buf<=1'b0;
                state<=4'h2;
                state1<=4'h0;
                data_number<=8'd0;
                insourse_ena<=1'b1;
            end
        endcase
    end

endtask;
/********************************************************
 发送真实数据模块,每发送 4 位信息位和 3 位监督位 Start
********************************************************/
task ready_data;
    begin
        case(state1)
        0:begin
            
        end
    end
endtask;






endmodule
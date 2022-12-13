//***************************************************************/
//模块名: rf
//作 者: Hang Liu

//用 途: 通用寄存器文件
//版本说明:
//***************************************************************/
module rf (
    input rst,clk,enb,r_w;
    input [7:0] in;
    input[3:0] sel;

    output reg [7:0] out;
    output [39:0] rf_data;  //只读寄存器共计5个；
);
reg [15:0] reg_file[0:15];
integer i;
assign rf_data={reg_file[4],reg_file[3],reg_file[2],reg_file[1],reg_file[0]};

always @(negedge clk or posedge rst) begin
    if(rst)begin
        for(int i=0;i<15;i=i+1)
            reg_file[i]<=0;
    end
    else if(enb)begin
        if(r_w==0) reg_file[sel]<=in;
        else out<=reg_file[sel];
    end
end
endmodule //rf
//***************************************************************/
//模块�?: rf
//�? �?: Hang Liu

//�? �?: 通用寄存器文�?
//版本说明:
//***************************************************************/
module rf (
    input rst,clk,enb,r_w,
    input [7:0] in,
    input[3:0] sel,

    output reg [7:0] out,
    output [39:0] rf_data //只读寄存器共�?5个；
);
reg [7:0] reg_file[0:15];
integer i;
assign rf_data={reg_file[4],reg_file[3],reg_file[2],reg_file[1],reg_file[0]};

always @(posedge clk or posedge rst) begin
    if(rst)begin
        for(i=0;i<15;i=i+1)
            reg_file[i]<=0;
    end
    else if(enb==1)begin
        if(r_w==0) reg_file[sel]<=in;
        else out<=reg_file[sel];
    end
end
endmodule //rf
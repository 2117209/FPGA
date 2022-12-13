//***************************************************************/
//模块名: rom
//作 者: Hang Liu

//用 途: 程序存储器 指令为16位，最高四位指令码，次高四位是寄存器，最后八位是立即数；
//版本说明:
//***************************************************************/
module rom
    #(parameter M=16,N=8)
    (
    
    input rst,clk,rd,
    input[N-1:0] rom_addr,
    
    output reg [M-1:0] rom_data
);
reg [M-1:0] memory [0:2**N-1];
always @(posedge clk or posedge rst) begin
    if(rst)begin :init
        integer i;
        memory[0]<= 16'b0011_0000_00000000;//MOV R0, #o;
        memory[1]<= 16'b0011_0001_00001010;//MOVR1, #10;
        memory[2]<= 16'b0011_0010_00000001;//MOv R2, # 1;
        memory[3]<= 16'b0011_0011_00000000;//MOV R3, #o;
        memory[4]<= 16'b0110_0001_00001000;//JZ R1, NEXT;
        memory[5]<= 16'b0100_0000_00010000;//ADD RO,R1;
        memory[6]<= 16'b0101_0001_00100000;//SUB R1, R2;
        memory[7]<= 16'b0110_0011_00000100;//Jz R3, Loop
        memory[8]<= 16'b0010_0100_00000000;//MOV R4, RO
        memory[9]<= 16'b0111_0100_00000001;//RL R4,# 1
        memory[10]<=16'b1000_0100_00001010;//MOV 10H, R4
        memory[11]<=16'b1111_0000_00001011;//halt
        for(i=12;i<(2**N);i=i+1)//存储器其余地址存放0
            memory[i] <= 0;
    end
    else begin
        if(rd) rom_data<=memory[rom_addr];
    end
end
endmodule //rom
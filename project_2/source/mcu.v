
//***************************************************************/
//模块名: mcu
//作 者: Hang Liu

//用 途: 包含发送部分全部内容
//版本说明:
//***************************************************************/
`timescale 1us/1us
module mcu(
noised_data //输出带有噪声信号
)

parameter TestNumber =400;
parameter Period =100;

/**********************发送数据端口信号定义*********************/
wire    [1:0]   un_noised_data;
output  [2:0]   noised_data;
reg             clk1,clk31,rst_n;
reg             send_ena;
wire            insource_ena;

integer         indataFILE;
integer         i,j,k;

reg [7:0] indata_meme[TestNumber:1];
reg [7:0] indatabyte;
wire in_data;
assign in_data=indatabyte[7];

////////////////////////////////初始化
initial begin
    i=0;
    j=1;
    k=1;
end

initial begin
    rst_n=0;
    send_ena=0;
    @(posedge clk31)
    #(Period*150)
    rst_n=1;
    #(Period*33)
    send_ena=1;
end

initial begin
    clk1=0;
    #(Period*3)
    forever #(Period*31) clk1=~clk1;
end

initial begin
    clk31=0;
    #(Period*20)
    forever #(Period) clk31=~clk31;
end

/********************************************
    打开或者创建一个文件(名为 indataRandom.dat)
    生成测试用的随机字节写入该文件中
    把第一个数据赋给 indatabyte
    最后关闭该文件，释放 indataFILE
    ********************************************/
initial begin
    indataFILE=$fopen("./indata.dat");
    $display ("indataFILE=%0d",indataFILE);
    for(k=1;k<=TestNumber;k=k+1)begin
        indata_meme[k]={$random}%256;
        $fdisplay(indataFILE,"%0h",indata_meme[k]);
    end
    indatabyte<=indata_meme[1];
    $fclose(indataFile);
end
/************************************************
当 coder 使能信号(insourse_ena)到来,每 1 个 clk1 时钟把一个数据传出
传出的数据与 indataRandom.dat 文件的数据一样
************************************************/
always @(posedge clk1) begin
    if(insource_ena)
    if(j<=TestNumber)begin
        if(i<7)begin
            indatabyte={indatabyte[6:0],1'b0};
            i=i+1;
        end
        else if(i==7)begin
            indatabyte=indata_meme[j+1];
            j=j+1;
            i=0;
        end
    end
    else j=1;
    else ;
end

coder coder(
    .clk1(clk1),
    .clk31(clk31),
    .rst_n(rst_n),
    .send_ena(send_ena),
    .in_data(in_data),
    .out_data(un_noised_data),
    .insource_ena(insource_ena)
);

add_noise noise(
    .clk31(clk31),
    .rst_n(rst_n),
    .un_noised_data(un_noised_data),
    .noised_data(noised_data)
);
endmodule
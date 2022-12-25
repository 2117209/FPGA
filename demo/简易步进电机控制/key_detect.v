//***************************************************************/
//模块名: key_detect
//作 者: Hang Liu

//用 途: 按键消抖
//版本说明:
//***************************************************************/
module key_detect (
    input clk,
    input rstn,
    input pin_in,
    output pin_out
);
reg f1,f2;
always @(posedge clk) begin
    {f2,f1}<={f1,pin_in};
end
wire h2l=(f2==1&&f1==0)//下降沿检测
wire l2h=(f2==0&&f1==1)//上升沿检测

reg [15:0] count1;
reg iscount;
always @(posedge clk or negedge rstn) begin
    if(!rstn) count1<=0;
    else if(count1==16'd49999&&iscount) count1<=16'd0;
    else if(iscount) count1<=count1+1;
    else if(!iscount) count1<=16'd0;
end
/////////////////////
reg [7:0] count_ms;
always @(posedge clk or negedge rstn) begin
    if(!rstn) count_ms<=0;
    else if(iscount&&count1==16'd49999) count_ms<=count_ms+1;
    else if(!iscount) count_ms<=0;
end
/////////////////////////////////
reg rpin_out;
reg [3:0] i;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        iscount<=0;
        rpin_out<=0;
        i<=0;
    end
    else 
        case(i)
        4'd0:
            if(h2l) i<=4'd1;
            else if(l2h) i<=4'd3;
        4'd1:
            if(count_ms==8'd10) begin    //消抖延时
                iscount<=1'b0;
                i<=i+1;
            end
            else iscount<=1'b1;
        4'd2:
            begin
               rpin_out<=1'b1;
               i<=i+1; 
            end
        4'd3:
            begin
                rpin_out<=1'b0;
                i<=i+1;
            end
        4'd4:
            if(count_ms==8'd50) begin
                iscount<=1'b0
                i<=4'd0;
            end
            else iscount<=1'b1;
        default:i<=4'd0;
        endcase
end
assign pin_out=rpin_out;
endmodule //key_detect
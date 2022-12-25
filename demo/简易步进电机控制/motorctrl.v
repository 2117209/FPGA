//***************************************************************/
//模块名: motorctrl
//作 者: Hang Liu

//用 途: 步进电机驱动模块
//版本说明:
//***************************************************************/
module motorctrl (
    input clk,
    input rstn,
    input startsig,
    input directsig,
    input [3:0] speed,

    output [3:0] stepmotor
);
parameter T1MS=16'd49999;

reg [15:0]cnt;
reg iscnt;
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        cnt<=16'd0;
    end
    else if(iscnt&&cnt==T1MS) cnt<=16'd0;
    else if(iscnt) cnt<=cnt+16'd1;
    else if(!iscnt) cnt<=16'd0;
end

reg [7:0] count_ms;
always @(posedge clk or negedge rstn) begin
    if(!rstn) count_ms<=8'd0;
    else if(iscnt&&cnt==T1MS) count_ms<=count_ms+8'd1;
    else if(!iscnt) count_ms<=8'd0;
end

reg [3:0] rstepmotor;
always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        iscnt<=1'b0;
        rstepmotor<=4'b0000;
        i<=4'd0;
    end
    else if(startsig==1'b1)begin
        case(i)
        4'd0:
            if(directsig==1'b1) i<=4'd1;
            else if(directsig==1'b0) i<=4'd5;
            else begin
                i<=4'd0;
                rstepmotor<=4'b0000;
            end
        4'd1:
            if(count_ms==(speed+1'b1))begin
                iscnt<=1'd0;
                i<=i+1;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0001;
            end
        4'd2:
            if(count_ms==speed)begin
                iscnt<=1'b0;
                i<=i+1;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0010;
            end
        4'd3:
            if(count_ms==(speed+1'b1))begin
                iscnt<=1'b0;
                i<=i+1;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0100;
            end
        4'd4:
            if(count_ms==speed)begin
                iscnt<=1'b0;
                i<=4'd0;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b1000;
            end
        4'd5://翻转运行
            if(count_ms==(speed+1'b1))begin
                iscnt<=1'b0;
                i<=i+1;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b1000;
            end
        4'd6:
            if(count_ms==speed)begin
                i<=i+1;
                iscnt<=1'b0;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0100;
            end
        4'd7:
            if(count_ms==(speed+1'b1))begin
                iscnt<=0;
                i<=i+1;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0010;
            end
        4'd8:
            if(count_ms==speed) begin
                iscnt<=0;
                i<=4'd0;
            end
            else begin
                iscnt<=1'b1;
                rstepmotor<=4'b0001;
            end
        default:begin
                iscnt<=1'b1;
                i<=4'd0;
            end
        endcase
    end
end
assign stepmotor=rstepmotor;
endmodule //motorctrl
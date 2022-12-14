//***************************************************************/
//模块名: react_timer
//作 者: Hang Liu

//用 途: 按键消抖，测量LED从点亮到按键按下延时；
//版本说明:
//***************************************************************/
module react_timer (
    input   clk,
    input   rst,
    input   LED,
    input   btn,
    output  [15:0] disp
);
reg clk_1khz;
reg [14:0] cnt;
always @(negedge clk or posedge rst) begin
    if(rst)begin
        clk_1khz <=0;
        cnt<=0;
    end
    else begin
        if(cnt==25000)begin
            cnt<=0;
            clk_1khz<=~clk_1khz;
        end
        else cnt<=cnt+1;
    end
end

//高位处理:
reg [15:0] react_time;
wire [3:0] sw0,sw1,sw2,sw3;
assign sw3=(react_time[15:12]==0)?4'hf:react_time[15:12];
assign sw2=(react_time[11:8]==0)?4'hf:react_time[11:8];
assign sw1=(react_time[7:0]==0)?4'hf:react_time[7:0];
assign sw0=react_time[3:0];
assign disp={sw3,sw2,sw1,sw0};

reg [15:0] cnt_time;
always @(negedge clk or posedge rst) begin
    if(rst) begin
        cnt_time<=0;
        react_time<=0;
    end
    else begin
        if(btn==1)begin
            react_time<=cnt_time;
        end
        else begin
            if(LED==1) begin
                if(cnt_time==9999) cnt_time<=0;
                else begin
                    if(cnt_time[3:0]==9)begin
                        cnt_time[3:0]<=0;
                        if(cnt_time[7:4]==9) begin
                            cnt_time[7:4]<=0;
                            if(cnt_time[11:8]==9)begin
                                cnt_time[11:8]<=0;
                                if(cnt_time[15:12]==9)begin
                                    cnt_time[15:12]<=0;
                                end
                                else cnt_time[15:12]<=cnt_time[15:12]+1;
                            end
                            else cnt_time[11:8]<=cnt_time[11:8]+1;
                        end
                        else cnt_time[7:4]<=cnt_time[7:4]+1;
                    end
                    else cnt_time[3:0]<=cnt_time[3:0]+1; 
                end
            end
            else cnt_time<=0;
        end
    end
end
endmodule //react _timer
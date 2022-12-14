//***************************************************************/
//模块名: react_seg7
//作 者: Hang Liu

//用 途: 数码管显示延时；
//版本说明:
//***************************************************************/
module react_seg7 (
    input   clk,
    input   rst,
    input   [15:0] dat,
    output reg [7:0] SEG,
    output reg [3:0] AN
);
//分频190Hz:
wire clk_190Hz;
reg [17:0] clk_div;
always @(posedge clk or posedge rst) begin
    if(rst) clk_div<=0;
    else clk_div<=clk_div+1'b1;
end
assign  clk_190Hz=clk_div[17];//2**18≈190Hz;

//4个数码管控制：
reg [3:0]   disp;
reg [1:0]   seg7_sel;
always @(negedge clk or posedge rst) begin
    if(rst)begin
        seg7_sel<=0;
        AN  <= 0;
        disp <=	0;
    end
    else begin
        seg7_sel<=seg7_sel+1;
        case(seg7_sel)
            2'b00:begin
                AN<=4'b1110;
                disp<=dat[3:0];
            end
            2'b01:begin
                AN<=4'b1101;
                disp<=dat[7:4];
            end
            2'b10:begin
                AN<=4'b1011;
                disp<=dat[11:8];
            end
            2'b11:begin
                AN<=4'b0111;
                disp<=dat[15:12];
            end
        endcase
    end
end
always @(disp) begin
    case(disp)
    0:SEG<=8'b11000000;
    1:SEG<=8'b11111001;
    2:SEG<=8'b10100100;
    3:SEG<=8'b10110000;
    4:SEG<=8'b10011001;
    5:SEG<=8'b10010010;
    6:SEG<=8'b10000010;
    7:SEG<=8'b11111000;
    8:SEG<=8'b10000000;
    9:SEG<=8'b10010000;
    10:SEG<=8'b10001000;
    11:SEG<=8'b10000011;
    12:SEG<=8'b11000110;
    13:SEG<=8'b10100001;
    14:SEG<=8'b10000110;
    15:SEG<=8'b10001110;
    default:SEG<=8'b11000000;
    endcase
end
endmodule //react_seg7
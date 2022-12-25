//***************************************************************/
//模块名: ctrol_modul
//作 者: Hang Liu

//用 途: 步进电机工作模式
//版本说明:
//***************************************************************/
module ctrol_module (
    input clk,
    input rstn,
    input keystart,
    input keydirect,
    input keyacce,
    input keydece,

    output startstopsig,
    output directsig,
    output [3:0] speeddata,
    output [1:0] ledstatus
);
reg [3:0] i;
reg rstartstopsig;
reg rdirectsig;
reg [3:0] rspeeddata;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        i<=4'd0;
        rstartstopsig<=1'b0;
        rdirectsig<=1'b0;
        rspeeddata<=4'd5;
    end
    else begin
        if(keystart) rstartstopsig<=rstartstopsig+1'b1;
        else if(keydirectsig) rdirectsig<=rdirectsig+1'b1;
        else if(keyacce) rspeeddata<=rdspeeddata+4'b1;
        else if(keydece) rspeeddata<=rdspeeddata-4'd1;
    end
end

assign startstopsig=rstartstopsig;
assign directsign=rdirectsig;
assign speeddata=rdspeeddata;
assign ledstatus={rstartstopsig,rdirectsig};

endmodule //ctrol_module





//***************************************************************/
//模块名: alu
//作 者: Hang Liu

//用 途: 算数逻辑单元；
//版本说明:
//***************************************************************/
module alu (
    input en,clk;
    input [2:0] sel;
    input [7:0] in1,in2;
    output reg[7:0] out;
    output reg alu_zero;
);
always @(posedge clk) begin
    if(en)begin
        case(sel)
        3'b000:out<=in1;
        3'b001:alu_zero<=(in1==0)?1'b1:1'b0;
        3'b010:out<=in1+in2;
        3'b011:out<=in1-in2;
        3'b100:out<=in1<<in2;
        default:;
        endcase
    end
end


endmodule //alu
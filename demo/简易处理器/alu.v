//***************************************************************/
//模块�?: alu
//�? �?: Hang Liu

//�? �?: 算数逻辑单元�?
//版本说明:
//***************************************************************/
module alu (
    input en,
    input clk,
    input [2:0] sel,
    input [7:0] in1,in2,
    output reg[7:0] out,
    output reg alu_zero
);
always @(posedge clk) begin
    if(en)begin
        alu_zero<=0;
        case(sel)
            3'b000:out<=in1;
            3'b001:if(in1==0) alu_zero<=1;else alu_zero<=0;
            3'b010:out<=in1+in2;
            3'b011:out<=in1-in2;
            3'b100:out<=in1<<in2;
            default:;
        endcase
    end
end


endmodule //alu
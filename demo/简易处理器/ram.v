//***************************************************************/
//模块�?: ram
//�? �?: Hang Liu

//�? �?: 数据存储器可读可写；
//版本说明:
//***************************************************************/
module ram 
    #(parameter M=8,N=8)
    (
    input rd,wr,cs,clk,
    input [N-1:0] addr,
    input [M-1:0] data_in,
    output reg [M-1:0] data_out
);
reg [M-1:0] memory [0:2**N-1];
always @(posedge clk) begin
    if(cs)begin
        if(rd) data_out<=memory[addr];
        else if(wr) memory[addr]<=data_in;
        else data_out<='bz;
    end
end

endmodule //ram 
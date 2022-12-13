//***************************************************************/
//模块名: controller
//作 者: Hang Liu

//用 途: 控制器，提供必要的控制信号，使数据流通过数据路径后达到预期的结果；
//版本说明:
//***************************************************************/
module controller (
    input clk,rst,start,alu_zero;
    input [15:0] ir;
    output reg r_wf,en_reg,en_rf,en_alu,en_imm;
    output reg [3:0]sel_rf;
    output reg [2:0]sel_alu;
    output reg sel_mux;
    output reg [7:0]imm;
    output reg [7:0]pc;
    output reg rom_en;
    output reg wr_ram,cs_ram;
    output reg [7:0]addr_ram;
);
parameter s0=6'b000000,s1=6'b000001,s2=6'b000010,s3=6'b000011,s4=6'b000100,
          s5=6'b000101,s5_2=6'b000110,s5_3=6'b000111,
          s6=6'b001000,s6_2=6'b001001,s6_3=6'b001010,s6_4=6'b001011,s6_5= 6'b001100,
          s7=6'b001101,s7_2= 6'b001110,s7_3 = 6'b001111,s7_4= 6'b010000,s7_5=6'b010001,
          s8=6'b010010,s8_2=6'b010011,s8_3=6'b010100,
          s9=6'b010101,s9_2=6'b010110,s9_3=6'b010111,
          s10=6'b100000,s10_2=6'b100001,s10_3=6'b100010,
          s11=6'b100011,s11_2=6'b100100,s11_3=6'b100101,s11_4=6'b100110,s11_5=6'b100111,
          s12= 6'b101000,
          done= 6'b101001;
parameter loadi=4'b0011,add=4'b0100,sun=4'b0101,jz=4'b0110,store=4'b1000,
          shiftl=4'b0111,reg2reg=4'b0010,halt=4'b1111;
reg [5:0] state;
reg [3:0] opcode;
reg [7:0] address;
reg [3:0] register;
always @(negedge clk or posedge rst) begin
    sel_mux<=1;
    en_rf<=0;
    en_reg<=0;
    en_alu<=0;
    em_imm<=0;
    rom_en<=0;
    wr_ram<=0;
    cs_ram<=0;
    if(rst)begin
        state<=s0;
        pc<=0;
    end
    else begin
        case(state)
        s0:begin
            pc<=0;
            state<=s1;
        end
        s1:begin
            if(start==1) begin
                rom_en<=1;
                state<=s2;
            end
            else state<=s1;
        end
        s2:begin                 //指令分解，
            opcode<=ir[15:12];   //操作码
            register<=ir[11:8];  //第二寄存器或立即数；
            address<=ir[7:0];    //第一寄存器
            state<=s3;
        end
        s3:begin
            pc<=pc+8'b1;
            state<=s4;
        end
        s4:begin
            case(opcode)  //译码
            loadi:state<=s5;
            add: state<=s6;
            sub: state<=s7;
            jz: state<=s8;
            store: state<=s9;
            reg2reg: state<=s10;
            shiftl: state<=s11;
            halt: state<=done;
            default:state<=s1;
            endcase
        end
        s5:begin
            imm<=address;
            em_imm<=1;
            state<=s5_2;
        end
        s5_2:begin
            sel_mux<=0;
            en_alu<=1;
            sel_alu<=3'b000;
            state<=s5_3;
        end
        s5_3:begin
            en_rf<=1;
            r_wf<=0;
            sel_rf<=register;
            state<=s12;
        end
        s6:begin
            sel_rf<=ir[7:4];
            en_rf<=1;
            r_wf<=1;
            state<=s6_2;
        end
        s6_2:begin
            en_reg<=1;
            state<=s6_3;
        end
        s6_3:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=1;
            state<=s6_4;
        end
        s6_4:begin
            en_alu<=1;
            sel_alu<=3'b010;
            state<=s6_5;
        end
        s6_5:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=0;
            state<=s12;
        end
        s7:begin
            sel_rf<=ir[7:4];
            en_rf<=1'
            r_wf<=1;
            state<=s7_2;
        end
        s7_2:begin
            en_reg<=1;
            state<=s7_3;
        end
        s7_3:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=1;
            state<=s7_4;
        end
        s7_4:begin
            en_alu<=1;
            sel_alu<=3'b011;
            state<=s7_5;
        end
        s7_5:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=0;
            state<=s12;
        end
        s8:begin
            en_rf<=1;
            r_wf<=1;
            sel_rf<=register;
            state<=s8_2;
        end
        s8_2:begin
            en_alu<=1;
            sel_alu<=3'b001;
            state<=s8_3;
        end
        s8_3:begin
            if(alu_zero==1)
                pc<=address;
            state<=s12;
        end
        s9:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=1;
            state<=s9_2;
        end
        s9_2:begin
            en_alu<=1;
            sel_alu<=3'b000;
            state<=s9_3;
        end
        s9_3:begin
            cs_ram<=1;
            wr_ram<=1;
            addr_ram<=address;
            state<=s12;
        end
        s10:begin
            sel_rf<=ir[7:4];
            en_rf<=1;
            r_wf<=1;
            state<=s10_2;
        end
        s10_2:begin
            en_alu<=1;
            sel_slu<=3'b000;
            state<=s10_3;
        end
        s10_3:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=0;
            state<=s12;
        end
        s11:begin
            imm<=address;
            em_imm<=1;
            state<=s11_2;
        end
        s11_2:begin
            sel_mux<=0;
            en_reg<=1;
            state<=s11_3;
        end
        s11_3:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=1;
            satte<=s11_4;
        end
        s11_4:begin
            en_alu<=1;
            sel_alu<=3'b100;
            state<=s11_5; 
        end
        s11_5:begin
            sel_rf<=register;
            en_rf<=1;
            r_wf<=0;
            state<=s12;
        end
        s12:state<=s1;
        done:state<=done;
        default:;
        endcase
    end
end
endmodule //controller
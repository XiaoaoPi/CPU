`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: EX_Mem
// 
//////////////////////////////////////////////////////////////////////////////////

//EX_Mem流水部件
module ex_mem(
    input       clk, rst, halt_i_3,
    input       [4:0] rw_i,
    input       jal_i,
    input       Memwrite_i, MemToReg_i,Regwrite_i,RegDst_i,
    input       lb_i,
    input       lui_i,
    input       [31:0] B_i, Imm_i, PC_i, ALU_i,
    output reg  halt_o_3,
    output reg  [4:0] rw_o,
    output reg  jal_o,
    output reg  Memwrite_o, MemToReg_o,Regwrite_o,RegDst_o,
    output reg  lb_o,
    output reg  lui_o,
    output reg  [31:0] B_o, Imm_o, PC_o, ALU_o
    );
    initial begin
        //WB，在访存结束之后，写回寄存器需要的控制信号
        rw_o <= 0;
        MemToReg_o <= 0;    //决定写回数据的来源，是ALU还是Mem
        jal_o <= 0;         //决定写回数据的来源，是上面的结果还是PC+1
        lui_o <= 0;         //决定写回数据的来源，是否是LUI式的拓展
        Regwrite_o <= 0;    //决定是否写回
        RegDst_o <= 0;      //决定写回到哪个寄存器
        //Mem，ALU计算之后，写入存储器之前需要的控制信号
        Memwrite_o <= 0;    //决定是否存进ram
        lb_o <= 0;          //决定mem的load方式
        //A,B,PC,IMM
        B_o <= 0;           //用于ALU的操作数
        PC_o <= 0;          //用于NPC决定下一条指令位置
        Imm_o <= 0;            //用于1.ALU操作数2.NPC
        ALU_o <= 0;
        halt_o_3 <= 0;
    end
    always @(posedge clk) begin
        if (rst) begin
            //WB，在访存结束之后，写回寄存器需要的控制信号
            rw_o <= 0;
            MemToReg_o <= 0;    //决定写回数据的来源，是ALU还是Mem
            jal_o <= 0;         //决定写回数据的来源，是上面的结果还是PC+1
            lui_o <= 0;         //决定写回数据的来源，是否是LUI式的拓展
            Regwrite_o <= 0;    //决定是否写回
            RegDst_o <= 0;      //决定写回到哪个寄存器
            //Mem，ALU计算之后，写入存储器之前需要的控制信号
            Memwrite_o <= 0;    //决定是否存进ram
            lb_o <= 0;          //决定mem的load方式
            //A,B,PC,IMM
            B_o <= 0;           //用于ALU的操作数
            PC_o <= 0;          //用于NPC决定下一条指令位置
            Imm_o <= 0;            //用于1.ALU操作数2.NPC
            ALU_o <= 0;
            halt_o_3 <= 0;
        end
        else begin
            //WB，在访存结束之后，写回寄存器需要的控制信号
            rw_o <= rw_i;
            MemToReg_o <= MemToReg_i;    //决定写回数据的来源，是ALU还是Mem
            jal_o <= jal_i;         //决定写回数据的来源，是上面的结果还是PC+1
            lui_o <= lui_i;         //决定写回数据的来源，是否是LUI式的拓展
            Regwrite_o <= Regwrite_i;    //决定是否写回
            RegDst_o <= RegDst_i;      //决定写回到哪个寄存器
            //Mem，ALU计算之后，写入存储器之前需要的控制信号
            Memwrite_o <= Memwrite_i;    //决定是否存进ram
            lb_o <= lb_i;          //决定mem的load方式
            //A,B,PC,IMM
            B_o <= B_i;           //用于ALU的操作数
            PC_o <= PC_i;          //用于NPC决定下一条指令位置
            Imm_o <= Imm_i;            //用于1.ALU操作数2.NPC
            ALU_o <= ALU_i;
            halt_o_3 <= halt_i_3;
        end
    end
endmodule
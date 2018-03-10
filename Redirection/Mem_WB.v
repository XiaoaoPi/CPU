`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: Mem_WB
// 
//////////////////////////////////////////////////////////////////////////////////

//Mem_WB流水部件
module mem_wb(
    input       clk, rst, halt_i_4,
    input       [4:0] rw_i,
    input       jal_i,
    input       MemToReg_i,Regwrite_i,RegDst_i,
    input       lui_i,
    input       [31:0] Imm_i,PC_i,ALU_i, Ram_i, B_i,
    input       [4:0] desreg_i,
    output reg  halt_o_4,
    output reg  [4:0] rw_o,
    output reg  jal_o,
    output reg  MemToReg_o,Regwrite_o,RegDst_o,
    output reg  lui_o,
    output reg  [31:0] Imm_o,PC_o, ALU_o, Ram_o, B_o,
    output reg  [4:0]   desreg_o,
    output      [31:0]  wb_data
    );
    assign wb_data =  lui_i?Imm_i
                        :(jal_i? (PC_i+1)
                             :(MemToReg_i?Ram_i:ALU_i));
    initial begin
        //WB，在访存结束之后，写回寄存器需要的控制信号
        rw_o <= 0;
        MemToReg_o <= 0;    //决定写回数据的来源，是ALU还是Mem
        jal_o <= 0;         //决定写回数据的来源，是上面的结果还是PC+1
        lui_o <= 0;         //决定写回数据的来源，是否是LUI式的拓展
        Regwrite_o <= 0;    //决定是否写回
        RegDst_o <= 0;      //决定写回到哪个寄存器
        //A,B,PC,IMM
        PC_o <= 0;          //用于NPC决定下一条指令位置         
        Imm_o <= 0;            //用于1.ALU操作数2.写回3.NPC
        ALU_o <= 0;
        Ram_o <= 0;
        B_o <= 0;//用于写回数据
        halt_o_4 <= 0;
        desreg_o <= 0;
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
            //A,B,PC,IMM
            PC_o <= 0;          //用于NPC决定下一条指令位置         
            Imm_o <= 0;            //用于1.ALU操作数2.写回3.NPC
            ALU_o <= 0;
            Ram_o <= 0;
            B_o <= 0;//用于写回数据
            halt_o_4 <= 0;
            desreg_o <= 0;
        end
        else if(halt_o_4) begin     //阻止halt信号被后续信号打断
            //WB，在访存结束之后，写回寄存器需要的控制信号
            rw_o <= rw_i;
            MemToReg_o <= MemToReg_i;    //决定写回数据的来源，是ALU还是Mem
            jal_o <= jal_i;         //决定写回数据的来源，是上面的结果还是PC+1
            lui_o <= lui_i;         //决定写回数据的来源，是否是LUI式的拓展
            Regwrite_o <= Regwrite_i;    //决定是否写回
            RegDst_o <= RegDst_i;      //决定写回到哪个寄存器
            //A,B,PC,IMM
            PC_o <= PC_i;          //用于NPC决定下一条指令位置         
            Imm_o <= Imm_i;            //用于1.ALU操作数2.写回3.NPC
            ALU_o <= ALU_i;
            Ram_o <= Ram_i;
            B_o <= B_i;//用于写回数据
            halt_o_4 <= 1;
            desreg_o <= desreg_i;
        end
        else begin
            //WB，在访存结束之后，写回寄存器需要的控制信号
            rw_o <= rw_i;
            MemToReg_o <= MemToReg_i;    //决定写回数据的来源，是ALU还是Mem
            jal_o <= jal_i;         //决定写回数据的来源，是上面的结果还是PC+1
            lui_o <= lui_i;         //决定写回数据的来源，是否是LUI式的拓展
            Regwrite_o <= Regwrite_i;    //决定是否写回
            RegDst_o <= RegDst_i;      //决定写回到哪个寄存器
            //A,B,PC,IMM
            PC_o <= PC_i;          //用于NPC决定下一条指令位置         
            Imm_o <= Imm_i;            //用于1.ALU操作数2.写回3.NPC
            ALU_o <= ALU_i;
            Ram_o <= Ram_i;
            B_o <= B_i;//用于写回数据
            halt_o_4 <= halt_i_4;
            desreg_o <= desreg_i;
        end
    end
endmodule
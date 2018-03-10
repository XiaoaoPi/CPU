`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: IF_ID
// 
//////////////////////////////////////////////////////////////////////////////////

//IF_ID流水部件
module if_id(
    input       clk, rst,
    input       [31:0] Ins_i, PC_i,
    output /*reg*/  [31:0] Ins_o, PC_o
    );
    //A,B,PC,IMM
    assign Ins_o    = Ins_i;
    assign PC_o     = PC_i;          //用于NPC决定下一条指令位置
    //assign Ext_o    = Ext_i;
    //assign Imm_o    = Imm_i;            //用于1.ALU操作数2.写回3.NPC

endmodule
/*    always @(posedge clk) begin
        if (rst) begin
            //WB，在访存结束之后，写回寄存器需要的控制信号
            MemToReg_o <= 0;    //决定写回数据的来源，是ALU还是Mem
            jal_o <= 0;         //决定写回数据的来源，是上面的结果还是PC+1
            lui_o <= 0;         //决定写回数据的来源，是否是LUI式的拓展
            Regwrite_o <= 0;    //决定是否写回
            RegDst_o <= 0;      //决定写回到哪个寄存器
            //Mem，ALU计算之后，写入存储器之前需要的控制信号
            Memwrite_o <= 0;    //决定是否存进ram
            lb_o <= 0;          //决定mem的load方式
            //EX，ALU需要的信号
            ALUOP_o <=0;        //ALU的运算符，源于IS的指令
            ALUsrc_o <= 0;      //决定ALU的B，是寄存器还是Imm
            jr_o <= 0;          //NPC中决定跳转
            j_o <= 0;           //同上
            bne_o <= 0;         //同上
            beq_o <= 0;         //同上
            blez_o <= 0;        //同上   
            //A,B,PC,IMM
            A_o <= 0;           //用于ALU的操作数
            B_o <= 0;           //用于ALU的操作数
            PC_o <= 0;          //用于NPC决定下一条指令位置
            Imm <= 0            //用于1.ALU操作数2.写回3.NPC
        end
        else if () begin
            
        end
    end*/
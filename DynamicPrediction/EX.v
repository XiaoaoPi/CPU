`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏?
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: EX
// 
//////////////////////////////////////////////////////////////////////////////////

//EX运算执行模块
module EX(
    input       clk, halt,
    input 		ALUsrc,memwrite, j, jr, jal, bne, beq, blez,
    input		[31:0]	index,
    input		[31:0]	A, B, Ext, des_memstage, des_wbstage,
    input		[3:0]	OP,
    input       [31:0]  pc_out,
    input       [4:0]   ra, rb, memdst, wbdst, 
    input       [31:0]  Imm_mem, Imm_wb, PC_mem, PC_wb, ALU_mem, ALU_wb/*, Ram_mem*/, Ram_wb, 
    input       lui_mem, lui_wb, jal_mem, jal_wb, memtoreg_mem, memtoreg_wb,
    input       [31:0] pc_pre,
    output		[31:0]	ALU,
    output 		[31:0]  next_pc, 
    output		correct_b, jump_rst,
    output      [31:0]  mem_din,
    output      pre_right, branch
    );
	wire [31:0] X, Y;
	wire EQ, OF, CF;
	wire [31:0] R2;
    assign branch = j | jr | jal | beq | bne | blez;
    assign jump_rst = branch & (pc_pre != next_pc);
    assign pre_right = pc_pre==next_pc;//在IF阶段预测成功,不一定是分支
    redirection m_redirection(ALUsrc, memwrite, A, B, Ext, des_memstage, des_wbstage, ra, rb, memdst, wbdst, Imm_mem, Imm_wb, PC_mem, PC_wb, ALU_mem, ALU_wb/*, Ram_mem*/, Ram_wb, 
                            lui_mem, lui_wb, jal_mem, jal_wb, memtoreg_mem, memtoreg_wb,
                            X, Y, mem_din);
	ALU m_ALU(X,Y,OP,
			  OF, CF, EQ, ALU, R2);
    /*NPC*///npc的来源和alu的X?致??不是和A??
    npc m_npc(halt, pc_out, X, index, Ext, EQ, j, jr, jal, bne, beq, blez,//input
              next_pc, correct_b);//output
endmodule

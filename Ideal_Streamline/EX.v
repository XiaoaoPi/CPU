`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: EX
// 
//////////////////////////////////////////////////////////////////////////////////

//EX运算执行模块
module EX(
    input       clk, halt,
    input 		ALUsrc, j, jr, jal, bne, beq, blez,
    input		[31:0]	index,
    input		[31:0]	A, B, Ext,
    input		[3:0]	OP,
    input       [31:0]  pc_out,
    output		[31:0]	ALU,
    output 		[31:0]  pc_in, 
    output		correct_b
    );
	wire [31:0] X, Y;
	wire EQ, OF, CF;
	wire [31:0] R, R2;
	assign X = A;
	assign Y = ALUsrc ? Ext : B;
	assign ALU = R;
	ALU m_ALU(X,Y,OP,
			  OF, CF, EQ, R, R2);
    /*NPC*/
    npc m_npc(halt, pc_out, A, index, Ext, EQ, j, jr, jal, bne, beq, blez,//input
              pc_in, correct_b);//output
endmodule

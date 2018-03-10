`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Module Name: NPC
// 
//////////////////////////////////////////////////////////////////////////////////

//NPC
module npc(
	input halt,
    input [31:0] pc_ex, A, index, offset,
    input EQ,
    input j, jr, jal, bne, beq, blez,
    output [31:0] next_pc,
    output  correct_b
    );
    assign correct_b = (EQ&beq)|(~EQ&bne)|((EQ|A[31])&blez);
    assign next_pc = halt? pc_ex :(jr ? A : ((j|jal) ? index : (correct_b ? (pc_ex+1+offset) : (pc_ex+1))));
endmodule

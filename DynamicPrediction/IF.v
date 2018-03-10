`timescale 1ns / 1ps

//IF取指模块
module IF(
    input       clk, RST, stall, halt, interrupt, eret,
    input       [31:0]   int_pc, pc_npc, pc_ex,
    input       [2:0] hitpos_old,
    input       hit_old, preright_old, branch_old,  
    output      [31:0]  pc_now, instruction, pc_pre,
    output  [2:0]hitpos,
    output  hit
    );
	wire	[31:0] next_pc, pc_pre;
	assign next_pc = (interrupt|eret) ? int_pc : ((~branch_old | preright_old) ? pc_pre : pc_npc);
    pc m_pc(clk, stall, halt,interrupt,RST,next_pc,
            pc_now);
    IS m_IS(pc_now[9:0],
            instruction);
    /*动态预测模块*/
    predict m_pre (clk, RST, pc_now, pc_npc, pc_ex, hitpos_old, hit_old, preright_old, branch_old,  
                    pc_pre, hitpos, hit);
endmodule

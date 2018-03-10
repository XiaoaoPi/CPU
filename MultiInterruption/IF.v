`timescale 1ns / 1ps

//IF取指模块
module IF(
    input       clk, RST, stall, halt, interrupt, eret,
    input       [31:0]  npc_pc, int_pc,
    output        [31:0]  pc_out, instruction
    );
	wire	[31:0] next_pc;
	assign next_pc = (interrupt|eret) ? int_pc : npc_pc;
    pc m_pc(clk, stall, halt,interrupt,RST,next_pc,
            pc_out);
    IS m_IS(pc_out[9:0],
            instruction);
endmodule

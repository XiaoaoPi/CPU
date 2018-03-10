`timescale 1ns / 1ps

//IF取指模块
module IF(
    input       clk, RST, stall, halt,
    input       [31:0]  next_pc,
    output        [31:0]  pc_out, instruction
    );
    pc m_pc(clk, stall, halt,RST,next_pc,
            pc_out);
    IS m_IS(pc_out[9:0],
            instruction);
endmodule

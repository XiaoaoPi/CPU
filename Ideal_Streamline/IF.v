`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: IF
// 
//////////////////////////////////////////////////////////////////////////////////

//IF取指模块
module IF(
    input       clk, RST, halt,
    input       [31:0]  next_pc,
    output        [31:0]  pc_out, instruction
    );
    pc m_pc(clk,halt,RST,next_pc,
            pc_out);
    IS m_IS(pc_out[9:0],
            instruction);
endmodule

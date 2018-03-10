`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: ME
// 
//////////////////////////////////////////////////////////////////////////////////

//ME数据存储器模块
module ME(
    input       clk, RST, Memwrite,  
    input		[1:0]mode, 
    input       [11:0]  address, extra_address,
    input		[31:0] din,
    output 		[31:0]  dout, extra_dout
    );

    DS_2ways m_DS(Memwrite, clk, RST, mode, address[11:0], extra_address[11:0], din,
    			 dout, extra_dout);
endmodule

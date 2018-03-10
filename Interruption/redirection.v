`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: Redirection
// 
//////////////////////////////////////////////////////////////////////////////////

//Redirection重定向模块模块
module redirection(
	input	ALUsrc, memwrite,
	input 	[31:0] RF_A, RF_B, Ext, des_memstage, des_wbstage,
	input	[4:0]  ra, rb, mem_dst, wb_dst,
	input	[31:0] Imm_mem, Imm_wb, PC_mem, PC_wb, ALU_mem, ALU_wb/*, Ram_mem*/, Ram_wb,
	input 	lui_mem, lui_wb, jal_mem, jal_wb, memtoreg_mem, memtoreg_wb,
	output	[31:0] X, Y, mem_din
    );
    wire A_rlvto_mem,
    	 B_rlvto_mem,
    	 A_rlvto_wb,
    	 B_rlvto_wb;
    wire	[31:0]	mem_regdin, wb_regdin;
    assign A_rlvto_mem = (ra!=0) & (ra == mem_dst);
    assign A_rlvto_wb  = (ra!=0) & (ra == wb_dst);
    assign B_rlvto_mem = (rb!=0) & (rb == mem_dst);
    assign B_rlvto_wb  = (rb!=0) & (rb == wb_dst);
    assign mem_regdin =  lui_mem?Imm_mem
						:(jal_mem? (PC_mem+1)
							 :ALU_mem);
    assign wb_regdin =  lui_wb?Imm_wb
						:(jal_wb? (PC_wb+1)
							 :(memtoreg_wb? Ram_wb:ALU_wb));						
    assign X = A_rlvto_mem ? mem_regdin : (A_rlvto_wb? wb_regdin : RF_A);
    assign Y = memwrite ? Ext :(B_rlvto_mem ? mem_regdin : (B_rlvto_wb? wb_regdin : (ALUsrc?Ext:RF_B)));
    assign mem_din = B_rlvto_mem ? des_memstage :(B_rlvto_wb ? des_wbstage : RF_B); 
endmodule

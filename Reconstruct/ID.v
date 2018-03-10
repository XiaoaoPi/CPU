`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: ID
// 
//////////////////////////////////////////////////////////////////////////////////

//ID取指模块
module ID(
    input       clk,
    input 		regwrite_wb, memtoreg_wb, jal_wb, lui_wb, 
    input 		[4:0]	rw_wb,//来源于wb阶段
    input 		[31:0] Imm_wb, PC_wb,ALU_wb,Ram_wb,//同上
    input       [31:0]  ins,
    output		[31:0] 	SyscallOut,
    output		halt,
    output 		[3:0]	ALUOP,
    output 		[4:0] 	rw,
    output 		jr ,jal ,j ,bne ,beq ,blez ,
    output 		Memwrite, MemToReg ,Regwrite ,ALUsrc ,RegDst ,
    output 		lb ,
    output 		lui ,
    output 		[31:0] A , B ,Ext , Imm,
    output		[31:0] index
    );
    reg  [31:0] cnt = 0;
    wire [31:0] cnt_in;
    wire show;
	wire [1:0]EXTOP;
	wire [31:0] sign_ext, zero_ext, reg_ext;
	wire Syscall,  S;
	wire [4:0] rA, rB;
	wire [31:0] Din_reg_wb;
	assign Din_reg_wb =  lui_wb?Imm_wb
							:(jal_wb? (PC_wb+1)
								 :(memtoreg_wb?Ram_wb:ALU_wb));
 	assign  show = (A!=32'ha)&&Syscall;
	assign 	S = (EXTOP == 2);
	assign  rA = Syscall ? 5'h02 : (S ? ins[20:16] : ins[25:21]);
	assign  rB = Syscall ? 5'h04 : ins[20:16];
	assign 	rw = jal ? 5'h1f : (RegDst ? ins[15:11] :ins[20:16]) ;
	assign 	Ext = EXTOP[1]?(EXTOP[0]?0:reg_ext):(EXTOP[0]?zero_ext:sign_ext);
	assign 	Imm = {ins[15:0], 16'h0000};
	assign  halt =  (Syscall & (A==32'h000a)) | (ins == 32'h0000);
	assign index = {6'h0,ins[25:0]};
    always @(posedge clk)
    begin
    	cnt <= cnt_in;
    end
    assign cnt_in = show ? B : cnt;
    assign SyscallOut = show ? cnt_in: cnt;

	extender m_extender(ins, sign_ext, zero_ext, reg_ext);
   	controller m_controller(ins[31:26], ins[5:0], 
   		Syscall,ALUOP,jr,jal,j,bne,beq,EXTOP,Memwrite,MemToReg,Regwrite,ALUsrc,RegDst,lb,blez, lui);
   	regfile m_regfile(clk, regwrite_wb, rw_wb, rA, rB, Din_reg_wb, 
   						A, B);
endmodule
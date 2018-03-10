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
    input       clk, rst,
    input 		regwrite_wb, memtoreg_wb, jal_wb, lui_wb, 
    input 		[4:0]	rw_wb,//来源于wb阶段
    input 		[31:0] Imm_wb, PC_wb,ALU_wb,Ram_wb,//同上
    input       [31:0]  ins,
    input       [4:0]   ex_des, mem_des, wb_des,     //ex和mem阶段指令的目的寄存器,不修改寄存器即为0
    input       memtoreg_ex,        //决定是否是load指令
    output		[31:0] 	SyscallOut,
    output		halt_2,
    output 		[3:0]	ALUOP,
    output 		[4:0] 	rw,
    output 		jr ,jal ,j ,bne ,beq ,blez ,
    output 		Memwrite, MemToReg ,Regwrite ,ALUsrc ,RegDst ,
    output 		lb ,
    output 		lui ,
    output 		[31:0] A , B ,Ext , Imm,//当指令不会用到A，B时，传0出去
    output		[31:0] index,
    output      [4:0] des_reg, ra_o, rb_o,  //指示该条指令的目的寄存器（传进流水）
    output      lu_conf, sys_conf, eret, mfc0, mtc0
    );

    reg  [31:0] cnt = 0;
    wire [31:0] cnt_in;
    wire show;
	wire [1:0]EXTOP;
	wire [31:0] sign_ext, zero_ext, reg_ext;
	wire Syscall,  S;
	wire [4:0] rA, rB;
	wire [31:0] Din_reg_wb;
    //wire [31:0] A, B;
    wire dpdon_a, dpdon_b;//用来指示当前指令是否要使用a和b
    wire   load_use;   //用来指示load_use型的相关（当前阶段判断)
    wire    sys_dpd;
    //用来指示在写回阶段写回什么数据
	assign Din_reg_wb = mcf0? epc_wb:
                            (lui_wb?Imm_wb:
							    (jal_wb? (PC_wb+1):
								    (memtoreg_wb?Ram_wb:ALU_wb)));
 	assign  show = (A!=32'ha)&&Syscall;
	assign 	S = (EXTOP == 2);
	assign  rA = Syscall ? 5'h02 : (S ? ins[20:16] : ins[25:21]);
	assign  rB = Syscall ? 5'h04 : ins[20:16];
	assign 	rw = jal ? 5'h1f : (RegDst ? ins[15:11] :ins[20:16]) ;
	assign 	Ext = EXTOP[1]?(EXTOP[0]?0:reg_ext):(EXTOP[0]?zero_ext:sign_ext);
	assign 	Imm = {ins[15:0], 16'h0000};
	assign  halt_2 =  Syscall & (A==32'h000a);
	assign index = {6'h0,ins[25:0]};
    assign ra_o = dpdon_a ? rA : 0;
    assign rb_o = dpdon_b ? rB : 0;
    always @(posedge clk)
    begin
        if(rst) begin 
    	   cnt <= 0;
        end
           cnt <= cnt_in;
    end
    assign cnt_in = show ? B : cnt;
    assign SyscallOut = show ? cnt_in: cnt;
    /*判断是否是load_use的情况*/
    assign load_use = memtoreg_ex & ((dpdon_a && (ex_des==rA))|(dpdon_b && (ex_des==rB)));//下一条指令是load，且和本条指令有关联
    /*判断是否有系统调用冲突*///当前指令是系统调用，而且和后面三个阶段中的任何一个有数据冲突
    assign sys_dpd = Syscall & (((ex_des==5'h02)|(ex_des==5'h04))|((mem_des==5'h02)|(mem_des==5'h04))|((wb_des==5'h02)|(wb_des==5'h04)));
    /*如果是load_use产生一个气泡：之前的暂停，ID_EX部件清零*/
    assign sys_conf = sys_dpd;
    assign lu_conf = load_use;
	extender m_extender(ins, sign_ext, zero_ext, reg_ext);
   	controller m_controller(ins, 
   		Syscall,ALUOP,jr,jal,j,bne,beq,EXTOP,Memwrite,MemToReg,Regwrite,ALUsrc,RegDst,lb,blez, lui,
        des_reg, dpdon_a, dpdon_b,//重定向相关
        eret, mfc0, mtc0);
   	regfile m_regfile(clk, regwrite_wb, rw_wb, rA, rB, Din_reg_wb, 
   						A, B);
endmodule
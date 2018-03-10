module i7_6700k(
	input clk_fast,
	input RST,
	input [2:0]pro_reset,
	input [11:0]in_addr,
    input frq_switch,
	output [15:0]leds,
	output [7:0]SEG,
    output [7:0]AN,
    output  halt_o_4 
    );
    /*声明*/
    wire    clk, correct_b,
            halt_i_2, halt_i_3, halt_i_4, halt_o_2, halt_o_3,//
            jr_i_2, jr_o_2,
            jal_i_2, jal_i_3, jal_i_4, jal_o_2, jal_o_3, jal_o_4,
            j_i_2, j_o_2,
            bne_i_2, bne_o_2,
            beq_i_2, beq_o_2,
            blez_i_2, blez_o_2,
            Memwrite_i_2, Memwrite_i_3, Memwrite_o_2, Memwrite_o_3,
            MemToReg_i_2, MemToReg_i_3, MemToReg_i_4, MemToReg_o_2, MemToReg_o_3, MemToReg_o_4,
            Regwrite_i_2, Regwrite_i_3, Regwrite_i_4, Regwrite_o_2, Regwrite_o_3, Regwrite_o_4, 
            ALUsrc_i_2, ALUsrc_o_2,
            RegDst_i_2, RegDst_i_3, RegDst_i_4, RegDst_o_2, RegDst_o_3, RegDst_o_4, 
            lb_i_2, lb_i_3, lb_o_2, lb_o_3, 
            lui_i_2, lui_i_3, lui_i_4, lui_o_2, lui_o_3, lui_o_4;

    wire [31:0] npc_pc, SyscallOut, extra_dout,
                total, conditional, unconditional, conditional_success, chose_out, load_use,
                Ins_i_1, Ins_o_1, 
                PC_i_1, PC_i_2, PC_i_3, PC_i_4, PC_o_1, PC_o_2, PC_o_3, PC_o_4,
                A_i_2, A_o_2, 
                B_i_2, B_i_3, B_i_4, B_o_2, B_o_3, B_o_4, 
                Ext_i_2, Ext_o_2, 
                Imm_i_2, Imm_i_3, Imm_i_4, Imm_o_2, Imm_o_3, Imm_o_4, 
                index_i_2, index_o_2,
                ALU_i_3, ALU_i_4, ALU_o_3, ALU_o_4,
                Ram_i_4, Ram_o_4,
                mem_din_i_3, mem_din_o_3;
    wire [3:0]  ALUOP_i_2, ALUOP_o_2;
    wire [4:0]  rw_i_2, rw_i_3, rw_i_4, rw_o_2, rw_o_3, rw_o_4,
                ra_i_2, ra_o_2,
                rb_i_2, rb_o_2;
    //冲突信号
    wire lu_conf, sys_conf, stall, bubble_rst, jump_rst;
    wire [4:0]  desreg_i_2, desreg_i_3, desreg_i_4, desreg_o_2, desreg_o_3, desreg_o_4;
    wire    [31:0] mem_stage_data, wb_stage_data, des_memstage, des_wbstage;
    /*流水传递*/
    assign halt_i_4 = halt_o_3;
    assign halt_i_3 = halt_o_2;
    assign jal_i_4 = jal_o_3;
    assign jal_i_3 = jal_o_2;
    assign Memwrite_i_3 = Memwrite_o_2;
    assign MemToReg_i_4 = MemToReg_o_3;
    assign MemToReg_i_3 = MemToReg_o_2;
    assign Regwrite_i_4 = Regwrite_o_3;
    assign Regwrite_i_3 = Regwrite_o_2;
    assign RegDst_i_4 = RegDst_o_3;
    assign RegDst_i_3 = RegDst_o_2;
    assign lb_i_3  = lb_o_2;
    assign lui_i_4 = lui_o_3;
    assign lui_i_3 = lui_o_2;
    assign PC_i_4 = PC_o_3;
    assign PC_i_3 = PC_o_2;
    assign PC_i_2 = PC_o_1;
    assign B_i_4 = B_o_3;
    assign B_i_3 = B_o_2;
    assign Imm_i_4 = Imm_o_3;
    assign Imm_i_3 = Imm_o_2;
    assign ALU_i_4 = ALU_o_3;
    assign rw_i_4 = rw_o_3;
    assign rw_i_3 = rw_o_2;
    //冲突信号
    assign bubble_rst = lu_conf|sys_conf;
    assign stall = lu_conf|sys_conf;
    assign desreg_i_4 = desreg_o_3;
    assign desreg_i_3 = desreg_o_2;
    assign des_memstage = mem_stage_data;
    assign des_wbstage = wb_stage_data;
    /*分频*/
    divider m_divider(  clk_fast, frq_switch,
                        clk);
    /*阶段模块*/
    IF m_IF(clk, RST, stall, halt_i_2, npc_pc,         
                        PC_i_1, Ins_i_1);  
    ID m_ID(clk,        Regwrite_o_4, MemToReg_o_4, jal_o_4, lui_o_4, rw_o_4, Imm_o_4, PC_o_4,ALU_o_4, Ram_o_4, Ins_o_1, desreg_o_2, desreg_o_3, desreg_o_4, MemToReg_o_2,
                        SyscallOut, halt_i_2, ALUOP_i_2, rw_i_2, jr_i_2,jal_i_2,j_i_2,bne_i_2,beq_i_2,blez_i_2,Memwrite_i_2, MemToReg_i_2,Regwrite_i_2,ALUsrc_i_2,RegDst_i_2,lb_i_2,lui_i_2,A_i_2, B_i_2,Ext_i_2, Imm_i_2, index_i_2,
                        desreg_i_2, ra_i_2, rb_i_2, lu_conf, sys_conf);
    EX m_EX(clk, halt_i_2,ALUsrc_o_2, Memwrite_o_2, j_o_2, jr_o_2, jal_o_2, bne_o_2, beq_o_2, blez_o_2, index_o_2, A_o_2, B_o_2, Ext_o_2, des_memstage, des_wbstage,  ALUOP_o_2, PC_i_1,
                        ra_o_2, rb_o_2, desreg_o_3, desreg_o_4, Imm_o_3, Imm_o_4, PC_o_3, PC_o_4,ALU_o_3, ALU_o_4/*, Ram_o_3*/, Ram_o_4,  lui_o_3, lui_o_4, jal_o_3, jal_o_4, MemToReg_o_3, MemToReg_o_4,
                        ALU_i_3, npc_pc, correct_b, jump_rst, mem_din_i_3);
    ME m_ME(clk, RST,   Memwrite_o_3, {1'b0,lb_o_3}, ALU_o_3[11:0], in_addr, mem_din_o_3,
                        Ram_i_4, extra_dout);
    /*流水部件*/
    if_id m_if_id   (clk, RST,jump_rst, stall, halt_i_2, Ins_i_1, PC_i_1, 
                                		 Ins_o_1, PC_o_1);
    id_ex m_id_ex   (clk, RST,jump_rst,     bubble_rst, halt_i_2,ALUOP_i_2,rw_i_2, jr_i_2,jal_i_2,j_i_2,bne_i_2,beq_i_2,blez_i_2,Memwrite_i_2, MemToReg_i_2,Regwrite_i_2,ALUsrc_i_2,RegDst_i_2,lb_i_2,lui_i_2,index_i_2,A_i_2, B_i_2,Ext_i_2, Imm_i_2, PC_i_2, desreg_i_2, ra_i_2, rb_i_2,
                                                        halt_o_2,ALUOP_o_2,rw_o_2, jr_o_2,jal_o_2,j_o_2,bne_o_2,beq_o_2,blez_o_2,Memwrite_o_2, MemToReg_o_2,Regwrite_o_2,ALUsrc_o_2,RegDst_o_2,lb_o_2,lui_o_2,index_o_2,A_o_2, B_o_2,Ext_o_2, Imm_o_2, PC_o_2, desreg_o_2, ra_o_2, rb_o_2);
    ex_mem m_ex_mem (clk, RST,  halt_i_3,rw_i_3, jal_i_3,Memwrite_i_3, MemToReg_i_3,Regwrite_i_3,RegDst_i_3,lb_i_3,lui_i_3,B_i_3, Imm_i_3, PC_i_3, ALU_i_3, desreg_i_3, mem_din_i_3,
                                halt_o_3,rw_o_3, jal_o_3,Memwrite_o_3, MemToReg_o_3,Regwrite_o_3,RegDst_o_3,lb_o_3,lui_o_3,B_o_3, Imm_o_3, PC_o_3, ALU_o_3, desreg_o_3, mem_din_o_3, mem_stage_data);
    mem_wb m_mem_wb (clk, RST,  halt_i_4,rw_i_4, jal_i_4,MemToReg_i_4,Regwrite_i_4,RegDst_i_4,lui_i_4,Imm_i_4,PC_i_4, ALU_i_4, Ram_i_4, B_i_4, desreg_i_4,
                                halt_o_4,rw_o_4, jal_o_4,MemToReg_o_4,Regwrite_o_4,RegDst_o_4,lui_o_4,Imm_o_4,PC_o_4, ALU_o_4, Ram_o_4, B_o_4, desreg_o_4, wb_stage_data);
    /*显示模块*/
    operating_parameter m_op(RST, clk, halt_o_4, sys_conf , j_o_2, jal_o_2, jr_o_2, blez_o_2, beq_o_2, bne_o_2, correct_b, lu_conf,
                            total, conditional, unconditional, conditional_success, load_use);
    led m_led               (RST,pro_reset,in_addr,
                            leds);
    change_type m_ct        (clk,SyscallOut,extra_dout,PC_o_1,total,unconditional,conditional,conditional_success,load_use,pro_reset,in_addr,
                            chose_out/*,in_addr*/);
    display m_display       (clk_fast, chose_out,
                            SEG, AN);
endmodule

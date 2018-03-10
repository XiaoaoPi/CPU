module i7_6700k(
	input clk_fast,
	input RST,
	input [2:0]pro_reset,
	input [11:0]in_addr,
    input frq_switch,
	output [15:0]leds,
	output [7:0]SEG,
    output [7:0]AN
    );
    /*声明*/
    wire    clk, halt, correct_b,
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
                total, conditional, unconditional, conditional_success, chose_out,
                Ins_i_1, Ins_o_1, 
                PC_i_1, PC_i_2, PC_i_3, PC_i_4, PC_o_1, PC_o_2, PC_o_3, PC_o_4,
                A_i_2, A_o_2, 
                B_i_2, B_i_3, B_i_4, B_o_2, B_o_3, B_o_4, 
                Ext_i_2, Ext_o_2, 
                Imm_i_2, Imm_i_3, Imm_i_4, Imm_o_2, Imm_o_3, Imm_o_4, 
                index_i_2, index_o_2,
                ALU_i_3, ALU_i_4, ALU_o_3, ALU_o_4,
                Ram_i_4, Ram_o_4;
    wire [3:0]  ALUOP_i_2, ALUOP_o_2;
    wire [4:0]  rw_i_2, rw_i_3, rw_i_4, rw_o_2, rw_o_3, rw_o_4;
    /*流水传递*/
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
    /*分频*/
    divider m_divider(  clk_fast, frq_switch,
                        clk);
    /*阶段模块*/
    IF m_IF(clk, RST,   halt, npc_pc,         
                        PC_i_1, Ins_i_1);  
    ID m_ID(clk,        Regwrite_o_4, MemToReg_o_4, jal_o_4, lui_o_4, rw_o_4, Imm_o_4, PC_o_4,ALU_o_4, Ram_o_4, Ins_o_1,
                        SyscallOut, halt, ALUOP_i_2, rw_i_2, jr_i_2,jal_i_2,j_i_2,bne_i_2,beq_i_2,blez_i_2,Memwrite_i_2, MemToReg_i_2,Regwrite_i_2,ALUsrc_i_2,RegDst_i_2,lb_i_2,lui_i_2,A_i_2, B_i_2,Ext_i_2, Imm_i_2, index_i_2);
    EX m_EX(clk,        ALUsrc_o_2, j_o_2, jr_o_2, jal_o_2, bne_o_2, beq_o_2, blez_o_2, index_o_2, A_o_2, B_o_2, Ext_o_2, ALUOP_o_2, PC_i_1,
                        ALU_i_3, npc_pc, correct_b);
    ME m_ME(clk, RST,   Memwrite_o_3, {1'b0,lb_o_3}, ALU_o_3[11:0], in_addr, B_o_3,
                        Ram_i_4, extra_dout);
    /*流水部件*/
    if_id m_if_id   (clk, RST,  Ins_i_1, PC_i_1, 
                                Ins_o_1, PC_o_1);
    id_ex m_id_ex   (clk, RST,  ALUOP_i_2,rw_i_2, jr_i_2,jal_i_2,j_i_2,bne_i_2,beq_i_2,blez_i_2,Memwrite_i_2, MemToReg_i_2,Regwrite_i_2,ALUsrc_i_2,RegDst_i_2,lb_i_2,lui_i_2,index_i_2,A_i_2, B_i_2,Ext_i_2, Imm_i_2, PC_i_2,
                                ALUOP_o_2,rw_o_2, jr_o_2,jal_o_2,j_o_2,bne_o_2,beq_o_2,blez_o_2,Memwrite_o_2, MemToReg_o_2,Regwrite_o_2,ALUsrc_o_2,RegDst_o_2,lb_o_2,lui_o_2,index_o_2,A_o_2, B_o_2,Ext_o_2, Imm_o_2, PC_o_2);
    ex_mem m_ex_mem (clk, RST,  rw_i_3, jal_i_3,Memwrite_i_3, MemToReg_i_3,Regwrite_i_3,RegDst_i_3,lb_i_3,lui_i_3,B_i_3, Imm_i_3, PC_i_3, ALU_i_3,
                                rw_o_3, jal_o_3,Memwrite_o_3, MemToReg_o_3,Regwrite_o_3,RegDst_o_3,lb_o_3,lui_o_3,B_o_3, Imm_o_3, PC_o_3, ALU_o_3);
    mem_wb m_mem_wb (clk, RST,  rw_i_4, jal_i_4,MemToReg_i_4,Regwrite_i_4,RegDst_i_4,lui_i_4,Imm_i_4,PC_i_4, ALU_i_4, Ram_i_4,B_i_4,
                                rw_o_4, jal_o_4,MemToReg_o_4,Regwrite_o_4,RegDst_o_4,lui_o_4,Imm_o_4,PC_o_4, ALU_o_4, Ram_o_4,B_o_4);
    /*显示模块*/
    operating_parameter m_op(RST, clk, halt, j_i_2, jal_i_2, jr_i_2, blez_i_2, beq_i_2, bne_i_2, correct_b,
                            total, conditional, unconditional, conditional_success);
    led m_led               (RST,pro_reset,in_addr,
                            leds);
    change_type m_ct        (clk,SyscallOut,extra_dout,PC_o_1,total,unconditional,conditional,conditional_success,pro_reset,in_addr,
                            chose_out/*,in_addr*/);
    display m_display       (clk_fast, chose_out,
                            SEG, AN);
endmodule



////controller
//wire [5:0]op;
//wire [5:0]func;//in
//wire Syscall;
//wire [3:0]ALUOP;
//wire jr,jal,j,bne,beq;
//wire [1:0]EXTOP;
//wire Memwrite,MemToReg,Regwrite,ALUsrc,RegDst, blez, lui;
//wire [1:0]lb;
////ALU
//wire [31:0]X;
//wire [31:0]Y;
//wire [3:0]OP;//in
//wire OF;
//wire CF;
//wire EQ;
//wire [31:0]R;
//wire [31:0]R2;

////extender
//wire [31:0] ROM_D;//in
//wire [31:0] d4;
//wire [31:0] d5;
//wire [31:0] d7;

////IS
//wire [9:0] address; //in
//wire [31:0] data_out;

////DS
//wire    str,    //???1?0?2?0????? 
//        clk,    //???0?0??0?2?
//        clr;    //???1?0?2?????
//wire    [1:0]mode;  //???0?0?2????1?0?2???1?3?
//wire    [11:0]extra_address;
//wire    [11:0] d_address;   //???????
//wire    [31:0] data_in; //???1?5???
//wire    [31:0] d_dout;  //???1?5???
//wire    [31:0]extra_dout;

////PC
//wire [31:0]pc_in;
//wire halt;
//wire rst;
//wire pc_clk;//in
//wire [31:0] pc_out;

////regfile
//wire r_clk, WE;//write enable control
//wire [4:0] rW, rA, rB;//register addr
//wire [31:0] W;//data to rW //in
//wire [31:0] A, B;//data from rA,rB

////cpu_choose
//wire [31:0] PC,RegFile_E,index,RF_A,ALU_R,RAM_D;//deleted ROM_D
//wire S,correct_b;
//  wire [1:0] EXTOP;//in
//wire [4:0] out0,out1,out2,out3,out4;
//wire [31:0] out5,out6,out7,out8,out9,out10,out11,out13,out14,SyscallOut;
//
////operating_parameter
//wire o_rst;
//wire o_clk;


////divider
//wire clk_fast;//system clock, reset button
//wire clk;



////??????????
////controller input

//assign op = data_out[31:26];
//assign func = data_out[5:0];

////ALU input
//assign X = A;
//assign Y = out6;
//assign OP = ALUOP;

////IS input
//assign address = pc_out[9:0];

////DS input
//assign str = Memwrite;
//assign clk = clk;
//assign clr = RST;
//assign mode = 0;//?0?1?0?0?????    assign d_address = R[9:0];
//assign data_in = B;

////PC input;
//assign pc_clk = clk;
//assign halt = ((data_out==0)|((RF_A==10)&Syscall))&~RST;
//assign rst = RST;
//assign pc_in = out11;

////regfile input
//assign r_clk = clk;
//assign WE = Regwrite;
//assign rW = out4;
//assign rA = out1;
//assign rB = out3;
//assign W = out8;

////change_type input
//wire [31:0]chose_out;
//wire [11:0]RAM_addr;
//assign extra_address = RAM_addr;

////cpu frq_switch
//assign ROM_D = data_out;
//assign PC = pc_out;
//assign RegFile_E = B;
//assign index[25:0] = data_out[25:0];
//assign index[31:26] = 0;
//assign RF_A = A;
//assign ALU_R = R;
//assign RAM_D = d_dout;
//assign S = (EXTOP == 2);
//assign correct_b = (EQ&beq)|(~EQ&bne)|((EQ|A[31])&blez);

////operating_parameter
//assign o_rst = RST;
//assign o_clk = clk;

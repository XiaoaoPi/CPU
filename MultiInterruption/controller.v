`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/26 14:49:35
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input [31:0] ins,
    output reg  Syscall,
    output reg [3:0]ALUOP,//ALU模式控制
    output reg jr,jal,j,bne,beq,//特殊跳转指令信号
    output reg [1:0]EXTOP,//立即数扩展控制
    output reg Memwrite, MemToReg,Regwrite,ALUsrc,RegDst,
    output reg lb, //CCMB,lb, 用于数据存储器的mode
    output reg blez,    //ccmb,blez
    output reg lui,    //ccmb,lui
    output reg [4:0] des_reg,  //指示该条指令的目的寄存器,如果不改变寄存器的值，这里填0（传进流水）
    output reg dpdon_a, dpdon_b,//指示该条指令是否依赖A或者B
    output reg eret, mfc0, mtc0 //中断服务程序结束
    );
    wire   [5:0]op, func;
    wire    [4:0] rs, rt, rd, MF;
    assign op = ins[31:26];
    assign MF = ins[25:21];
    assign func = ins[5:0];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    initial begin
        jr <=0;
        jal <=0;
        j<=0;
        bne<=0;
        beq <=0;
        blez <= 0;
        Memwrite <=0;
        MemToReg<=0;
        ALUsrc <=0;
        Syscall <=0;
        RegDst <= 0;//目的为rt
        Regwrite <= 0;//要写入寄存器
        EXTOP <= 2'b00;
        ALUOP <= 4'b0000;
        lb <= 1'b0;
        lui <= 0;
        /*重定向信息*/
        des_reg <= 0;
        dpdon_a <= 0;
        dpdon_b <= 0;
        /*中断信号*/
        eret <= 0;
        mtc0 <= 0;
        mfc0 <= 0;
    end
    always @(*)
    begin
        if (op == 6'b010000) begin
            case(MF)
                5'b00000:begin//MFC0        这里不考虑MFC0和MTC0之间的数据冲突，因此他们之间有距离
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 0;//目的为rt
                    Regwrite <= 1;//要写入寄存器
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 1;
                end
                5'b00100:begin//MTC0
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 0;//
                    Regwrite <= 0;//
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 1;
                    mfc0 <= 0;
                end
                5'b10000:begin//ERET
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 0;//
                    Regwrite <= 0;//
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 1;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
            endcase
        end
        else if(op == 6'b000000) begin//13 special instructions
            case(func)
                6'b000100:begin//sllv
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100000:begin//add
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100001:begin//addu
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100100:begin//and
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0111;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100111:begin//nor
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1010;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100101:begin//or
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000000:begin//sll
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    EXTOP <= 2'b10;
                    ALUOP <= 4'b0000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000011:begin//sra
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    EXTOP <= 2'b10;
                    ALUOP <= 4'b0001;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000010:begin//srl
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    EXTOP <= 2'b10;
                    ALUOP <= 4'b0010;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100010:begin//sub
                    jr <=0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    Syscall <=0;
                    RegDst <= 1;
                    Regwrite <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0110;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001000:begin//jr
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    RegDst <= 0;
                    Regwrite <= 0;
                    Syscall <=0;
                    jr <= 1;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                end
                6'b001100:begin//syscall
                    Syscall <= 1;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    RegDst <= 0;
                    Regwrite <= 0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b101010:begin//slt
                    RegDst <= 1;
                    Regwrite <= 1;
                    Syscall <= 0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1011;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b101011:begin//sltu
                    RegDst <= 1;
                    Regwrite <= 1;
                    Syscall <= 0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    ALUsrc <=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1100;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rd;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
            endcase
        end
        else begin
            case(op)//11条普通指令
                6'b001111:begin//lui
                    Regwrite <= 1;
                    ALUsrc <= 0;
                    RegDst <= 0;
                    Syscall <= 0;
                    jal <=0;
                    j <=0;
                    bne <=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1011;
                    lb <= 1'b0;
                    lui <= 1;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100000:begin//lb
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    RegDst <= 0;
                    Syscall <= 0;
                    jal <=0;
                    j <=0;
                    bne <=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=1;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b1;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000110:begin//BLEZ
                    Regwrite <= 0;
                    ALUsrc <= 0;
                    RegDst <= 0;
                    Syscall <= 0;
                    jal <=0;
                    j <=0;
                    bne <=0;
                    beq <=0;
                    blez <= 1;
                    Memwrite <=0;
                    MemToReg<=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1011;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001000:begin//addi
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    RegDst <= 0;
                    Syscall <= 0;
                    jal <=0;
                    j <=0;
                    bne <=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001001:begin//addiu
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    RegDst <= 0;
                    Syscall <= 0;
                    jal <=0;
                    j<=0;
                    bne<=0;
                    beq <=0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg<=0;
                    jr <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001100:begin//andi
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0111;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001101:begin//ori
                    Regwrite <= 1;
                    ALUsrc <= 1;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b01;
                    ALUOP <= 4'b1000;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000100:begin//beq
                    beq <= 1;
                    blez <= 0;
                    bne <= 0;
                    ALUsrc <= 0;
                    Regwrite <= 0;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000101:begin//bne
                    bne <= 1;
                    ALUsrc <= 0;
                    Regwrite <= 0;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000010:begin//j
                    j <= 1;
                    ALUsrc <= 0;
                    Regwrite <= 0;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    Regwrite <= 0;
                    ALUsrc <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b000011:begin//jal
                    jal <= 1;
                    Regwrite <= 1;
                    ALUsrc <= 0;
                    Syscall <= 0;
                    jr <= 0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    ALUsrc <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 5'h1f;
                    dpdon_a <= 0;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b100011:begin//lw
                    ALUsrc <= 1;
                    Regwrite <= 1;
                    MemToReg <= 1;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b101011:begin//sw
                    ALUsrc <= 1;
                    Memwrite <= 1;
                    Regwrite <= 0;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b0101;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= 0;
                    dpdon_a <= 1;
                    dpdon_b <= 1;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
                6'b001010:begin//slti
                    ALUsrc <= 1;
                    Regwrite <= 1;
                    Syscall <= 0;
                    jr <= 0;
                    jal <=0;
                    j <= 0;
                    bne <= 0;
                    beq <= 0;
                    blez <= 0;
                    Memwrite <=0;
                    MemToReg <= 0;
                    RegDst <= 0;
                    EXTOP <= 2'b00;
                    ALUOP <= 4'b1011;
                    lb <= 1'b0;
                    lui <= 0;
                    /*重定向信息*/
                    des_reg <= rt;
                    dpdon_a <= 1;
                    dpdon_b <= 0;
                    /*中断信号*/
                    eret <= 0;
                    mtc0 <= 0;
                    mfc0 <= 0;
                end
            endcase
        end
    end
endmodule


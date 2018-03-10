`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HUST
// Engineer: 张苏跃
// 
// Create Date: 2018/03/2 09:42:02
// Design Name: CPU_Optimal_Streamline
// Module Name: IF_ID
// 
//////////////////////////////////////////////////////////////////////////////////

//IF_ID流水部件
module if_id(
    input       clk, rst, interrupt, eret, jump_rst, stall, halt, 
    input       [31:0] Ins_i, PC_i, prepc_i, 
    input       [2:0]  hitpos_i,
    input       hit_i,
    output reg  [31:0] Ins_o, PC_o, prepc_o, 
    output reg  [2:0]  hitpos_o,
    output reg  hit_o
    );
    initial begin
        Ins_o  <= 0;
        PC_o   <= 0;       
        prepc_o <=0;
        hitpos_o <=0;
        hit_o <=0;
    end
    always @(posedge clk) begin
        if (rst | jump_rst | interrupt | eret) begin
            Ins_o  <= 0;
            PC_o   <= 0;  
            prepc_o <=0;
            hitpos_o <=0;
            hit_o <=0;        
        end
        else if(halt) begin
            Ins_o  <= 32'h000c;
            PC_o   <= PC_i;  
            prepc_o <= prepc_i;
            hitpos_o <= hitpos_i;
            hit_o <=hit_i;   
        end
        else if(stall) begin
            Ins_o <= Ins_o;
            PC_o  <= PC_o;
            prepc_o <= prepc_o;
            hitpos_o <= hitpos_o;
            hit_o <=hit_o; 
        end
        else begin
            Ins_o  <= Ins_i;
            PC_o   <= PC_i;  
            prepc_o <= prepc_i;
            hitpos_o <= hitpos_i;
            hit_o <=hit_i;         
        end
    end
    //A,B,PC,IMM
endmodule

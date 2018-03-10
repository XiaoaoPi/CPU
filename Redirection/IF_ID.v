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
    input       clk, rst, jump_rst, stall, halt, 
    input       [31:0] Ins_i, PC_i,
    output reg  [31:0] Ins_o, PC_o
    );
    initial begin
        Ins_o  <= 0;
        PC_o   <= 0;          
    end
    always @(posedge clk) begin
        if (rst | jump_rst) begin
            Ins_o  <= 0;
            PC_o   <= 0;          
        end
        else if(halt) begin
            Ins_o  <= 32'h000c;
            PC_o   <= PC_i;     
        end
        else if(stall) begin
            Ins_o <= Ins_o;
            PC_o  <= PC_o;
        end
        else begin
            Ins_o  <= Ins_i;
            PC_o   <= PC_i;          
        end
    end
    //A,B,PC,IMM
endmodule

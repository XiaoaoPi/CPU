`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/26 09:28:57
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ALU(X,Y,OP,OF,CF,EQ,R,R2);//全功能实现
    input [31:0]X;
    input [31:0]Y;
    input [3:0]OP;
    output reg OF;
    output reg CF;
    output reg EQ;
    output reg [31:0]R;
    output reg [31:0]R2;
    reg [63:0]temp;
    reg [32:0]overflow;
    always @(*)
    begin
        EQ<=(X==Y)?1:0;
        case(OP)
            4'b0000:begin
                R<=X<<Y[4:0];
                R2<=0;
                CF<=0;
                OF<=0;
            end
            4'b0001:begin
                R<=($signed(X))>>>Y[4:0];
                R2<=0;
                CF<=0;
                OF<=0;
            end
            4'b0010:begin
                R<=X>>Y;
                R2<=0;
                CF<=0;
                OF<=0;
            end
            4'b0011:begin
                temp=$signed(X)*$signed(Y);
                R<=temp[31:0];
                R2<=temp[63:32];
                CF<=0;
                OF<=0;
            end
            4'b0100:begin
                R<=X/Y;
                R2<=X%Y;
                CF<=0;
                OF<=0;
            end
            4'b0101:begin
                overflow=X+Y;
                R<=overflow[31:0];
                CF<=overflow[32];
                OF<=(X[31]^~Y[31])^overflow[31];
                R2<=0;
            end
            4'b0110:begin
                overflow=X-Y;
                R<=overflow[31:0];
                CF<=overflow[32];
                OF<=(X[31]^Y[31])&(overflow[31]^X[31]);
                R2<=0;
            end
            4'b0111:begin
                R<=X&Y;
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1000:begin
                R<=X|Y;
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1001:begin
                R<=X^Y;
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1010:begin
                R<=~(X|Y);
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1011:begin
                R<=($signed(X)<$signed(Y))?1:0;
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1100:begin
                R<=($unsigned(X)<$unsigned(Y))?1:0;
                CF<=0;
                OF<=0;
                R2<=0;
            end
            4'b1101:begin//sllv
                R<=Y<<X[4:0];
                CF<=0;
                OF<=0;
                R2<=0;
            end
        endcase
    end
endmodule

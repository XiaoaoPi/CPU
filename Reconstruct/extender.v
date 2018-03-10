`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/26 15:44:09
// Design Name: 
// Module Name: extender
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


module extender(
input [31:0] ROM_D,
output reg [31:0] d4,//符号位拓展
output reg [31:0] d5,//0拓展
output reg [31:0] d7 //5->32
    );
    reg [15:0] d3;
    reg [4:0] d6;
    always @(*)
    begin
    d3<=ROM_D[15:0];
    d6<=ROM_D[10:6];
    d4[31:16] <={16{d3[15]}};
    d4[15:0] <= d3;
//    d4<={16{d3[15]},d3};
    d5[31:16] <= 0;
    d5[15:0] <= d3;
//    d5<={16{0},d3};
    d7[31:5] <= 0;
    d7[4:0] <= d6;
//    d7<={27{0},d6};
    end
endmodule

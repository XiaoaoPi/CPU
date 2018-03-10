`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/26 14:11:04
// Design Name: 
// Module Name: led
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
module led(reset,pro_reset,in_addr,leds);
input reset; //总开关，数据正常显示
input [2:0]pro_reset;   //3个开关组合来选择各种参数：比如PC的值，比如时钟周期数，有条件分支转移数等等
//001代表查看pc值
//010代表查看周期数
//011代表查看有条件分支转移数
//100代表查看有条件分支转移成功数
//101代表查看无条件分支指令数
input [11:0]in_addr;    //地址输入拨码开关,12位地址值，总共4K的内存
output [15:0]leds;  //16位的led灯的显示

assign leds[15]=reset;  //重置指示灯,最左边

assign leds[2:0]=pro_reset;   //显示各种参数的的led灯

assign leds[14:3]=in_addr;  //显示地址值的led灯

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 显时模块
//////////////////////////////////////////////////////////////////////////////////


module display(clk,data_to_show,SEG,AN);
    input clk;
    input [31:0]data_to_show;
    output reg [7:0] SEG;
    output reg [7:0] AN;
    reg [3:0]num_show;
    reg [2:0]pos;
    reg clk_down = 0;
    reg [31:0] cnt = 0;
    parameter times = 40000;//分时为25hz
    initial begin
        pos=0;
        SEG=8'b00000000;
    end
    always@(posedge clk) begin// 分频
        if(cnt >= times)
            begin
                clk_down <= ~clk_down;
                cnt <= 0;
            end
        else begin
            cnt <= cnt + 1;
        end
    end
    always@(posedge clk_down)begin
             pos=pos+1;
    end
    always @(pos )   //显示
    begin
        case(pos)
            0:  
                begin 
                    AN[7:0] = 8'b11111110;
                    num_show=data_to_show[3:0];
                end
            1:  
                begin
                    AN[7:0] = 8'b11111101;
                    num_show=data_to_show[7:4];
                end
            2:  
                begin
                    AN[7:0] = 8'b11111011;
                    num_show=data_to_show[11:8];
                end
            3:  
                begin
                    AN[7:0] = 8'b11110111;
                    num_show=data_to_show[15:12];
                end
            4:  
                begin
                    AN[7:0] = 8'b11101111;
                    num_show=data_to_show[19:16];
                end
            5:
                begin
                    AN[7:0] = 8'b11011111;
                    num_show=data_to_show[23:20];                  
                end
            6:
                begin
                    AN[7:0] = 8'b10111111;
                    num_show=data_to_show[27:24];                  
                end
            7:
                begin
                    AN[7:0] = 8'b01111111;
                    num_show=data_to_show[31:28];                  
                end                
        endcase
    end

    always@(num_show[3:0])//译码
    begin
      case(num_show[3:0])
        4'b0000 :  SEG[7:0]=8'b11000000;
        4'b0001 :  SEG[7:0]=8'b11111001;
        4'b0010 :  SEG[7:0]=8'b10100100;
        4'b0011 :  SEG[7:0]=8'b10110000;
        4'b0100 :  SEG[7:0]=8'b10011001;
        4'b0101 :  SEG[7:0]=8'b10010010;
        4'b0110 :  SEG[7:0]=8'b10000010;
        4'b0111 :  SEG[7:0]=8'b11111000;
        4'b1000 :  SEG[7:0]=8'b10000000;
        4'b1001 :  SEG[7:0]=8'b10011000;
        4'b1010 :  SEG[7:0]=8'b10001000;//ABCDEF
        4'b1011 :  SEG[7:0]=8'b10000011;
        4'b1100 :  SEG[7:0]=8'b11000110;
        4'b1101 :  SEG[7:0]=8'b10100001;
        4'b1110 :  SEG[7:0]=8'b10000110;
        4'b1111 :  SEG[7:0]=8'b10001110;
        default:   SEG[7:0]=8'b11111111;
      endcase
    end
endmodule

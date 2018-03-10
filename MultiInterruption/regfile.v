module regfile(clk, WE, rW, rA, rB, W, A, B);

input clk, WE;//write enable control
input [4:0] rW, rA, rB;//register addr
input [31:0] W;//data to rW
output [31:0] A, B;//data from rA,rB

reg [31:0] register [31:0];//32 registers
integer i;

initial
	begin
	   for (i = 0; i < 32; i = i + 1)
		  register[i] = 0;//register
	end

assign A = register[rA];
assign B = register[rB];

always @(negedge clk)//为了解决结构冲突而使用下降沿触发
	begin
		if ((rW != 0) && (WE == 1))
			begin
				register[rW] <= W;
			end
	end
endmodule
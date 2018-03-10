`timescale 1ns / 1ps

//IF取指模块
module predict(
	input clk, rst,//写入时钟
	input [31:0] pc_now, pc_npc, pc_ex,
	input [2:0] hitpos_ex,
    input       hit_ex, preright_ex, branch_ex,  
	output  [31:0] pc_pre,
	output reg [ 2:0] hitpos,
	output reg hit
    );
	wire [2:0]target;
	parameter ENTRYNUM = 8;
	reg [31:0] 	pc 		[ENTRYNUM-1:0];
	reg	[31:0]	b_addr	[ENTRYNUM-1:0];
	reg [ 1:0]	pre		[ENTRYNUM-1:0];
	reg [ENTRYNUM-1:0]		valid 	;
	reg [ 2:0]	lru 	[ENTRYNUM-1:0];
	integer i =0;
	initial begin 	//初始?
		for(i = 0; i < ENTRYNUM; i = i + 1) begin
			pc[i] 		<= 0;
			b_addr[i]	<= 0;
			pre[i]		<= 2;
			valid[i]	<= 0;
			lru[i]		<= 0;
		end	
		hitpos 	<= 0;
		hit 	<= 0;
	end
	assign target = hit_ex ? hitpos_ex : available;
	/*BHT表更新??辑*/
	always @(posedge clk) begin
		if (rst) begin
			for(i = 0; i < ENTRYNUM; i = i + 1) begin
				pc[i] 		<= 0;
				b_addr[i]	<= 0;
				pre[i]		<= 2;
				valid[i]	<= 0;
				lru[i]		<= 0;
			end	
			//hitpos 	<= 0;
			//hit 	<= 0;
		end
		else  begin
			begin
				if(target!=0) begin lru[0] = (lru[0]==7) ? 7 : lru[0]+1;end
				if(target!=1) begin lru[1] = (lru[1]==7) ? 7 : lru[1]+1;end
				if(target!=2) begin lru[2] = (lru[2]==7) ? 7 : lru[2]+1;end
				if(target!=3) begin lru[3] = (lru[3]==7) ? 7 : lru[3]+1;end
				if(target!=4) begin lru[4] = (lru[4]==7) ? 7 : lru[4]+1;end
				if(target!=5) begin lru[5] = (lru[5]==7) ? 7 : lru[5]+1;end
				if(target!=6) begin lru[6] = (lru[6]==7) ? 7 : lru[6]+1;end
				if(target!=7) begin lru[7] = (lru[7]==7) ? 7 : lru[7]+1;end
			end
			if(hit_ex & preright_ex & branch_ex) begin//分支预测正确
				pc[target] 	  <= pc[target];
				b_addr[target] <= b_addr[target];
				pre[target] <= (pre[target]==2'b11)? 2'b11 :(pre[target]+1);
				valid[target]  <= 1;
				lru[target]	  <= 0;
			end
			else if(hit_ex & ~preright_ex & branch_ex) begin//分支预测错误
				pc[target] 	  <= pc[target];
				b_addr[target] <= pc_npc;
				pre[target] <= (pre[target]==2'b00)? 2'b00 :(pre[target]-1);
				valid[target]  <= 1;
				lru[target]	  <= 0;
			end
			else if(!hit_ex & branch_ex) begin//之前没有的分支指?
				pc[target] 	  <= pc_ex;
				b_addr[target] <= pc_npc;
				pre[target] <= 2;
				valid[target]  <= 1;
				lru[target]	  <= 0;
			end
		end
	end
	/*BHT表查找??辑*/
	wire [ENTRYNUM-1:0] hitreg;
	assign hitreg[0] = (pc_now == pc[0]) & valid[0];
	assign hitreg[1] = (pc_now == pc[1]) & valid[1];
	assign hitreg[2] = (pc_now == pc[2]) & valid[2];
	assign hitreg[3] = (pc_now == pc[3]) & valid[3];
	assign hitreg[4] = (pc_now == pc[4]) & valid[4];
	assign hitreg[5] = (pc_now == pc[5]) & valid[5];
	assign hitreg[6] = (pc_now == pc[6]) & valid[6];
	assign hitreg[7] = (pc_now == pc[7]) & valid[7];
	always @(hitreg or pc_now) begin
		case (hitreg) 
			8'b00000001: begin hit<=1; hitpos<=0; end
			8'b00000010: begin hit<=1; hitpos<=1; end
			8'b00000100: begin hit<=1; hitpos<=2; end
			8'b00001000: begin hit<=1; hitpos<=3; end
			8'b00010000: begin hit<=1; hitpos<=4; end
			8'b00100000: begin hit<=1; hitpos<=5; end
			8'b01000000: begin hit<=1; hitpos<=6; end
			8'b10000000: begin hit<=1; hitpos<=7; end
			default    : begin hit<=0; hitpos<=0; end
		endcase
	end
	wire [1:0] prebits;
	wire [31:0] jump_addr;
	wire jump;
	assign pc_pre = jump ? jump_addr : pc_now+1;
	assign jump = hit & ((prebits==2'b10) | (prebits==2'b11));
	assign prebits = pre[hitpos];
	assign jump_addr = b_addr[hitpos] ;
	wire [ENTRYNUM-1:0] avalreg;
	reg [2:0] available = 0;
	assign avalreg[0] = ~valid[0] | (lru[0]==7);
	assign avalreg[1] = ~valid[1] | (lru[1]==7);
	assign avalreg[2] = ~valid[2] | (lru[2]==7);
	assign avalreg[3] = ~valid[3] | (lru[3]==7);
	assign avalreg[4] = ~valid[4] | (lru[4]==7);
	assign avalreg[5] = ~valid[5] | (lru[5]==7);
	assign avalreg[6] = ~valid[6] | (lru[6]==7);
	assign avalreg[7] = ~valid[7] | (lru[7]==7);
	always @(avalreg) begin
		if(avalreg[0])      begin available <= 0 ;end
		else if(avalreg[1]) begin available <= 1 ;end
		else if(avalreg[2]) begin available <= 2 ;end
		else if(avalreg[3]) begin available <= 3 ;end
		else if(avalreg[4]) begin available <= 4 ;end
		else if(avalreg[5]) begin available <= 5 ;end
		else if(avalreg[6]) begin available <= 6 ;end
		else if(avalreg[7]) begin available <= 7 ;end
	end
endmodule

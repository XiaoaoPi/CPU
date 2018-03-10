`timescale 1ns / 1ps

//
//中断处理模块，逻辑上位于WB阶段；而写回操作在时钟下降沿进行，PC取值在时钟上升沿，因此当前指令会执行完；下条指令是npc
module interruption(	
	input 		clk,			//时钟信号
	input 		rst, 			//清零信号
	input 		eret,			//ext信号，中断服务程序完成 
	input 		break1, break2, break3,
    input		[31:0] npc, rt,	//中断发生时位于WB阶段指令的PC，用于存入EPC
    input       mfc0, mtc0,
    output		iw1, iw2, iw3, interrupt,
    output     	[31:0] entry, epc, 	//中断处理程序的PC，用于接下来的
    output reg ir1_sig, ir2_sig, ir3_sig
    );
    //中断信号产生之后，pc地址会跳转；epc的值可能会更新；
	parameter ENTRY1=32'h0cdc, ENTRY2=32'h0d0d, ENTRY3=32'h0d3e;//编写阶段先直接返回程序的开始位置，之后要修改成正确的IPC地址
	/*C0的寄存器组*/
	reg [31:0]	epc = 0;				//指令寄存器，用来存储返回地址, 00000
	reg			ie  = 0;				//中断使能端,0表示开中断,      00001
	reg [2:0]	ir  = 0;                 //                          00010
	reg			h = 0, l = 0;
    reg         epc_ok = 1;
    initial begin
        ir1_sig <= 0;
        ir2_sig <= 0;
        ir3_sig <= 0;
        epc <= 0;
        ie <= 0;
        ir <= 0;
        h <= 0;
        l <= 0;
        epc_ok <= 1;
    end
    wire [1:0]   now_ir;
    wire cutoff;
    assign cutoff = (now_ir > {h,l});
    assign now_ir = iw3? 2'b11 : (iw2? 2'b10:(iw1?2'b01:0));
	/*优先编码, 关中断*/
    assign interrupt = (ir[0] | ir[1] | ir[2]) & ~ie & cutoff;
	assign entry  = eret? epc :(ir[2] ? ENTRY3 : (ir[1] ? ENTRY2 : ENTRY1));		//决定下一个处理的中断
    //epc值的保存与更新
	always @(posedge clk) begin
		if(rst) begin
			epc <= 0;
		end
		else begin		
			if(interrupt & epc_ok) begin  epc <= npc;end
			else begin epc <= epc;end
		end
	end
    //中断信号
    always @(posedge clk) begin
        if (rst | eret) begin
            {h, l} <= 0;
            ie <= 0;
        end
        else if (interrupt) begin
            {h, l} <= ir[2] ? 2'b11  : (ir[1] ? 2'b10  : (ir[0]?2'b01:2'b00));
            ie <= 1;
        end
        else begin
            {h, l} <= {h, l};
            ie <= ie;
        end
    end
    //能够更新epc的信号
    always @(negedge eret or posedge cutoff) begin
        if((ir[0] | ir[1] | ir[2]) & ~cutoff) begin
            epc_ok <= 0;
        end
        else begin
            epc_ok <= 1;
        end
    end
	/*中断脉冲信号转为电平信号*/
    //reg ir1_sig = 0, ir2_sig = 0, ir3_sig = 0;
    assign iw1 = ir[0] | ir1_sig;
    assign iw2 = ir[1] | ir2_sig;
    assign iw3 = ir[2] | ir3_sig;
    always @(posedge clk) begin
    	if(rst) begin
    		ir[0] <= 0;
    		ir[1] <= 0;
    		ir[2] <= 0;
		end
        if(eret) begin
            ir[0] <= ir[0] ^ (~h &  l);
            ir[1] <= ir[1] ^ ( h & ~l);
            ir[2] <= ir[2] ^ ( h &  l);
        end
		else begin
    		ir[0] <= iw1 & ~( interrupt & (~h &  l));
    		ir[1] <= iw2 & ~( interrupt & ( h & ~l));
    		ir[2] <= iw3 & ~( interrupt & ( h &  l));
		end
    end
    always @(posedge break1 or posedge ir[0] or posedge rst) begin
        if(rst) begin
            ir1_sig <= 0;
        end
        else if (ir[0]) begin
            ir1_sig <= 0;
        end
        else begin
            ir1_sig <= 1;
        end
    end
    always @(posedge break2 or posedge ir[1] or posedge rst) begin
        if(rst) begin
            ir2_sig <= 0;
        end
        else if (ir[1]) begin
            ir2_sig <= 0;
        end
        else begin
            ir2_sig <= 1;
        end
    end
    always @(posedge break3 or posedge ir[2] or posedge rst) begin
        if(rst) begin
            ir3_sig <= 0;
        end
        else if (ir[2]) begin
            ir3_sig <= 0;
        end
        else begin
            ir3_sig <= 1;
        end
    end
endmodule

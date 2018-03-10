module IS(address, data_out);
	parameter AWIDTH = 10;
	parameter DWIDTH = 32;
	input	[AWIDTH-1:0] address;	//地址：输入
	output	[DWIDTH-1:0] data_out;	//数据：输出
    reg [DWIDTH-1:0] rom [2**AWIDTH-1:0];	//存储器
    initial begin
        $readmemh("D:/CPU/benchmark.dat", rom);
    end
    assign data_out = rom[address];
endmodule
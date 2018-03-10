module i7_test();
	reg clk,RST;
    reg break1, break2, break3;
	reg [2:0]pro_reset;
	reg [11:0]in_addr;
    reg choose;
	wire [7:0]SEG;
    wire [7:0]AN;
    wire halt, interrupt;
    wire IW1, IW2, IW3,  ir1_sig, ir2_sig, ir3_sig;
    integer i = 0;
    initial begin
    	clk <= 0;
    	RST <= 0;
    	pro_reset <= 0;
    	in_addr <= 12'b0;
        choose <= 1;
        break1 <= 0;
        break2 <= 0;
        break3 <= 0;
        //下为iverilog+gtkwave调试所需的语句
    	$monitor("At time %t, ocnt = %d", $time, clk);
    	$dumpfile("counter_test.vcd");
		$dumpvars(0, i7test);
/*        #1000 break1 <= 1;
        #1001 break1 <= 0;
        #10001 break1 <= 1;
        #10002 break1 <= 0;
        #20002 break1 <= 1;
        #20003 break1 <= 0;*/
        #1000 break1 <= 1;
        #1001 break1 <= 0;
        #1001 break2 <= 1;
        #1002 break2 <= 0;
        #1002 break3 <= 1;
        #1003 break3 <= 0;
        //#21000 break1 <= 1;
        //#21001 break1 <= 0;
        //#21001 break2 <= 1;
        //#21002 break2 <= 0;
        //#21002 break3 <= 1;
        //#21003 break3 <= 0;
    end
    always begin
        #1 clk = ~clk;
    end
	i7_6700k i7test(clk,RST,pro_reset,in_addr,choose,break1, break2, break3,
        SEG,AN,halt,interrupt ,IW1, IW2, IW3, ir1_sig, ir2_sig, ir3_sig);
endmodule
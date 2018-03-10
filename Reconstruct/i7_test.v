module i7_test();
	reg clk,RST;
	reg [2:0]pro_reset;
	reg [11:0]in_addr;
    reg choose;
	wire [15:0]leds;
	wire [7:0]SEG;
    wire [7:0]AN;
    integer i = 0;
    initial begin
    	clk = 0;
    	RST = 0;
    	pro_reset = 0;
    	in_addr = 12'b0;
        choose = 1;
        //下为iverilog+gtkwave调试所需的语句
    	$monitor("At time %t, ocnt = %d", $time, clk);
    	$dumpfile("counter_test.vcd");
		$dumpvars(0, i7test);
        //$finish;
    end
    always begin
        #1 clk = ~clk;
    end
	i7_6700k i7test(clk,RST,pro_reset,in_addr,choose,leds,SEG,AN);
endmodule
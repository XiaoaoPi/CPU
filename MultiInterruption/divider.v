module divider(clk_in,frq_switch, clk_out);//加了个choose

input clk_in;//system clock, reset button
input frq_switch;
output clk_out;

reg clk_out = 0;
reg [31:0] cnt = 0;//counter

always @(posedge clk_in) begin
			if(frq_switch) begin
				if (cnt>=30)//actually 2500000 times
					begin
						clk_out <= ~clk_out;
						cnt <= 0;
					end
				else
					begin
						cnt <= cnt+1;
					end
			end
			else begin
				if (cnt>=2500000)//actually 2500000 times
					begin
						clk_out <= ~clk_out;
						cnt <= 0;
					end
				else
					begin
						cnt <= cnt+1;
					end
			end
end
endmodule
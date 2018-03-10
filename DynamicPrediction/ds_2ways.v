module DS_2ways(str, clk, clr, mode, address, extra_address, data_in, dout, extra_dout);
    parameter AWIDTH = 12;  //地址字长，在这里可以直接修改,由于4k的限制，这里字节编址应该不超过12
    parameter DWIDTH = 32;  //数据字长
    input   str,    //信号：1时同步写入 
            clk,    //信号：时钟
            clr;    //信号：1时异步清空
    input   [1:0]   mode;   //信号：00时字访问，01时字节访问,10时半子访问
    input   [AWIDTH-1:0] address, extra_address;   //地址：输入
    input   [DWIDTH-1:0] data_in;   //数据：输入
    output   [DWIDTH-1:0] dout, extra_dout; //数据：输出
    wire  [DWIDTH-1:0] dout_sum, din_sum;
    reg [DWIDTH-1:0] ram [2**AWIDTH-1:0];   //存储器
    wire [7:0] dout_3, dout_2, dout_1, dout_0;
    wire word, half, byte, half_sel, byte_sel;
    wire [31:0] shift;
    integer i = 0;

    assign shift = sel_0 ? 32'b0 : (sel_1 ? 32'h8 : (sel_2?32'h10:32'h18));
    assign word = (~mode[1]) & (~mode[0]);
    assign half = (mode[1]) & (~mode[0]);
    assign byte = (~mode[1]) & (mode[0]);
    assign half_sel = address[1];
    assign byte_sel = address[0];
    assign sel_3 = word + (half & half_sel ) + (half_sel  & byte & byte_sel );
    assign sel_2 = word + (half & half_sel ) + (half_sel  & byte & ~byte_sel);
    assign sel_1 = word + (half & ~half_sel) + (~half_sel & byte & byte_sel );
    assign sel_0 = word + (half & ~half_sel) + (~half_sel & byte & ~byte_sel);
    assign din_sum = data_in << shift;
    assign dout_sum = (sel_3?(dout_3<<24):0) | (sel_2?(dout_2<<16):0) | (sel_1?(dout_1<<8):0) | (sel_0?dout_0:0);
    assign dout = dout_sum >> shift;
    DS_8b DS_3 (str, sel_3, clk, clr, address[11:2], extra_address[11:2],din_sum[31:24] , dout_3, extra_dout[31:24]);
    DS_8b DS_2 (str, sel_2, clk, clr, address[11:2], extra_address[11:2],din_sum[23:16] , dout_2, extra_dout[23:16]);
    DS_8b DS_1 (str, sel_1, clk, clr, address[11:2], extra_address[11:2],din_sum[15:8]  , dout_1, extra_dout[15:8]);
    DS_8b DS_0 (str, sel_0, clk, clr, address[11:2], extra_address[11:2],din_sum[7:0]   , dout_0, extra_dout[7:0]);
endmodule

module DS_8b(str, sel ,clk , clr, address, extra_address, data_in, dout_8b, extra_dout_8b);
    parameter AWIDTH = 10;  //地址字长，在这里可以直接修改,由于4k的限制，这里字地址应该不超过10
    parameter DWIDTH = 8;   //数据字长
    input   str,    //信号：1时同步写入
            sel, 
            clk,    //信号：时钟
            clr;    //信号：1时异步清空
    input   [AWIDTH-1:0] address, extra_address;   //地址：输入
    input   [DWIDTH-1:0] data_in;   //数据：输入
    output   [DWIDTH-1:0] dout_8b, extra_dout_8b; //数据：输出
    reg [DWIDTH-1:0] ram_8b [2**AWIDTH-1:0];    //存储器
    integer i = 0;
    initial begin
        for(i = 0; i < 2**AWIDTH; i = i + 1) begin
            ram_8b[i] = 0;
        end
    end
    always @(posedge clk) begin
        if (clk && str && sel && !clr) begin //仅仅在片选时有效
            ram_8b[address] <= data_in;
        end
        if (clr) begin             //clr覆盖其他的信号
            for(i = 0; i < 2**AWIDTH; i = i + 1) begin
                ram_8b[i] = 0;
             end
        end
    end
    assign  dout_8b = ram_8b[address];
    assign extra_dout_8b = ram_8b[extra_address];
endmodule
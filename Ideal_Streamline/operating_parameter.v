module operating_parameter(rst,clk,halt,j,jal,jr,blez,beq,bne,correct_b,
                            total, conditional, unconditional, conditional_success);
    input rst;
    input clk;
    input halt;
    input j;
    input jal;
    input jr;
    input bne;
    input blez;
    input beq;
    input correct_b;
    output reg [31:0]total = 0;
    output reg [31:0]conditional = 0;
    output reg [31:0]unconditional = 0;
    output reg [31:0]conditional_success = 0;
    reg flag = 0;

    always @(posedge clk)begin
        if(rst)begin 
        flag=0;
        total=0;
        conditional=0;
        unconditional=0;
        conditional_success=0;
    end
    else begin
    if(!halt)begin
        total=total+1; 
        flag=0;
    end
    else if(halt&&(flag == 0))begin
        total=total+1; 
        flag=1;
    end
        if(j|jal|jr)unconditional=unconditional+1;
        if(beq|bne|blez)conditional=conditional+1;
        if(correct_b)conditional_success=conditional_success+1;
    end

    end

    // always @(clk_in)if((dj==0&&j==1)||(djal==0&&jal==1)||(djr=0&&jr==1))unconditional=unconditional+1;
    // always @(clk_in)if((dbne==0&&bne==1)||(dblez==0&&blez==1)||(dbeq==0&&beq==1))conditional=conditional+1;
    // always @(clk_in)if(dcorrect_b ==0&&correct_b == 1)conditional_success=conditional_success+1;
    always @(posedge clk)begin

    end
endmodule

#CCMB序号为：1711，分别为SLLV, LUI, LB, BLEZ指令
#测试思路：
#1. 用LUI指令将0x0403放在寄存器$a0高位, 低位放0x0201, 可以看到数码管显示“04030201”. SW指令将这个32位的数存在内存中(起始地址0)
#2. 用四次LB指令将内存地址分别为0, 1 , 2, 3位置上的字节取出来, 分别在数码管上显示, 依次为"00000001", "00000002", "00000003", "00000004"
#3. 用BLEZ指令停10个时钟周期.
#4. 用SLLV将四个寄存器的内容移位, 然后相加, 得到结果在数码管上显示, "00004321"
addi $t0, $zero,0	#$s0清零
lui $at, 0x0403		#LUI指令
addi $t1, $at, 0x0201
addu   $a0,$0,$t1       # display $t1
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
sw $t1, 0($t0)		#将04030201存入内存0的位置
lb $s1,0($t0)		#LB指令，将内存0上的字节取出，即01
lb $s2,1($t0)		#LB指令，将内存1上的字节取出，即02
lb $s3,2($t0)		#LB指令，将内存2上的字节取出，即03
lb $s4,3($t0)		#LB指令，将内存3上的字节取出，即04

addu   $a0,$0,$s1       # display $s1
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
addu   $a0,$0,$s2       # display $s2
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
addu   $a0,$0,$s3       # display $s3
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
addu   $a0,$0,$s4       # display $s4
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
addi $t0, $t0, -10		#等待10个周期
branch:

addi $t0, $t0, 1
blez $t0, branch		#blez指令

addi $t0, $zero, 4
sllv $s2, $s2, $t0		#Sllv指令
or $s0, $s2, $s1 
addi $t0, $zero, 8
sllv $s3, $s3, $t0
or $s0, $s0, $s3 
addi $t0, $zero, 12
sllv $s4, $s4, $t0
or $s0, $s0, $s4 
addu   $a0,$0,$s0       # display $s0
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 

addi   $v0,$zero,10         # system call for exit
syscall                  # we are out of here.
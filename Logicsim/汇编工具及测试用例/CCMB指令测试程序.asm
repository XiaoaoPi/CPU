#CCMB���Ϊ��1711���ֱ�ΪSLLV, LUI, LB, BLEZָ��
#����˼·��
#1. ��LUIָ�0x0403���ڼĴ���$a0��λ, ��λ��0x0201, ���Կ����������ʾ��04030201��. SWָ����32λ���������ڴ���(��ʼ��ַ0)
#2. ���Ĵ�LBָ��ڴ��ַ�ֱ�Ϊ0, 1 , 2, 3λ���ϵ��ֽ�ȡ����, �ֱ������������ʾ, ����Ϊ"00000001", "00000002", "00000003", "00000004"
#3. ��BLEZָ��ͣ10��ʱ������.
#4. ��SLLV���ĸ��Ĵ�����������λ, Ȼ�����, �õ���������������ʾ, "00004321"
addi $t0, $zero,0	#$s0����
lui $at, 0x0403		#LUIָ��
addi $t1, $at, 0x0201
addu   $a0,$0,$t1       # display $t1
addi   $v0,$0,34         # system call for LED display 
syscall                 # display 
sw $t1, 0($t0)		#��04030201�����ڴ�0��λ��
lb $s1,0($t0)		#LBָ����ڴ�0�ϵ��ֽ�ȡ������01
lb $s2,1($t0)		#LBָ����ڴ�1�ϵ��ֽ�ȡ������02
lb $s3,2($t0)		#LBָ����ڴ�2�ϵ��ֽ�ȡ������03
lb $s4,3($t0)		#LBָ����ڴ�3�ϵ��ֽ�ȡ������04

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
addi $t0, $t0, -10		#�ȴ�10������
branch:

addi $t0, $t0, 1
blez $t0, branch		#blezָ��

addi $t0, $zero, 4
sllv $s2, $s2, $t0		#Sllvָ��
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
.text
addi $sp, $zero, 1000

muxadd:
  add    $a0,$a0,1       
  addi   $v0,$0,34         # display hex
  syscall                 # we are out of here. 
j muxadd

sw $s1, 0($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4
sw $v0, 0($sp)
addi $sp, $sp, -4
mfc0 $v0, $0
sw $v0, 0($sp)#���ݳ�ͻ
addi $sp, $sp, -4
#���ж�
mtc0 $zero, $00001

addi $s1,$zero,1     #             �������Ʋ��� 
sll $s1, $s1, 28   #�߼�����31λ $s1=0x10000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #$s1=0X10000000-->0XF0000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XF0000000-->0XFF000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XFF000000-->0XFFF00000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall 

#���ж�
addi $v0, $zero, 1
mtc0 $v0, $00001 #���ݳ�ͻ
addi $sp, $sp, 4
lw $v0, 0($sp)
mtc0 $v0, $0
addi $sp, $sp, 4
lw $v0, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
eret
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4
sw $v0, 0($sp)
addi $sp, $sp, -4
mfc0 $v0, $0
sw $v0, 0($sp)#���ݳ�ͻ
addi $sp, $sp, -4
#���ж�
mtc0 $zero, $00001

addi $s1,$zero,2     #             �������Ʋ��� 
sll $s1, $s1, 28   #�߼�����31λ $s1=0x10000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #$s1=0X10000000-->0XF0000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XF0000000-->0XFF000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XFF000000-->0XFFF00000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall 

#���ж�
addi $v0, $zero, 1
mtc0 $v0, $00001 #���ݳ�ͻ
addi $sp, $sp, 4
lw $v0, 0($sp)
mtc0 $v0, $0
addi $sp, $sp, 4
lw $v0, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
eret
sw $s1, 0($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4
sw $v0, 0($sp)
addi $sp, $sp, -4
mfc0 $v0, $0
sw $v0, 0($sp)#���ݳ�ͻ
addi $sp, $sp, -4
#���ж�
mtc0 $zero, $00001

addi $s1,$zero,3     #             �������Ʋ��� 
sll $s1, $s1, 28   #�߼�����31λ $s1=0x10000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #$s1=0X10000000-->0XF0000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XF0000000-->0XFF000000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    #0XFF000000-->0XFFF00000
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall                 # we are out of here.  
sra $s1, $s1, 4    
add    $a0,$0,$s1       #display $s1
addi   $v0,$0,34         # display hex
syscall 

#���ж�
addi $v0, $zero, 1
mtc0 $v0, $00001 #���ݳ�ͻ
addi $sp, $sp, 4
lw $v0, 0($sp)
mtc0 $v0, $0
addi $sp, $sp, 4
lw $v0, 0($sp)
addi $sp, $sp, 4
lw $a0, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
eret

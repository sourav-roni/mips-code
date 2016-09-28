.data
	prompt  : .asciiz "Feed the number : "
	pro   	: .asciiz "The number of ones : "

.text
.globl main
main:
	move $fp ,$sp
	subu $sp , $sp ,  4
	
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 0($sp)

	subu $sp, $sp ,4

	lw $a0, 4($sp)
	jal numone
	move $s0, $v0

	li $v0, 4
	la $a0, pro
	syscall
	
	li $v0, 1
	move $a0 , $s0
	syscall
	
	li $v0 , 10
	syscall

numone:
	move $fp, $sp
	move $t0, $a0
	subu $v0, $v0 ,$v0
	li $t2, 2
repeat: 
	blt $t0	, $t2, ending
	rem $t1, $t0, $t2
	beqz $t1, noadd
	add $v0 , $v0, 1
	divu $t0, $t0, $t2
	b repeat
noadd: 
	divu $t0, $t0, $t2
	b repeat
ending: 
	beqz $t0, endor
	add $v0 , $v0, 1
	jr $ra	
endor:
	jr $ra



















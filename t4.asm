.data
	prompt  : .asciiz "Enter the number n : "
	pro   	: .asciiz "Enter the number r : "
	t   	: .asciiz " "
	pn 	: .asciiz "\nThe value of n is "
	pr 	: .asciiz "\nThe value of r is "
	pnCr	: .asciiz "\nThe value of nCr is "

.text
.globl main
main:
	move $fp , $sp
	subu $sp , $sp , 8
	
	la $a0 , prompt
	li $v0 , 4
	syscall
	
	li $v0 , 5
	syscall
	sw $v0 , 4($sp)

	la $a0 , pro
	li $v0 , 4
	syscall
	
	li $v0 , 5
	syscall
	sw $v0 , 0($sp)

	lw $a0 , 4($sp)
	lw $a1 , 0($sp)
	jal fact
	subu $sp , $sp , 4
	sw $v0 , 0($sp)

	la $a0 , pn
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 8($sp)
	syscall

	la $a0 , pr
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 4($sp)
	syscall

	la $a0 , pnCr
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $a0 , 0($sp)
	syscall

	li $v0 , 10
	syscall

fact:
	beq $a0 , $a1 , factbase
	beqz $a1 , factbase
	
	subu $sp , $sp , 12
	sw $ra , 8($sp)
	sw $a0 , 4($sp)
	sw $a1 , 0($sp)
	
	subu $t0 , $a0 , 1
	move $t1 , $a1
	subu $t2 , $a1 , 1
	
	move $a0 , $t0
	move $a1 , $t1
	jal fact
	subu $sp , $sp , 4
	sw $v0 , 0($sp)

	lw $a0 , 8($sp)
	subu $a0 , $a0 , 1
	lw $a1 , 4($sp)
	subu $a1 , $a1 , 1
	jal fact 
	lw $t3 , 0($sp)
	addu $v0 , $v0 , $t3
	lw $ra , 12($sp)
	addu $sp , $sp , 16
	jr $ra	

factbase:
	li $v0 , 1
	jr $ra























	

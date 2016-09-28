.data
	prompt  : .asciiz "Enter the number : "
	pro   	: .asciiz "The Array is : "
	t   	: .asciiz " "
	min 	: .asciiz "\nThe mininmum element is "
	max 	: .asciiz "\nThe maximum element is "
	sum 	: .asciiz "\nThe sum of elements is "

.text
.globl main
main:
	move $fp, $sp
	subu $sp , $sp , 40
	
	move $t0 , $sp
	li $t1 , 10	

fillA: 
	la $a0 , prompt
	li $v0 , 4
	syscall
	
	li $v0 , 5
	syscall
	sw $v0 , 0($t0)
	addu  $t0 , $t0 , 4
	
	subu $t1 , $t1 , 1
	bnez $t1 , fillA

	move $t0 , $sp
	li $t1 , 10
	
	la $a0 , pro
	li $v0 , 4
	syscall
		
printA:
	lw $a0 , 0($t0)
	li $v0 , 1
	syscall

	la $a0 , t
	li $v0 , 4
	syscall
	
	addu  $t0 , $t0 , 4
	subu $t1 , $t1 , 1
	bnez $t1 , printA

	move $t0 , $sp
	#subu $sp , $sp , 4
	#sw $t0 , 0($sp)

	move $a0 , $t0
	jal funct
	move $t1 , $v0 
	move $t2 , $v1

	la $a0 , min
	li $v0 , 4
	syscall
	
	li $v0 , 1
	move $a0 , $t1
	syscall

	la $a0 , max
	li $v0 , 4
	syscall
	
	li $v0 , 1
	move $a0 , $t2
	syscall
	
	la $a0 , sum
	li $v0 , 4
	syscall
	
	li $v0 , 1
	lw $t1 , 0($sp)
	move $a0 , $t1
	syscall

	subu $sp , $sp , 44

	li $v0 , 10
	syscall

funct:
	move $fp , $sp
	subu $sp , $sp , 4
	move $s0 , $a0
	li $s1 , 9
	
	subu $s2 , $s2 , $s2
	
	lw $v0 , 0($s0)
	lw $v1 , 0($s0)
	addu $s0 , $s0 ,4
	
minloop:
	lw $s3 , 0($s0)
	blt $s3 , $v0 , lower
	addu $s0 , $s0 ,4
	subu $s1 , $s1 ,1
	bnez $s1 , minloop
	b endmin
lower:
	lw $v0 , 0($s0)
	add $s0 , $s0 ,4
	subu $s1 , $s1 ,1
	bnez $s1 , minloop
	b endmin

endmin: 
	move $s0 , $a0
	li $s1 , 9
	addu $s0 , $s0 ,4

maxloop:
	lw $s3 , 0($s0)
	bgt $s3 , $v1 , higher
	addu $s0 , $s0 ,4
	subu $s1 , $s1 ,1
	bnez $s1 , maxloop
	b endmax
higher:
	lw $v1 , 0($s0)
	add $s0 , $s0 ,4
	subu $s1 , $s1 ,1
	bnez $s1 , maxloop
	b endmax

endmax:
	move $s0, $a0
	li $s1, 10

sumloop:
	lw $s3 , 0($s0)
	add $s2 , $s2 , $s3
	add $s0 , $s0 ,4
	subu $s1 , $s1 ,1
	bnez $s1 , sumloop 

	subu $sp , $sp ,4
	sw $s2 , 0($sp)

	jr $ra



		








	

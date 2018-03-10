.data
	answer: .asciiz "No real root."
	space: .asciiz "¡@"
.text
main:
	#Get the three input
	li $v0,5
	syscall
	move $s0, $v0
	add $a0, $v0, $zero
	
	li $v0,5
	syscall
	move $s1, $v0
	add $a1, $v0, $zero
	
	li $v0,5
	syscall
	move $s2, $v0
	add $a2, $v0, $zero
	
	jal check
	
	#Get -b in $t4
	mul $t4, $s1, -1
	
	#get D in $t7
	mul $t5, $s1, $s1
	mul $t6, $s0, $s2
	sll $t6, $t6, 2
	sub $t7, $t5, $t6
	add $a0, $t7, $zero
	
	#jump to test D
	jal Test
	move $s3, $v0
	move $a3, $v1
	
	#calculate D^1/2
	addi $a0, $zero, 2
	bne $v0, 1, Sqrt
	move $a0, $v0
	move $a1, $t4
	move $a2, $t7
	
	#by $s3 to the output
	beq $s3, 1 , realroot
	beq $s3, 0, oneroot
	
	#end 
	li $v0, 10
	syscall

Sqrt:
	#Store the value
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	#Initialize
	add $t0, $zero, $a0
	add $t1, $zero, $zero
	add $t2, $zero, $a0
	div $t3, $a0, 2
	j Loop
Loop:
	div $t5, $t0, $t2
	add $t2, $t5, $t2
	div $t2, $t2, 2
	slt $t6, $t1, $t3
	add $t1, $t1, 1
	beq $t6, 1 ,Loop
	
	#round the value
	addi $t3, $zero, 1
	addi $t4, $zero, 2
	div $t3, $t3, $t4
	mul $t2, $t2, 10
	add $t2, $t2, $t3
	div $t2, $t2, 10
	move $v0, $t2
	
	
	#Load back
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
Test:
	#Store the value
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	add $t0, $a0, $zero 
	
	#D<0 to noanswer and end the program
	slt $t1, $t0, $zero 
	beq $t1, 1, noanswer
	sgt $t2, $t0, $zero
	move $v1, $t2
	move $v0, $t1
	
	#Load back
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
noanswer:
	#output "No real root"
	li $v0, 4
	la $a0, answer
	syscall
	
	#end 
	li $v0, 10
	syscall
	
realroot:
	#calculate
	add $t1, $a1, $a0
	mul $t2, $s0, 2
	div $t3, $t1, $t2
	mul $t4, $t3, -1
	
	#print two root
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 1
	move $a0, $t4
	syscall
	
	#end 
	li $v0, 10
	syscall

oneroot:
	#calculate
	add $t1, $a1, $a0
	mul $t2, $s0, 2
	div $t3, $t1, $t2
	
	#print
	li $v0, 1
	move $a0, $t3
	syscall

	
	#end 
	li $v0, 10
	syscall
check:
	slti $t1, $a0, 1000
	sgt $t2, $a0, -1000
	seq $t7, $t1, $t2
	slti $t1, $a1, 1000
	sgt $t2, $a1, -1000
	seq $t7, $t1, $t2
	slti $t1, $a2, 1000
	sgt $t2, $a2, -1000
	seq $t7, $t1, $t2
	bne $t7, 1, end
	
	jr $ra
end:
	li $v0, 10
	syscall
	
	
	
	
	
	
	
	
	
	
	
	

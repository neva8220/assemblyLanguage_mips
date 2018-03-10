.text
main:
	li $v0, 5
	syscall
	bge $v0, 50, end
	ble $v0, 0, end
	move $a0, $v0
	jal fib
	
	move $a0, $v0
	li $v0, 1
	syscall
end:	
	li $v0, 10
	syscall
fib:
	addi $sp, $sp, -12#move stack location
	sw $ra, 0($sp)#store word
	sw $a0, 4($sp)
	sw $s0, 8($sp)
	
	beq $a0, $zero, zero#when equal jump to zero
	li $t0, 1
	beq $a0, $t0, one
	
	addi $a0, $a0, -1
	jal fib
	
	move $s0, $v0#move v0 to s0 = add $s0,$v0,$zero
	lw $a0, 4($sp)
	
	addi $a0, $a0, -2
	jal fib
	
	add $v0, $v0, $s0
	lw $ra, 0($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
zero:
	lw $ra, 0($sp)#load word
	lw $s0, 8($sp)
	li $v0, 0#load return value
	addi $sp, $sp, 12#remove the sp
	jr $ra
	
one: 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	li $v0, 1
	addi $sp, $sp, 12
	jr $ra

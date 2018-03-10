.data
	first: .byte 'a'
	second: .byte'c'
	third: .byte'b'
	motion: .asciiz"move "
	direct: .asciiz" -> "
	line: .asciiz"\n"
.text
main:
	#Get interger	
	li $v0, 5
	syscall
	
	#check
	bge $v0, 10, exit
	
	move $s0, $v0 
	
	lb $a1, first
	lb $a2, second
	lb $a3, third
	
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	#Hanos
	jal hanoi
	
exit:	#end 
	li $v0, 10
	syscall
	
hanoi:
	#Store data
	addi $sp, $sp, -20
	sw $a3, 16($sp)
	sw $a2, 12($sp)
	sw $a1, 8($sp)
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	#base case
	li $t4, 1
	beq $a0, $zero, end
	
	#call1
	lw $a0, 4($sp)
	addi $a0, $a0, -1
	move $t1, $a2
	move $a2, $a3
	move $a3, $t1
	jal hanoi
	
	#Print
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	li $v0, 4
	la $a0, motion
	syscall
	
	li $v0, 11
	move $a0, $a1
	syscall
	
	li $v0, 4
	la $a0, direct
	syscall
	
	li $v0, 11
	move $a0, $a2
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	#call2
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $a0, $a0, -1
	move $t2, $a1
	move $a1, $a3
	move $a3, $t2
	jal hanoi
	
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	
	jr $ra
	
end:
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	
	jr $ra

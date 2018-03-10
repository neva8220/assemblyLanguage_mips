.data
	input: .space 50
	.align 2
	check: .space 10000
	.align 2
.text
main:
	#get input string
	li $v0, 8
	la $a0, input
	li $a1, 200
	syscall
	move $s0, $a0
	#get string length n
	jal len
	bge $v0, 50, end
	
	la $a1, check
	move $a2, $v0
	
	#All substrings of length 1 are palindromes
	addi $a3, $zero, 1 #maclength =1

	move $t0, $zero 
while1:
	mul $t1, $a2, $t0
	add $t1, $t1, $t0
	mul $t1, $t1, 4
	add $t2, $t1, $a1
	
	addi $t1, $zero, 1 #set [i][i]--true
	sw $t1, 0($t2)
	addi $t0, $t0, 1
	blt $t0, $a2, while1
	
	#check for sub-string of length 2.
	move $t1, $zero 
	addi $t2, $a2, -1
while2:	
	addi $t0, $t1, 1
	add $t3, $a0, $t1
	add $t4, $t0, $a0
	lb $t3, 0($t3)
	lb $t4, 0($t4)
	
	bne $t3, $t4, back #not equal jump to back
	mul $t5, $t1, $a2
	add $t5, $t5, $t0
	mul $t5, $t5, 4
	add $t5, $t5, $a1#get index of check array
	
	addi $t4, $zero, 1
	sw $t4, 0($t5) #store value=1
	addi $a3, $zero, 2
back:
	addi $t1, $t1, 1
	blt $t1, $t2, while2
	
	#Check for lengths greater than 2. k is length of substring
	addi $t1, $zero, 3 #Fix the starting index k
while31:
	move $t2, $zero #i
	sub $t3, $a2, $t1
	addi $t3, $t3, 1 #n-k+1
	#Get the ending index of substring fro starting index i and length k
while32:
	add $t4, $t2, $t1
	addi $t4, $t4, -1 #j
	
	#checking for sub-string from ith index to jth index iff str[i+1] to str[j-1] is apalindrome
	addi $t5, $t2, 1 #i+1
	addi $t6, $t4, -1 #j-1
	mul $t5, $t5, $a2
	add $t5, $t5, $t6
	mul $t5, $t5, 4
	add $t5, $a1, $t5 #get loc in check array
	lw $t5,0($t5) 
	addi $t7, $zero, 1
	sge $t5, $t5, $t7
	bne $t5, $t7, back3
	add $t6, $a0, $t2 #get char in input array
	lb $t6, 0($t6)
	add $t7, $a0, $t4 #get char in input array
	lb $t7, 0($t7)
	seq $t6, $t6, $t7
	bne $t5, $t6, back3 #if not equal go to back2
	
	mul $t5, $a2, $t2
	add $t5, $t5, $t4
	mul $t5, $t5, 4
	add $t5, $a1, $t5 #get loc in check array
	addi $t6, $zero, 1 
	sw  $t6, 0($t5) #store value 1
	ble $t1, $a3, back3 #less or equal go to back 3

	add $a3, $zero, $t1
back3:
	addi $t2, $t2, 1
	blt $t2, $t3, while32
back2:
	addi $t1, $t1, 1
	ble $t1, $a2, while31

	move $a0, $a3
	li $v0, 1
	syscall
	
end:
	li $v0, 10
	syscall
	
len:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t2, $zero, 0
while:
	lb $t0, 0($s0)
	beq $t0, $zero, exit
	
	addi $t2, $t2, 1
	addi $s0, $s0, 1
	j while
exit:
	addi $t2, $t2, -1
	move $v0, $t2
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	

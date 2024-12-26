# Hayden Ringgold
# Lab 17 Assembly Language

.text
main:
	# Prints prompt
	li $v0, 4
	la $a0, prompt
	syscall

	#Reads integer from user
	li $v0, 5
	syscall
	# saves entered integer to $s1
	move $s1,$v0
	
	# set $s0 to a
	lw $s0, a
	
	# Default for less than zero 
	bltz $s1, output
	# Default for greater than 3 
	bgt $s1, 3, output
	
	# load address of jump return
	la $s2, jumptable
	# compute word offset with mul
	mul $t0, $s1, 4
	# add this offset to the jumptable address
	add $t1, $s2, $t0
	# load a pointer into the jumptable
	lw $t2, 0($t1)
	# jump with jump register
	jr $t2
	case0:
		# a = b + c
		lw $s1, b
		lw $s2, c
		add $s0, $s1, $s2
		# jump to end of program
		j output
	case1:
		# a = d + e
		lw $s1, d
		lw $s2, e
		add $s0, $s1, $s2
		# jump to end of program
		j output
	case2:
		# a = d - e
		lw $s1, d
		lw $s2, e
		sub $s0, $s1, $s2
		# jump to end of program
		j output
	case3:
		# a = b - c
		lw $s1, b
		lw $s2, c
		sub $s0, $s1, $s2
		# jump to end of program
		j output
	output:
	# store $s0 back into memory
	sw $s0, a
	# prints answer label
	li $v0, 4
	la $a0, answer
	syscall
	#prints the value we got for a
	li $v0, 1
	lw $a0, a
	syscall
	
	# exit cleanly
	li $v0, 10
	syscall

.data
a: .word 0
b: .word 10
c: .word 5
d: .word 9
e: .word 7
prompt: .asciiz "Please enter a value for k: "
answer: .asciiz "The value of a is: "
jumptable: .word case0,case1,case2,case3
# Hayden Ringgold
# Assignment 7 Assembly Language

.text
main:
	startMainLoop:
	# Print the first float prompt label
	la $a0, firstFloatMsg
	jal PrintLabel
	# Prompt for the first float
	jal PromptFloat
	# Move answer to $f12
	mov.s $f12, $f0
	
	# Print the operator prompt label
	la $a0, opMsg
	jal PrintLabel
	# Prompt for the operator
	jal PromptByte
	# Saves the user entered operator into $s0
	move $s0, $v0
	
	# Print the second float prompt label
	la $a0, secondFloatMsg
	jal PrintLabel
	# Prompt for the second float
	jal PromptFloat
	mov.s $f13, $f0
	
	# Check if quitOp was entered
	# if($s0 == quitOp) branch to end
	lb $t0, QuitOp
	beq $s0, $t0, endMainLoop
	
	## if else statements start here
	addTime:
		# if add, continue, if else jump to next branch
		lb $t0, AddOp
		seq $t1, $s0, $t0
		# if $s0 = AddOp, $t1 = 1
		beqz $t1, subTime
		# call the addCalc procedure
		jal addCalc
		# move the result to a float register
		mov.s $f18, $f0
		# Print the result label
		la $a0, resultMsg
		jal PrintLabel
		# Print the floating point result
		mov.s $f12, $f18
		jal PrintFloat
		# jump back to start of the loop
		j startMainLoop
	subTime:
		# if sub, continue, if else jump to next branch
		lb $t0, SubOp
		seq $t1, $s0, $t0
		# if $s0 = SubOp, $t1 = 1
		beqz $t1, mulTime
		# call the subCalc procedure
		jal subCalc
		# move the result to a float register
		mov.s $f18, $f0
		# Print the result label
		la $a0, resultMsg
		jal PrintLabel
		# Print the floating point result
		mov.s $f12, $f18
		jal PrintFloat
		# jump back to start of the loop
		j startMainLoop
	mulTime:
		# if add, continue, if else jump to next branch
		lb $t0, MulOp
		seq $t1, $s0, $t0
		# if $s0 = MulOp, $t1 = 1
		beqz $t1, divTime
		# call the mulCalc procedure
		jal mulCalc
		# move the result to a float register
		mov.s $f18, $f0
		# Print the result label
		la $a0, resultMsg
		jal PrintLabel
		# Print the floating point result
		mov.s $f12, $f18
		jal PrintFloat
		# jump back to start of the loop
		j startMainLoop
	divTime:
		# if add, continue, if else jump to next branch
		lb $t0, DivOp
		seq $t1, $s0, $t0
		# if $s0 = DivOp, $t1 = 1
		beqz $t1, exceptionTime
		# check to see if user is trying to divide by 0
		lwc1 $f1, zero
		c.eq.s $f13, $f1
		bc1f divTime2		
		la $a0, zeroMsg
		li $v0, 4
		syscall
		j startMainLoop
		divTime2:
		# call the divCalc procedure
		jal divCalc
		# move the result to a float register
		mov.s $f18, $f0
		# Print the result label
		la $a0, resultMsg
		jal PrintLabel
		# Print the floating point result
		mov.s $f12, $f18
		jal PrintFloat
		# jump back to start of the loop
		j startMainLoop
	exceptionTime:
		# Print the error message
		la $a0, errorMsg
		jal PrintLabel
		# jump back to the beginning of the loop
		j startMainLoop
	endMainLoop:
	j Exit

####
# addCalc
# Parameters: $f12 - first float enterd by user, $f13 - second float entered by user
# Returns: $f0 - user entered floats added together
####
addCalc:
add.s $f0, $f12, $f13
jr $ra

####
# subCalc
# Parameters: $f12 - first float enterd by user, $f13 - second float entered by user
# Returns: $f0 - second user entered float subtracted from the first
####
subCalc:
sub.s $f0, $f12, $f13
jr $ra

####
# mulCalc
# Parameters: $f12 - first float enterd by user, $f13 - second float entered by user
# Returns: $f0 - user entered floats multiplied together
####
mulCalc:
mul.s $f0, $f12, $f13
jr $ra

####
# divCalc
# Parameters: $f12 - first float enterd by user, $f13 - second float entered by user
# Returns: $f0 - first user entered float divided by the second
####
divCalc:
div.s $f0, $f12, $f13
jr $ra

####
# PrintLabel
# Parameters: $a0 - string to print
# Returns: nothing
####
PrintLabel:
li $v0, 4
syscall
jr $ra

####
# PromptFloat
# Parameters: none
# Returns: $f0 - float entered by user
####
PromptFloat:
li $v0, 6
syscall
jr $ra

####
# PromptByte
# Parameters: none
# Returns: $v0 - byte entered by the user
####
PromptByte:
li $v0, 12
syscall
jr $ra

####
# PrintFloat
# Parameters: $f12 - float to print
# Returns: none
####
PrintFloat:
li $v0, 2
syscall
jr $ra

Exit:
li $v0, 10
syscall

.data
AddOp: .byte '+'
SubOp: .byte '-'
MulOp: .byte '*'
DivOp: .byte '/'
ExpOp: .byte '^'
QuitOp: .byte '&'
firstFloatMsg: .asciiz "\nEnter First Float: "
opMsg: .asciiz "Enter Operator: "
secondFloatMsg: .asciiz "\nEnter Second Float: "
errorMsg: .asciiz "Invalid operator was entered.\n"
resultMsg: .asciiz "Result - "
zeroMsg: .asciiz "Error. Divide by 0"
zero: .float 0.0
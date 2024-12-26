# Hayden Ringgold
# Assignment 6 Assembly Language

.text
main:
	# print the lower case prompt
	la $a0, lcPrompt
	jal PrintLabel
	# prompt the user for the string 
	la $a0, string1
	la $a1, string1Size
	jal PromptString
	# load the memory address of the user entered
	la $a0, string1
	# load the memory address of where to copy the string
	la $a1, lcString
	# call tolow
	jal tolow
	# move the number of translations into $t0
	move $t0, $v0
	# print the converted string label
	la $a0, convString
	jal PrintLabel
	# print the all lowercase string
	la $a0, lcString
	jal PrintLabel
	# print the number of translations label
	la $a0, numTranslations
	jal PrintLabel
	# print the number of lowercase translations
	move $a0, $t0
	jal PrintInt
	# print the upper case prompt
	la $a0, ucPrompt
	jal PrintLabel
	# prompt the user for the string
	la $a0, string2
	la $a1, string2Size
	jal PromptString
	# call toup
	la $a0, string2
	la $a1, ucString
	jal toup
	# move the number of translations to $t0
	move $t0, $v0
	# print the converted string label
	la $a0, convString
	jal PrintLabel
	# print the all upper case string
	la $a0, ucString
	jal PrintLabel
	# print the number of translations label
	la $a0, numTranslations
	jal PrintLabel
	# print the number of translations integer
	move $a0, $t0
	jal PrintInt
	# load the strings to concatenate
	la $a0, string1
	la $a1, string2
	la $a2, concString
	# move the string length to $t0
	move $t0, $v0
	# run strcat
	jal strcat
	move $t0, $v0
	# print the concatenated string label
	la $a0, concStringAnswer
	jal PrintLabel
	# print the concatenated string
	la $a0, concString
	jal PrintLabel
	# print the string size label
	la $a0, concStringSize
	jal PrintLabel
	# print the string size
	move $a0, $t0
	jal PrintInt

	j Exit

####
# toup - converts a given string to an all upper case string
# parameters: $a0 - memory address of the string, $a1 - memory address of the string to copy the converted string into
# returns: $v0 - number of translations made
####
toup:
	# stores address of user enterd string in $t0
	move $t0, $a0
	# stores address of the string to copy into in $t1
	move $t1, $a1
	# set num translations
	li $t5, 0
	startUpLoop:
	## XOR is to convert from lowercase to uppercase
	# load the byte of the char array we are looking at into a temp register
	lb $t2, 0($t0)
	# check if char is the null terminator
	# if so, branch to end loop
	beq $t2, 0x0, endUpLoop
	# need to check if character we are looking at is in the range of a lowercase character
	# if char >= hex 61 && char <= 7A set $t3 to 1
	sge $t3, $t2, 0x61
	sle $t4, $t2, 0x7A
	## if I'm right the only way they are equal is if the byte is in between the hex range 0x61 and 0x7A
	beq $t3, $t4, upConv
	# if not, store the char into the answer string
	sb $t2, 0($t1)
	# increment count (where we are in the array)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	# jump back to top of the loop
	j startUpLoop
	upConv:
	# if so XOR the char
	xori $t2, $t2, 0x20
	# store the new char into the answer string
	sb $t2, 0($t1)
	# increment num translations
	addi $t5, $t5, 1
	# increment count (where we are in the array)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	# jump back to top of the loop
	j startUpLoop
	endUpLoop:
	# stores the byte to signify the end of the string
	sb $t2,0($t1)
	# move num translations into $v0
	move $v0, $t5
	jr $ra

####
# tolow - converts a given string to an all lowercase string
# parameters: $a0 - memory address of the string, $a1 - memory address of the string to copy the converted string into
# returns: $v0 - number of translations made
####
tolow:
	# stores address of user enterd string in $t0
	move $t0, $a0
	# stores address of the string to copy into in $t1
	move $t1, $a1
	# set num translations
	li $t5, 0
	startLowLoop:
	##  OR is to convert from uppercase to lowercase
	# load the byte of the char array we are looking at into a temp register
	lb $t2, 0($t0)
	# check if char is the null terminator
	# if so, branch to end loop
	beq $t2, 0x0, endLowLoop
	# need to check if character we are looking at is in the range of an uppercase character
	# if char >= hex 41 && char <= 5A set $t3 to 1
	sge $t3, $t2, 0x41
	sle $t4, $t2, 0x5A
	## if I'm right the only way they are equal is if the byte is in between the hex range 0x41 and 0x5A
	beq $t3, $t4, lowConv
	# if not, store the char into the answer string
	sb $t2, 0($t1)
	# increment count (where we are in the array)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	# jump back to top of the loop
	j startLowLoop
	lowConv:
	# if so OR the char
	ori $t2, $t2, 0x20
	# store the new char into the answer string
	sb $t2, 0($t1)
	# increment num translations
	addi $t5, $t5, 1
	# increment count (where we are in the array)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	# jump back to top of the loop
	j startLowLoop
	endLowLoop:
	# stores the byte to signify the end of the string
	sb $t2, 0($t1)
	# move num translations into $v0
	move $v0, $t5
	jr $ra
####
# concatenates two strings together
# parameters: $a0 - first string in the concatenation, $a1 - second string in the concatenation, $a2 - string to copy into
# returns: $v0 - the total length of the concatenated string
####
strcat:
	# set the string length
	li $t0, 0
	# move the memory address of the first string into $t1
	move $t1, $a0
	# move the memory address of the second string into $t2
	move $t2, $a1
	# move the memory address of the string to copy into into $t3
	move $t3, $a2 
	# loop through the first string
	firstLoop:
	# load the byte of the char array we are looking at into a temp register
	lb $t4, 0($t1)
	# check if the char we are looking at is null
	# if so, jump to second loop
	beq $t4, 0x0, secondLoop
	# check if the char we are looking at is a new line
	beq $t4, 0xA, secondLoop
	# if not, copy char into the concatenated string
	sb $t4, 0($t3)
	# increment string length
	addi $t0, $t0, 1
	# increment the count (where we are in the arrays)
	addi $t1, $t1, 1
	addi $t3, $t3, 1
	# jump back to the first loop
	j firstLoop
	# loop through the second string
	secondLoop:
	# load the byte of the char array we are looking at into a temp register
	lb $t4, 0($t2)
	# check if the char we are looking at is null
	# if so, jump to the end of the procedure
	beq $t4, 0x0, endProc
	# check if char we are looking at is new line
	beq $t4, 0xA, endProc
	# if not, copy char into the concatenated string
	sb $t4, 0($t3)
	# increment string length
	addi $t0, $t0, 1
	# increment the count (where we are in the arrays)
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	# jump back to the second loop
	j secondLoop
	endProc:
	# store the final byte into the concatenated string
	sb $t4, 0($t3)
	# move the length of the concatenated string into $v0
	move $v0, $t0
	jr $ra

####
# PrintLabel
# Parameters: $a0 - label to print
# Returns: nothing
####
PrintLabel:
	li $v0, 4
	syscall
	jr $ra

####
# PromptString
# Parameters: $a0 - label to store string in
# Returns: nothing
####
PromptString:
	li $v0, 8
	syscall
	jr $ra
####
# PrintInt
# Parameters: $a0 - word label
# Returns: nothing
####
PrintInt:
	li $v0, 1
	syscall
	jr $ra

Exit:
	li $v0, 10
	syscall


.data
lcPrompt: .asciiz "Enter a string to convert to lowercase: "
string1Size: .word 100
string1: .space 100
lcString: .space 100
string2Size: .word 100
string2: .space 100
ucString: .space 100
concString: .space 200
ucPrompt: .asciiz "\nEnter a string to convert to uppercase: "
convString: .asciiz "The converted sring is: "
numTranslations: .asciiz "The number of translations is: "
concStringAnswer: .asciiz "\nThe two strings concatenated are: "
concStringSize: .asciiz "The size of the concatenated string is: "

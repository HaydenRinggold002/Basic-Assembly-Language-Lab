# Hayden Ringgold
# Assignment 5 Assembly Language

.text
main:
# print the min  label
la $a0, minLabel
jal PrintLabel
# run the min procedure
la $a0, A
lw $a1, size
jal Min
# save the value from min into $t0
move $t0, $v0
# print the integer we get
move $a0, $t0
jal PrintInt
# print the max label
la $a0, maxLabel
jal PrintLabel
#run the max procedure
la $a0, A
lw $a1, size
jal Max
# save the value from max into $t0
move $t0, $v0
# print the integer we get
move $a0, $t0
jal PrintInt
# print the sum label
la $a0, sumLabel
jal PrintLabel
#run the sum procedure
la $a0, A
lw $a1, size
jal Sum
# save the value from sum into $t0
move $t0, $v0
# print the integer we get
move $a0, $t0
jal PrintInt
# print the avg label
la $a0, avgLabel
jal PrintLabel
#run the avg procedure
move $a0, $t0
lw $a1, size
jal Avg
# save the value from avg into $t0
move $t0, $v0
# print the integer we get
move $a0, $t0
jal PrintInt
# run the reverseArray procedure
la $a0, A
la $a1, B
lw $a2, size
jal reverseArray
# print reverse label
la $a0, reverseLabel
jal PrintLabel
# print array
# index
li $t0, 0
#size of array
lw $t1, size
# address of array to print
la $s3, B
start_loop:
	bge $t0,$t1,exit_loop
	
	li $t2, 0
	mul $t2, $t0, 4
	add $t2,$t2,$s0
	
	lw $s4,($t2)
	
	la $a0, element
	jal PrintLabel
	move $a0, $s4
	jal PrintInt
	addi $t0, $t0, 1
	j start_loop
exit_loop:
	jal Exit

####
# Min
# Paramters: $a0 - memory location of array, $a1 - size of array
# Returns: $v0 - minimum value in the array
####
Min:
# index of array
li $t0, 0
# load the size of the array into $t1
move $t1, $a1
# load the address location of the array into $s0
move $s0, $a0
# set $t3 to largestInt
lw $t3, largestInt

startMinLoop:
# if the index is larger than the size, exit the loop
bge $t0,$t1,endMinLoop
# initialize array position to 0
li $t2, 0
# calculate how far to go into array
mul $t2, $t0, 4
# set the memory location of element in the array
add $t2,$t2,$s0
# load the value of A[index] into $s1
lw $s1, ($t2)
# increase index by one
addi $t0, $t0, 1
# if $s1 is greater than $t3, branch to the start of the loop
bgt $s1,$t3,startMinLoop
# else set $t3 to $s1 and jump back to the start of the loop
move $t3,$s1
j startMinLoop
endMinLoop:
# put the proper value in the return register
move $v0, $t3
jr $ra

####
# Max
# Paramters: $a0 - memory location of array, $a1 - size of array
# Returns: $v0 - maximum value in the array
####
Max:
# index of array
li $t0, 0
# load the size of the array into $t1
move $t1, $a1
# load the address location of the array into $s0
move $s0, $a0
# set $t3 to 0
li $t3, 0
startMaxLoop:
# if the index is larger than the size, exit the loop
bge $t0,$t1,endMaxLoop
# initialize array position to 0
li $t2, 0
# calculate how far to go into array
mul $t2, $t0, 4
# set the memory location of element in the array
add $t2,$t2,$s0
# load the value of A[index] into $s1
lw $s1, ($t2)
# increase index by one
addi $t0, $t0, 1
# if $s1 is less than $t3, branch to the start of the loop
blt $s1,$t3,startMaxLoop
# else set $t3 to $s1 and jump back to the start of the loop
move $t3,$s1
j startMaxLoop
endMaxLoop:
# put the proper value in the return register
move $v0, $t3
jr $ra

####
# Sum
# Parameters: $a0 - memory location of array, $a1 - size of array
# Returns: $v0 - sum of all values in array
####
Sum:
# index of array
li $t0, 0
# load the size of the array into $t1
move $t1, $a1
# load the address location of the array into $s0
move $s0, $a0
# set $t3 to 0
li $t3, 0
startSumLoop:
# if the index is larger than the size, exit the loop
bge $t0,$t1,endSumLoop
# initialize array position to 0
li $t2, 0
# calculate how far to go into array
mul $t2, $t0, 4
# set the memory location of element in the array
add $t2,$t2,$s0
# load the value of A[index] into $s1
lw $s1, ($t2)
add $t3, $t3, $s1
# increase index by one
addi $t0, $t0, 1
j startSumLoop
endSumLoop:
# move proper value to $v0
move $v0, $t3
jr $ra
####
# Avg
# parameters: $a0 - sum as calulcated by sum procedure, $a1 - size of A
# Returns $v0 - average of values in A
####
Avg:
# average = sum/size
div $t0, $a0, $a1
# put value in proper return register
move $v0, $t0
jr $ra

####
# reverseArray
# parameters: $a0 - memory location of array 1, $a1 - memory location of array 2, $a2 - size of arrays
# returns: none
####
reverseArray:
# loads 0 into $t0
li $t0, 0
# load the size of the arrays into $t1
move $t1, $a2
# load the address of array 1 into $s0
move $s0, $a0
# load the address of array 2 into $s1
move $s1, $a1
startReverseLoop:
# if index is size is less than or equal to 0 branch to end of loop
ble $t1, 0, endReverseLoop
# initialize array position to 0
li $t2, 0
# calculate how far to go into array1 (the furthest value we haven't yet added)
mul $t2, $t1, 4
# set the memory location of element in array1
add $t2,$t2,$s0
# load the value of A[index] into $s2
lw $s2, ($t2)
# calculate how far to go into array2 (4* the number of loop runs)
mul $t2, $t0, 4
# set the memory location element in array2
add $s2, $s2, $t2
# store the value from array 1 into array 2
sw $s2, ($s1)
# increment $t0 and decrement the size
addi $t0, $t0, 1
subi $t1, $t1, 1
endReverseLoop:
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
A: .word 11, 250, 20, 70, 60, 140,150, 80, 90,100, 1, 30, 40, 120, 130, 5
B: .space 64
size: .word 16 # length of array A
min: .word 0
max: .word 0
sum: .word 0
average: .word 0
largestInt: .word 2147483647 # You may want to use this for min procedure
minLabel: .asciiz "The minimum is "
maxLabel: .asciiz "\nThe maximum is "
sumLabel: .asciiz "\nThe sum is "
avgLabel: .asciiz "\nThe average is "
reverseLabel: .asciiz "\nThe array reversed is: "
element: .asciiz "\nCurrent value:"

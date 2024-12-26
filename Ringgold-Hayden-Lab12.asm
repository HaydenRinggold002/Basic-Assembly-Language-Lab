# Hayden Ringgold
# Assembly Language Lab 12

.text
main:
# load integer prompt labe
la $a0, prompt
jal PrintLabel
# prompt the integer
jal PromptInt
# move the value entered into $a0
move $a0, $v0
# set $v0 to 0 as having it as any other number messes with the output of add_r
li $v0, 0
jal add_r
# set output to $t0
move $t0, $v0
# print return label
la $a0,returnValue
jal PrintLabel
# move result of add_r to $a0 and print
move $a0, $t0
jal PrintInt
j Exit

####
# add_r
# Parameters: $a0 - number entered by user
# Returns: n + add_r(n-1)
####
add_r:
# pushes $ra and $a0 on to the stack
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $sp, $sp, -4
sw $a0, 0($sp)
# branch to recur if not equal to 0
bnez $a0, recur
#if equal to 0, pop $a0 and $ra off the stack
lw $a0,0($sp)
addi $sp,$sp,4
lw $ra,0($sp)
addi $sp,$sp,4
# final return
jr $ra

recur:
# else $a0 = $a0 -1
addi $a0, $a0, -1
jal add_r

# pop $a0 and $ra off the stack
lw $a0,0($sp)
addi $sp,$sp,4
lw $ra,0($sp)
addi $sp,$sp,4
# adding $a0 with $a0-1
add $v0, $a0, $v0
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
####
# PromptInt
# Parameters: none
# Returns: $v0 - number entered by the user
####
PromptInt:
li $v0, 5
syscall
jr $ra

Exit:
li $v0, 10
syscall

.data
prompt: .asciiz "Please enter an integer: "
returnValue: .asciiz "Returned value = "

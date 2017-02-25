#Sreeramamurthy Tripuramallu 903057502
.data
strA: .asciiz "Original Array:\n"
strB: .asciiz "Second Array:\n"
newline: .asciiz "\n"
space : .asciiz " "

# This is the start of the original array.
Original: .word 200, 270, 250, 100
.word 205, 230, 105, 235
.word 190, 95, 90, 205
.word 80, 205, 110, 215
# The next statement allocates room for the results in 4*4 = 16 bytes.
#
Max: .space 16
.align 2
.globl main
.text

main:
        subu $sp, $sp, 64       # allocate new frame
        sw $fp, 60($sp)         # push frame pointer
        addi $fp, $sp, -64      # update frame pointer

        # display "Original Array: "
        la $a0, strA
        li $v0, 4
        syscall

        addi $a1, $zero, 4 # size of the array
        # prepare aurguments for printing procedure
        la $a0 Original # start of array to print
        move $a1, $t0     # size of array
        jal print_array   # call printing procedure

        # reset stack pointer after procedure call
        lw $fp, 60($sp)
        addu $sp, $sp, 64

        # display "Second Array: "
        la $a0, strB
        li $v0, 4
        syscall


        la $a1 Original    # load base memory address of original array
        move $t4, $a1
        la $a2 Max         # load base memorty address of second array

        add $t2, $zero, $zero # initalize counter
        lw $t3, 0($t4)        # load first number in first column

        # loop to iterates through first column
f_loop: slti $t6, $t2, 3 # check if counter is less than 3
        beq $t6, $zero, updt1 # if not, then move on
        # load next number in the column
        addi $t4, $t4, 16
        lw $t5, 0($t4)
        # check if the number is greater than value in $t3
        # if so, then replace the value in $t3
        # then increment counter and repeat loop
        slt $t6, $t3, $t5
        beq $t6, $zero, incre1
        add $t3, $t5, $zero
incre1: addi $t2, $t2, 1
        j f_loop

        # once the max of the column is found, store that into the second array
updt1:  sw $t3, 0($a2)
        addi $a2, $a2, 4 # update the base address of the second array

        addi $t4, $a1, 4 # update the base address of the original array

        add $t2, $zero $zero # reset the counter
        lw $t3, 0($t4) # load first number in second column of array

        # loop that iterates through second column
s_loop: slti $t6, $t2, 3 # check if counter is less than 3
        beq $t6, $zero, updt2 # if not, then move on
        # load next number in column
        addi $t4, $t4, 16
        # check if the number is greater than value in $t3
        # if so, then replace the value in $t3
        # then increment counter and repeat loop
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre2
        add $t3, $t5, $zero
incre2: addi $t2, $t2, 1
        j s_loop

        # once the max of the column is found, store into the second array
updt2:  sw $t3, 0($a2)
        addi $a2, $a2, 4 # update the base address of the second array

        addi $t4, $a1, 8 # update the base address of the original array

        add $t2, $zero, $zero # reset the counter
        lw $t3, 0($t4)  # load first number in third column of array

        # loop that iterates through third column
t_loop: slti $t6, $t2, 3 # check if counter is less than 3
        beq $t6, $zero, updt3# if not, then move on
        # load the next number in column
        addi $t4, $t4, 16
        # check if the number is greater than value in $t3
        # if so, then replace the value in $t3
        # then increment counter and repeat loop
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre3
        add $t3, $t5, $zero
incre3: addi $t2, $t2, 1
        j t_loop

        # once the max of the column is found, store into the second array
updt3:  sw $t3, 0($a2)
        addi $a2, $a2, 4 # update the base address of the second array

        addi $t4, $a1, 12 # update the base address of the orginal array

        add $t2, $zero, $zero # reset the counter
        lw $t3, 0($t4) # load the first number in the fourth column

        # loop that iterates through the fourth column
fo_loop: slti $t6, $t2, 3 # check if counter is less than 3
        beq $t6, $zero, updt4 # if not, then move on
        # load the next number in column
        addi $t4, $t4, 16
        # check if the number is greater than value in $t3
        # if so, then replace the value in $t3
        # then increment counter and repeat loop
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre4
        add $t3, $t5, $zero
incre4: addi $t2, $t2, 1
        j fo_loop

        # once the max of the column is found, store in the second array
updt4:  sw $t3, 0($a2)


        la $a2 Max      # load the base address of the second array
        addi $t0, $zero, 0 # initalize counter
        # loop that print the numbers in second array
loop:   slti $t1, $t0, 4 # check if the counter is less than 4
        beq $t1, $zero, exit # if not, then move on

        # load number in array, then print it
        lw $a0, 0($a2)
        li $v0, 1
        syscall

        # load space, and print a space
        la $a0, space
        li $v0, 4
        syscall


        addi $t0, $t0, 1 # increment counter
        addi $a2, $a2, 4 # increment base address of second array
        j loop

        # terminate program
exit:   li $v0, 10
        syscall



print_array:
        move $t4, $a0   # save the starting address of the array
        add $t3, $zero, $zero # initalize counter for outer loop

out:    add $t1, $zero, $zero # initalize counter for inner loop

in_l:   slti $t2, $t1, 4 # check if counter is less than 4
        beq  $t2, $zero, n_L # if not, then jump to outer loop

        # load number and print it
        lw $a0, 0($t4)
        li $v0, 1
        syscall

        # load sapce and print space
        la $a0, space
        li $v0, 4
        syscall

        addi $t4, $t4, 4 # increment base address of array to nxt number
        addi $t1, $t1, 1 # increment inner counter
        j in_l           # repeat loop


n_L:    addi $t3, $t3, 1 # increment outer loop counter

        # load new line and print it
        la $a0, newline
        li $v0, 4
        syscall

        # check if the counter is less than for
        # if so, then repeat loop
        # if not, then return to caller
        slti $t2, $t3, 4
        bne $t2, $zero, out

        jr $ra # return to caller













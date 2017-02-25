.data
strA: .asciiz "Original Array:\n"
strB: .asciiz "Second Array:\n"
newline: .asciiz "\n"
space : .asciiz " "

# This is the start of the original array.
Original: .word 200, 95, 105, 240
.word 80, 230, 250, 235
.word 190, 270, 90, 205
.word 205, 205, 110, 215
# The next statement allocates room for the results in 4*4 = 16 bytes.
#
Max: .space 16
.align 2
.globl main
.text

main:

        la $a1 Original
        move $t4, $a1
        la $a2 Max

        add $t2, $zero, $zero
        lw $t3, 0($t4)

f_loop: slti $t6, $t2, 3
        beq $t6, $zero, updt1
        addi $t4, $t4, 16
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre1
        add $t3, $t5, $zero
incre1: addi $t2, $t2, 1
        j f_loop


updt1:  sw $t3, 0($a2)
        addi $a2, $a2, 4

        addi $t4, $a1, 4

        add $t2, $zero $zero
        lw $t3, 0($t4)

s_loop: slti $t6, $t2, 3
        beq $t6, $zero, updt2
        addi $t4, $t4, 16
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre2
        add $t3, $t5, $zero
incre2: addi $t2, $t2, 1
        j s_loop

updt2:  sw $t3, 0($a2)
        addi $a2, $a2, 4

        addi $t4, $a1, 8

        add $t2, $zero, $zero
        lw $t3, 0($t4)

t_loop: slti $t6, $t2, 3
        beq $t6, $zero, updt3
        addi $t4, $t4, 16
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre3
        add $t3, $t5, $zero
incre3: addi $t2, $t2, 1
        j t_loop

updt3:  sw $t3, 0($a2)
        addi $a2, $a2, 4

        addi $t4, $a1, 12

        add $t2, $zero, $zero
        lw $t3, 0($t4)

fo_loop: slti $t6, $t2, 3
        beq $t6, $zero, updt4
        addi $t4, $t4, 16
        lw $t5, 0($t4)
        slt $t6, $t3, $t5
        beq $t6, $zero, incre4
        add $t3, $t5, $zero
incre4: addi $t2, $t2, 1
        j fo_loop

updt4:  sw $t3, 0($a2)

        la $a2 Max
        addi $t0, $zero, 0
loop:   slti $t1, $t0, 4
        beq $t1, $zero, exit

        lw $a0, 0($a2)
        li $v0, 1
        syscall

        la $a0, space
        li $v0, 4
        syscall

        addi $t0, $t0, 1
        addi $a2, $a2, 4
        j loop

exit:   li $v0, 10
        syscall














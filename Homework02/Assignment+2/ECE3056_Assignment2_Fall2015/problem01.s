#Sreeramamurthy Tripuramallu 903057502
.data
out: .asciiz "After Swapping: x = 5, y = 10\n"

values: .word 10, 5

main:

    la $t0, values #Load address of first number
    lw $t1, 0($t0) #Load first number (x)
    lw $t0, 4($t0) #Load second number (y)

    addi $t1, $t1, $t0 #Add the x and y
    subu $t0, $t1, $t0 #Subtract y from x, store in y
    subu $t1, $t1, $t0 #Subract new y from x, store in x

    #Display output string
    la $a0, out
    li $v0, 4
    syscall

   #Terminate program
   li $v0, 10
   syscall






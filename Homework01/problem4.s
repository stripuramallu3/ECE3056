.data
start:      .word 0x3, 18, str
str:        .asciiz "Test"
            .align 2
end:        .byte 0x7, 0x11
            .align 2
            .word 22

.text
.globl main

main:
li $v0, 10      # code for program end
    syscall
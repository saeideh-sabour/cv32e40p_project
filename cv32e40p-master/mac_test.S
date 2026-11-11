.section .text
.globl _start

_start:

    li x1, 3
    li x2, 4
    li x3, 5

    .word 0x482081AB

loop:
    j loop
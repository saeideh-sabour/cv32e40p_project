.section .text
.global _start

_start:

    li x10, 0x1000
    li x11, 0x2000

    add x12, x10, x0
    add x13, x11, x0

    .word 0x00B5060B

loop:
    j loop
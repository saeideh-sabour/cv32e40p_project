.section .text
.global _start

_start:

    li x10, 0x1000
    li x11, 0x2000

    .word 0x00b5060b

loop:
    j loop
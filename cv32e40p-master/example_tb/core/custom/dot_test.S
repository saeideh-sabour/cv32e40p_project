.section .text
.global _start

_start:
    li x1, 0x01020304
    li x2, 0x05060708

    .word 0x002091fb

    li x4, 0x46

    bne x3, x4, fail

pass:
    j pass

fail:
    j fail
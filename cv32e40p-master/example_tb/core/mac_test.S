.section .text
.global _start

_start:

    li x1, 3
    li x2, 4
    li x3, 5

    cv.mac x3, x1, x2

    li x4, 17

    bne x3, x4, fail

pass:
    li a0, 1
    j pass

fail:
    li a0, 0
    j fail

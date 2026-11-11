.text
.global _start

_start:

    la x10, data
    la x11, weight

    .word 0x00b5060b

loop:
    j loop


.data

data:
.word 1,2,3,4,5,6,7,8,9

weight:
.word 1,0,-1,1,0,-1,1,0,-1
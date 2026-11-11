	.file	"conv_hw.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	convolution_custom
	.type	convolution_custom, @function
convolution_custom:
 #APP
# 9 "conv_hw.c" 1
	.word 0x00b5060b
# 0 "" 2
 #NO_APP
	ret
	.size	convolution_custom, .-convolution_custom
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	addi	a5,sp,8
	addi	a4,sp,44
 #APP
# 9 "conv_hw.c" 1
	.word 0x00b5060b
# 0 "" 2
 #NO_APP
.L4:
	j	.L4
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 13.2.0"

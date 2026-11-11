	.file	"conv_sw.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	convolution
	.type	convolution, @function
convolution:
	mv	a5,a0
	addi	a2,a0,36
	li	a0,0
.L2:
	lw	a4,0(a5)
	lw	a3,0(a1)
	addi	a5,a5,4
	addi	a1,a1,4
	mul	a4,a4,a3
	add	a0,a0,a4
	bne	a5,a2,.L2
	ret
	.size	convolution, .-convolution
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.L6:
	j	.L6
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 13.2.0"

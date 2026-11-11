	.file	"conv.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	convolution
	.type	convolution, @function
convolution:
	ble	a2,zero,.L5
	slli	t4,a2,2
	neg	t5,a2
	add	a7,a0,t4
	li	t3,0
	li	a0,0
	slli	t5,t5,3
.L3:
	sub	t1,a7,t4
	mv	a3,a1
	mv	a5,t1
.L4:
	lw	a4,0(a5)
	lw	a6,0(a3)
	addi	a5,a5,4
	addi	a3,a3,4
	mul	a4,a4,a6
	add	a0,a0,a4
	bne	a5,a7,.L4
	addi	t3,t3,1
	add	a1,a1,t4
	sub	a7,t1,t5
	bne	a2,t3,.L3
	ret
.L5:
	li	a0,0
	ret
	.size	convolution, .-convolution
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.L9:
	j	.L9
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 13.2.0"

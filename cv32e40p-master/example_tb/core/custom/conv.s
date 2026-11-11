	.file	"conv.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	convolution
	.type	convolution, @function
convolution:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	zero,-20(s0)
	sw	zero,-24(s0)
	j	.L2
.L5:
	sw	zero,-28(s0)
	j	.L3
.L4:
	lw	a4,-24(s0)
	lw	a5,-44(s0)
	mul	a4,a4,a5
	lw	a5,-28(s0)
	add	a5,a4,a5
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a3,-24(s0)
	lw	a5,-44(s0)
	mul	a3,a3,a5
	lw	a5,-28(s0)
	add	a5,a3,a5
	slli	a5,a5,2
	lw	a3,-40(s0)
	add	a5,a3,a5
	lw	a5,0(a5)
	mul	a5,a4,a5
	lw	a4,-20(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L3:
	lw	a4,-28(s0)
	lw	a5,-44(s0)
	blt	a4,a5,.L4
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	lw	a5,-44(s0)
	blt	a4,a5,.L5
	lw	a5,-20(s0)
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	convolution, .-convolution
	.section	.rodata
	.align	2
.LC0:
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.word	8
	.word	9
	.align	2
.LC1:
	.word	1
	.word	0
	.word	-1
	.word	1
	.word	0
	.word	-1
	.word	1
	.word	0
	.word	-1
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-96
	sw	ra,92(sp)
	sw	s0,88(sp)
	addi	s0,sp,96
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	t1,0(a5)
	lw	a7,4(a5)
	lw	a6,8(a5)
	lw	a0,12(a5)
	lw	a1,16(a5)
	lw	a2,20(a5)
	lw	a3,24(a5)
	lw	a4,28(a5)
	lw	a5,32(a5)
	sw	t1,-56(s0)
	sw	a7,-52(s0)
	sw	a6,-48(s0)
	sw	a0,-44(s0)
	sw	a1,-40(s0)
	sw	a2,-36(s0)
	sw	a3,-32(s0)
	sw	a4,-28(s0)
	sw	a5,-24(s0)
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
	lw	t1,0(a5)
	lw	a7,4(a5)
	lw	a6,8(a5)
	lw	a0,12(a5)
	lw	a1,16(a5)
	lw	a2,20(a5)
	lw	a3,24(a5)
	lw	a4,28(a5)
	lw	a5,32(a5)
	sw	t1,-92(s0)
	sw	a7,-88(s0)
	sw	a6,-84(s0)
	sw	a0,-80(s0)
	sw	a1,-76(s0)
	sw	a2,-72(s0)
	sw	a3,-68(s0)
	sw	a4,-64(s0)
	sw	a5,-60(s0)
	addi	a4,s0,-92
	addi	a5,s0,-56
	li	a2,3
	mv	a1,a4
	mv	a0,a5
	call	convolution
	sw	a0,-20(s0)
.L8:
	j	.L8
	.size	main, .-main
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC x86_64) 13.2.0"

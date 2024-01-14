	.file	"test.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	mv	a5,a0
	sd	a1,-32(s0)
	sw	a5,-20(s0)
	call	foo
	mv	a5,a0
	mv	a0,a5
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.align	1
	.globl	bar
	.type	bar, @function
bar:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	
	mv	a5,a0
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	mv	a0,a5
	ld	s0,24(sp)
	addi	sp,sp,32
	
	jr	ra
	.size	bar, .-bar
	.align	1
	.globl	foo
	.type	foo, @function
foo:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	li 	t1,4
	li 	t2,-8
	li      t6,15
	
	#.half  0x6081 #c.sspuch x1
	.long 0x82504073  #sspush x5	
	la 	a5,bar
	#lui	a5,%hi(bar)
	#ddi	a5,a5,%lo(bar)
	sd	a5,-24(s0)
	ld	a5,-24(s0)
	li	a0,4
	jalr	a5
	mv	a5,a0
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	mv	a0,a5
	#.long   0x860043F3 #ssprr x7 , x7 holds current ssp
	#.long   0x8203C373 #ssammoswap t1,x0,(x7)  x7=0, t0=ssp?
	#li      t1,0x3ffffffff8
	#sd	t6,0(t1)
	csrr 	t3,0x81c
	
	ld	ra,24(sp)	
	ld	s0,16(sp)
	addi    t2,t2,2
	ori	t2,t1,1
	and	t2,t2,0
	#.long   0x81C0C073 #sspopchk x1
	.half    0x6281 #c.sspopchk x5 (should be correct)
	#.long   0x81C040F3 #ssload x1
	#.long   0x81D0C073 #sspinc *1
	
	addi    t2,t2,2
	ori	t2,t1,1
	csrw    0x81c,t2
	and	t2,t2,0
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	
	jr	ra
	.size	foo, .-foo
	.ident	"GCC: (SiFive GCC 8.3.0-2020.04.0) 8.3.0"

#include "leon.h"
#define RAMSIZE 0x40000
#define RAMEND (CRAM + RAMSIZE)

	.seg	"text"
	.proc	0
	.align	4
	.global _hardreset
_hardreset:
por:

	flush
	set 0x10c0, %g1		! init IU
	mov %g1, %psr
	mov %g0, %wim
	mov %g0, %tbr
	mov %g0, %y
	nop
	
	set PREGS, %g7		! on-chip register base address
	st %g0, [%g7 + ECTRL]
	ld [%g7 + MCFG1], %g1
	and %g1, 0x3ff, %g1
	st %g1, [%g7 + MCFG1]

	set 0x1000f, %g2		! enable caches
	st %g2, [%g7 + CCTRL]

	ld [%g7 + ECTRL], %g2	! if regfile EDAC, then wash register file
	srl %g2, RFE_CONF_BIT, %g3
	andcc %g3, RFE_CONF_MASK, %g3
	be 2f
	ld [%g7 + LCONF], %g2	! load LEON configuration register
	srl %g2, 20, %g3
	and %g3, 0x1f, %g3
	mov %g0, %g4
	mov %g0, %g5
	mov %g0, %g6
	mov %g0, %asr16
1:
	mov %g0, %l0
	mov %g0, %l1
	mov %g0, %l2
	mov %g0, %l3
	mov %g0, %l4
	mov %g0, %l5
	mov %g0, %l6
	mov %g0, %l7
	mov %g0, %o0
	mov %g0, %o1
	mov %g0, %o2
	mov %g0, %o3
	mov %g0, %o4
	mov %g0, %o5
	mov %g0, %o6
	mov %g0, %o7
	subcc %g3, 1, %g3
	bge 1b
	save

	srl %g2, FPU_CONF_BIT, %g3
	andcc %g3, FPU_CONF_MASK, %g0
	be 2f
	set	fsrinit, %g3
	ld	[%g3], %fsr
	ldd	[%g0], %f0
	ldd	[%g0], %f2
	ldd	[%g0], %f4
	ldd	[%g0], %f6
	ldd	[%g0], %f8
	ldd	[%g0], %f10
	ldd	[%g0], %f12
	ldd	[%g0], %f14
	ldd	[%g0], %f16
	ldd	[%g0], %f18
	ldd	[%g0], %f20
	ldd	[%g0], %f22
	ldd	[%g0], %f24
	ldd	[%g0], %f26
	ldd	[%g0], %f28
	ba	3f
	ldd	[%g0], %f30
2:
	srl %g2, FPU_CONF_BIT, %g3
	andcc %g3, FPU_CONF_MASK, %g0
	be 3f
	set	fsrinit, %g3
	ld	[%g3], %fsr
3:
	ld [%g7 + MCFG1], %g2
	set 0xfffc00ff, %g1
	andn %g2, %g1, %g1
	ld [%g7 + IOREG], %g2
	srl %g2, 4, %g2
	and %g2, 3, %g2
	or %g1, %g2, %g1
	set 0x18080000, %g2 	! initialise memory config registers
	or %g2, %g1, %g1
	st %g1, [%g7 + MCFG1]
	ld [%g7 + IOREG], %g2
	srl %g2, 6, %g3
	and %g3, 3, %g3
	set 0x830, %g1		! 32-bit SRAM, 2x128 banks
	or %g1, %g3, %g1
	st %g1, [%g7 + MCFG2]
	st %g0, [%g7 + IFORCE]
	st %g0, [%g7 + IMASK]
	st %g0, [%g7 + IPEND]
	st %g0, [%g7 + ICLEAR]
	st %g0, [%g7 + MSTAT]
	ld [%g7 + ECTRL], %g2	! enable RAM EDAC
	or %g2, 0x200, %g2
	st %g2, [%g7 + ECTRL]

/*
	set	0x40000000, %o2
	mov	%o2, %tbr
	set	0x81c44000, %o0
	set	0x81cc8000, %o1
	std	%o0, [%o2 + 0x190]
	set	1<<9, %o0
	st 	%o0, [%g7 + IMASK]
	set	49, %o0
	st 	%o0, [%g7 + SRLD]
	st 	%o0, [%g7 + SCNT]
	set	1, %g1
	st 	%g1, [%g7 + TRLD0]
	st 	%g1, [%g7 + TRLD1]
	set	7, %o0
	st 	%o0, [%g7 + TCTRL0]
	st 	%o0, [%g7 + TCTRL1]
*/

	set 0x10e0, %g1		! enable traps
	mov %g1, %psr
	nop; nop; nop;
	set     RAMEND - 104, %sp
	mov	%sp, %g3

	set	CRAM, %g1
	jmp	%g1
	nop

fsrinit:
	.word 0
.align	32

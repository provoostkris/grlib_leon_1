#include "leon.h"
#include "test.h" 
#include <math.h> 

int __errno;
fpu_init()
{
	int tmp;

	tmp = getpsr();
	setpsr(tmp | (1 << 12));
	set_fsr(0);
}

fpu_test()
{
	if (!((lr->leonconf>>FPU_CONF_BIT)&FPU_CONF_MASK)) return(0);
	report(FPU_TEST);

	fpu_init();
	fpu_main();
}

fpu_main()
{
	volatile double a,c;
	float b;
	int tmp;
	
	a = sqrt(3.0);
	if (fabs((a * a) - 3.0) > 1E-15) fail(1);
	b = sqrt(3.0);
	if (fabs((b * b) - 3.0) > 1E-7) fail(2);
	tmp = fpu_pipe();
	if (tmp) fail(tmp);
}

#ifdef __leon__
double _f1x = -1.0;
double _fq1[2];
int _fsr1 = 0x80000000;
#else
double f1x = -1.0;
double fq1[2];
int fsr1 = 0x80000000;
#endif

fpu_pipe()
{
	asm("

	set	_fsr1, %o0	! check ldfsr/stfsr interlock
	ld	[%o0], %fsr
	st	%g0, [%o0]
	ld	[%o0], %fsr
	st	%fsr, [%o0]
	ld	[%o0], %o2
	subcc	%g0, %o2, %g0
	bne,a	fail
	mov	3, %o0

	set 0x0f800000, %o1	! check ldfsr/fpop interlock
	st	%o1, [%o0]
	ld	[%o0], %fsr
	st	%g0, [%o0]
	set	_f1x, %o2
	ld	[%o2], %f0
	nop; nop
	ld	[%o0], %fsr
	fsqrts	%f0, %f1
	mov	%tbr, %o3
	and	%o3, 0x0ff0, %o3
	subcc	%o3, 0x070, %g0
	be,a	fail
	mov	4, %o0


	mov	0, %o0

	nop
fail:

	");
}


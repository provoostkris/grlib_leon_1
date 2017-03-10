#include "leon.h"
struct lregs *lr = (struct lregs *) PREGS;
unsigned char *msg = (unsigned char *) IOAREA; 
unsigned short *msgh = (unsigned short *) IOAREA; 
unsigned int *msgw = (unsigned int *) IOAREA; 
unsigned long long *msgd = (unsigned long long *) IOAREA; 
int test ;
int dummy[4] = {0,0,0,0};

fail(err) int err; { msg[test] = err; }
report(test_case) int test_case; { test = test_case; msg[test] = 0; }

int getpsr() { asm(" mov %psr, %o0 "); }

setpsr(psr) int psr; { asm(" mov %o0, %psr;nop;nop;nop "); }

unsigned char inb(a) int a; { return(msg[a]); }
outb(a,d) int a; char d; { msg[a] = d; }
unsigned short inh(a) int a; { return(msgh[a]); }
outh(a,d) int a; short d; { msgh[a] = d; }
unsigned int inw(a) int a; { return(msgw[a]); }
outw(a,d) int a; short d; { msgw[a] = d; }
unsigned long long ind(a) int a; { return(msgd[a]); }
outd(a,d) int a; short d; { msgd[a] = d; }

asm("
	.global _get_fsr, _set_fsr
	.global get_fsr, set_fsr
	.data
fsrtmp:	.word 0
	.text
_get_fsr:
get_fsr:
	set	fsrtmp, %o0
	st	%fsr, [%o0]
	retl
	ld	[%o0], %o0
_set_fsr:
set_fsr:
	set	fsrtmp, %o1
	st	%o0, [%o1]
	retl
	ld	[%o1], %fsr
");


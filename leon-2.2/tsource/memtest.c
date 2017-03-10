#include "leon.h"
#include "test.h"

extern volatile int dexcn;
volatile int stest;
volatile int dtest;
volatile int xtest;
volatile long long ytest, ddtmp;
volatile int xarr[2];
volatile char *ztest;
volatile int *yptr;

dblerr(int *p)
{
	asm("
	set	0x80000000, %o1
	ld	[%o1 + 0x08], %o4
	or 	%o4, 0x80, %o3
	st	%o3, [%o1 + 0x08]
	ld	[%o0], %o2
	xor	%o2, 3, %o2
	st	%o2, [%o0]
	st	%o4, [%o1 + 0x08]
	");
}

int
edac_test()
{
	int tmp,i;


	/* skip test if edac disabled */
	if (!((lr->ectrl >> MEDAC_CONF_BIT) & (lr->ectrl >> REDAC_CONF_BIT) & 1))
		return(0);	

	report(EDAC_TEST);
	dexcn = 0;
	lr->memstatus = 0;			/* initialise MSTAT */
	lr->cachectrl &= ~0x0c;		/* disable data cache */

	/* test single-bit errors in all positions */

	stest = dtest = xtest = 0; 
	dblerr((int *) &dtest); dblerr((int *) &xtest);
	lr->ectrl |= 0x80; tmp = stest; stest = 1;

	if ((stest != 0) || (lr->failaddr != (int) &stest) ||
	   (lr->memstatus != 0x1d8))
	{
		fail(1);
	}

	for (i=1;i<32;i++) { stest = 1 << i; if (stest != 0) break; }
	if ((i!=32) || (lr->failaddr != (int) &stest) || 
		(lr->memstatus != 0x3d8))
	{
		fail(2);
	}

	/* check that multiple error and lock is set, and FAR loaded */

	lr->ectrl &= ~0x80; dexcn = 1; tmp = dtest;
	if ((lr->failaddr != (int) &dtest) || (lr->memstatus != 0x7d9) ||
		(dexcn != 0)) { fail(3); }

	/* clear memory status register and provoke double error */
	lr->memstatus = 0; dexcn = 1; tmp = xtest;
	if ((lr->failaddr != (int) &xtest) || (lr->memstatus != 0x5d9) ||
		(dexcn != 0)) fail(4);

	/* check that multiple error is set and FAR not changed */
	dexcn = 1; tmp = dtest;
	if ((lr->failaddr != (int) &xtest) || (lr->memstatus != 0x7d9) ||
		(dexcn != 0)) fail(5);

	/* check errors during byte write */
	ztest = (char *) &dtest;
	lr->memstatus = 0; ztest[0] = 4;
	if ((lr->failaddr != (int) &dtest) || (lr->memstatus != 0x5d9) ||
		((lr->irqpend & (1 << 15)) == 0)) { fail(6); }
	lr->irqclear = (1 << 15);
	lr->ectrl &= ~(1 << REDAC_CONF_BIT);	/* disable edac */
	if (dtest != 3) fail(7);/* check that write cycle was aborted */
	lr->ectrl |= (1 << REDAC_CONF_BIT);	/* enable edac */

	ztest = (char *) &stest;
	stest = 0; lr->failaddr = 0;
	lr->ectrl |= 0x80; stest = 1^stest; lr->ectrl &= ~0x80;
	lr->memstatus = 0;  ((char *) &stest)[2] = 5;
	if ((stest!=0x500) || ((lr->failaddr ^ ((int) &(stest))) & ~3) || 
		(lr->memstatus != 0x1d8))
		fail(8);

	/* check load/store double exceptions */
	ytest = 0; lr->failaddr = 0; yptr = (int *) &ytest; dblerr((int *)yptr);
	lr->memstatus = 0; dexcn = 1; ddtmp = 0;
	ddtmp = ytest;	/* read exception on first word */
	if ((lr->failaddr != (int) &ytest) || (lr->memstatus != 0x5d9))
		fail(9);

	ytest = 0; lr->failaddr = 0; dblerr((int *)&yptr[1]);
	lr->memstatus = 0; dexcn = 1;
	ddtmp = ytest;	/* exception on second word */
	if ((lr->failaddr != (int) &yptr[1]) || (lr->memstatus != 0x5d9))
		fail(10);

	/* test that edac correction still generates correct parity */
	if ((lr->ectrl >> CPP_CONF_BIT) & CPP_CONF_MASK) {
	  flush();
	  stest = 0;
	  lr->ectrl |= 0x80; tmp = stest; stest = 1; lr->ectrl &= ~0x80;
	  while (lr->cachectrl & 0x0c000); /* wait for flush to complete */

	  lr->cachectrl |= 0x0f;        /* enable icache & dcache */
	
	  if (stest != 0) fail(11);
	  if (stest != 0) fail(12);
	  if (((lr->ectrl >> DDE_BIT) & 3) != 0) fail(13);
	} else {
	  flush();
	  lr->cachectrl |= 0x0f;        /* enable icache & dcache */
	}



}
	

memtest()
{

	volatile int wtest;

/* test I/O bus exception */

	if (!(lr->leonconf & 0x40)) return(0);
	report(MEM_TEST);

	lr->memcfg1 |= (0x23 << 20); /* enable BEXCN signal */
	dexcn = 1; lr->failaddr = 0; lr->memstatus = 0;
	inb(80,0); /* cause read exception */
	if ((lr->failaddr != (IOAREA + 80)) || (lr->memstatus != 0x180) ||
		(dexcn != 0)) { fail(1); }
	dexcn = 1; lr->failaddr = 0; lr->memstatus = 0;
	inb(72,0); /* cause read exception */
	if ((lr->failaddr != (IOAREA + 72)) || (lr->memstatus != 0x180) ||
		(dexcn != 0)) { fail(2); }
	lr->failaddr = 0; lr->memstatus = 0; dexcn = 1;
	outb(80,0); /* cause write exception */
	if ((lr->failaddr != (IOAREA + 80)) || (lr->memstatus != 0x100) ||
		(dexcn != 0)) { fail(3); }
	lr->failaddr = 0; lr->memstatus = 0; dexcn = 1;
	outb(72,0); /* cause write exception */
	if ((lr->failaddr != (IOAREA + 72)) || (lr->memstatus != 0x100) ||
		(dexcn != 0)) { fail(4); }

/* write protection test */

	if (lr->leonconf & 0x3) {
		lr->cachectrl &= ~0x0c;		/* disable data cache */
		dexcn = 1; lr->failaddr = 0; lr->memstatus = 0;
		lr->irqclear = 2;
		lr->writeprot1 = 0xc0007fff | (((int)&wtest) & 0x3fff8000);
		wtest = 1;
		if ((lr->failaddr != (int) &wtest) || (lr->memstatus != 0x102) ||
			(dexcn != 0) || ((lr->irqpend & 2) == 0)) { fail(5); }
		lr->failaddr = 0; lr->memstatus = 0; lr->irqclear = 2; 
		lr->writeprot2 = 0x80007fff | (((int)&wtest) & 0x3fff8000);
		wtest = 1;
		if (lr->irqpend & 2) { fail(6); }
		lr->writeprot2 = 0;
		lr->writeprot1 ^= 0x00010000;
		wtest = 1;
		if ((lr->irqpend & 2)) { fail(7); }
		lr->writeprot1 = 0; dexcn = 1; lr->writeprot2 = 0x80007fff;
		wtest = 1;
		lr->writeprot2 = 0;
		if ((lr->failaddr != (int) &wtest) || (lr->memstatus != 0x102) ||
			((lr->irqpend & 2) == 0)) { fail(8); }
		flush();
		lr->cachectrl |= 0x0f;        /* enable icache & dcache */
		lr->failaddr = 0; lr->memstatus = 0; lr->irqclear = 2; 

	}
}

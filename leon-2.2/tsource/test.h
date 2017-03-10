
#define MSGAREA	IOAREA

#define PRINT(X)	set MSGAREA, %o0; ld [%o0 + X*4], %g0
#define FAIL(X)		set MSGAREA, %o0; st %g0, [%o0 + X*4]
#define SYS_TEST 0
#define CACHE_TEST 1
#define REG_TEST 	2
#define FPU_TEST 	7
#define PCI_TEST 	8
#define IRQ_TEST 	10
#define TIMER_TEST 	11
#define UART_TEST 	12
#define PIO_TEST	13
#define EDAC_TEST	14
#define DMA_TEST	15
#define MEM_TEST	16
#define TEST_END    	17

#define ITAG_VALID_MASK ((1 << ILINESZ) -1)
#define ITAG_MAX_ADDRESS ((1 << ITAG_BITS) -1) << (ILINEBITS + 2)
#define DTAG_VALID_MASK ((1 << DLINESZ) -1)
#define DTAG_MAX_ADDRESS ((1 << DTAG_BITS) -1) << (DLINEBITS + 2)

#ifndef __ASSEMBLER__
extern struct lregs *lr;
extern int test;
#endif

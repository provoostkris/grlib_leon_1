#include "leon.h"
#include "test.h"

leon_test()
{
	
	report(SYS_TEST);

	report(REG_TEST);
	if (regtest() != 1) fail(1);
	fpu_test();
	memtest();
	edac_test();
	cache_test();
	irq_test();
	timer_test();
	ioport_test();
	uart_test();
	report(TEST_END);
}


#include "leon.h"
#include "test.h"

#define RX_EN	1
#define TX_EN	2
#define RIRQ_EN	4
#define TIRQ_EN	8
#define EVENPAR	16
#define PAR_EN 	32
#define FLOW_EN	64
#define LOOPBACK 128


int uart_test()
{
    
    /* report start of test */
    report(UART_TEST);

    /* enable UARTs */

    lr->uartscaler1 = 0;
    lr->uartscaler2 = 0;
    lr->piodata = 0xaa00;
    lr->piodir = 0xaa00;

    /* test registers */
    lr->uartctrl1 = 0;
    if (lr->uartctrl1) fail(1);
    lr->uartctrl2 = 0;
    if (lr->uartctrl2) fail(2);

    /* Check data transfer */

    lr->uartctrl1 = (RX_EN | TX_EN);
    lr->uartctrl2 = (RX_EN | TX_EN);
    lr->uartdata1 = 0x55;
    while(!(lr->uartstatus1 & 4)){}
    lr->uartdata1 = 0xAA;
    while(!(lr->uartstatus2 & 1)){}
    lr->uartdata2 = lr->uartdata2;
    while(!(lr->uartstatus2 & 1)){}
    lr->uartdata2 = lr->uartdata2;
    while(!(lr->uartstatus1 & 1)){}
    if (lr->uartdata1 != 0x55) fail(3);
    while(!(lr->uartstatus1 & 1)){}
    if (lr->uartdata1 != 0xAA) fail(4);

    /* Check flow control */

    lr->uartctrl1 = (RX_EN | TX_EN | FLOW_EN);
    lr->uartctrl2 = (RX_EN | TX_EN | FLOW_EN);
    lr->uartdata1 = 0x11;
    while(!(lr->uartstatus1 & 4)){}
    lr->uartdata1 = 0x22;
    while((lr->uartstatus1 & 6) != 6){}
    lr->uartdata1 = 0x33;
    while(!(lr->uartstatus2 & 1)){}
    if (lr->uartdata2 != 0x11) fail(5);
    while(!(lr->uartstatus2 & 1)){}
    if (lr->uartdata2 != 0x22) fail(6);
    while(!(lr->uartstatus2 & 1)){}
    if (lr->uartdata2 != 0x33) fail(7);

    /* To be tested: loop-back, parity, frame-error, break, baud-rates */

}

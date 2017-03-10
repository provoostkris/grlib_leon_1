
#include "leon.h"
#include "test.h"

int ioport_test()
{
    
    /* report start of test */
    report(PIO_TEST);

    /* initialise registers */

    lr->piodata = 0;
    lr->piodir = 0;
    lr->pioirq = 0;
    lr->uartctrl1 = 0;
    lr->uartctrl2 = 0;


    /* check that port can be read */
    outb(66,0x55); outb(67,0xaa);
    outb(64,0xff); outb(65,0xff);
    if ((lr->piodata & 0x0ffff) != 0xaa55) fail(1);
    outb(66,0xaa); outb(67,0x55);
    if ((lr->piodata & 0x0ffff) != 0x55aa) fail(2);
    
    /* check that port can be written */
    outb(64,0); outb(65,0);
    lr->piodir = 0xffff;
    if ((lr->piodata & 0x0ffff) != 0) fail(3);
    lr->piodata = 0x1234;
    if ((lr->piodata & 0x0ffff) != 0x1234) fail(4);
    lr->piodata = ~0x1234;
    if ((lr->piodata & 0x0ffff) != (0xffff & ~0x1234)) fail(5);

    /* check port interrupts */

    lr->piodata = 0;
    lr->irqclear = -1;	/* clear all pending interrupts */
    lr->pioirq = 0xe3c2a180;
    lr->irqclear = -1;	
    if ((lr->irqpend & 0x0f0) != (1<<4)) fail(6);
    lr->piodata = -1;
    lr->piodata = -1;	/* add delay */
    if ((lr->irqpend & 0x0f0) != ((1<<7) | (1<<5) | (1<<4))) fail(7);
    lr->irqclear = -1;	
    if ((lr->irqpend & 0x0f0) != (1<<5)) fail(8);
    lr->piodata = 0;
    lr->piodata = 0;
    if ((lr->irqpend & 0x0f0) != ((1<<6) | (1<<5) | (1<<4))) fail(9);
    lr->irqclear = -1;	
    if ((lr->irqpend & 0x0f0) != (1<<4)) fail(10);
    lr->piodir = 0;
    lr->pioirq = 0;
    lr->irqclear = -1;	
    

}

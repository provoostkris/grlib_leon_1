
CC=sparc-rtems-gcc
CFLAGS=-O2
LDFLAGS=-N -nostdlib  -T ./linkleon -e _hardreset locore1.o 
LIBS=-L/opt/rtems/sparc-rtems/lib  -L/usr/local/leon/sparc-rtems/lib \
	-lgcc -lm

all: tests
tests: locore1.o leon_test simfiles

simfiles: ram.dat rom.dat rome.dat rom8.dat rom8e.dat rom16.dat
ram.dat: leon_test
	sparc-rtems-objcopy --remove-section=.comment leon_test
	sparc-rtems-objdump -s leon_test > ram.dat
	sparc-rtems-objdump -d leon_test > ram.s
	sparc-rtems-size leon_test

rom8e.dat: boot8e
	sparc-rtems-objdump -s boot8e > rom8e.dat
	sparc-rtems-objdump -d boot8e > rome.s
	sparc-rtems-size boot8e

rom8.dat: boot8
	sparc-rtems-objdump -s boot8 > rom8.dat
	sparc-rtems-objdump -d boot8 > rom8.s
	sparc-rtems-size boot8

rom16.dat: boot16
	sparc-rtems-objdump -s boot16 > rom16.dat
	sparc-rtems-objdump -d boot16 > rom16.s
	sparc-rtems-size boot16

rome.dat: boote
	sparc-rtems-objdump -s boote > rome.dat
	sparc-rtems-objdump -d boote > rome.s
	sparc-rtems-size boote

rom.dat: boot
	sparc-rtems-objdump -s boot > rom.dat
	sparc-rtems-objdump -d boot > rom.s
	sparc-rtems-size boot

boot8e: boot8e.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot \
	-e _hardreset boot8e.o -o boot8e

boot16: boot16.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot \
	-e _hardreset boot16.o -o boot16

boot8: boot8.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot \
	-e _hardreset boot8.o -o boot8

boote: boote.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot \
	-e _hardreset boote.o -o boote

boot: boot.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot \
	-e _hardreset boot.o -o boot

leon_test : regtest.o irqctrl.o uart.o leon_test.o timers.o cache.o misc.o \
	memtest.o ioport.o fpu.o
	$(CC) $(LDFLAGS) regtest.o irqctrl.o uart.o leon_test.o timers.o cache.o misc.o \
	memtest.o ioport.o fpu.o $(LIBS) -o leon_test
	sparc-rtems-strip leon_test

clean:
	-rm boot leon_test *.o *.s boot8 boot8e boote boot16

# DO NOT DELETE

uart.o: leon.h test.h
leon_test.o: leon.h test.h locore1.o
cache_test.o: leon.h test.h
timer_test.o: leon.h test.h
regtest.o: leon.h test.h
dma.o: leon.h test.h
misc.o: leon.h
memtest.o: leon.h test.h
ioport.o: leon.h test.h
fpu.o: leon.h test.h

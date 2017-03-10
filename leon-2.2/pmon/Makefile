
CC=gcc

all: rom2vhdl bprom.vhd eprom.srec

rom2vhdl: rom2vhdl.c
	$(CC) rom2vhdl.c -o rom2vhdl

bprom.vhd: rom2vhdl bprom.c
	sparc-rtems-gcc -nostdlib -nostdinc -O2 -Ttext 0 bprom.c -o bprom
	sparc-rtems-objcopy -O binary bprom bprom.bin
	rom2vhdl bprom.bin -o bprom.vhd

eprom.srec: eprom.c
	sparc-rtems-gcc -nostdlib -nostdinc -O2 -Ttext 0 eprom.c -o eprom
	sparc-rtems-objcopy -O srec eprom eprom.srec

clean:
	rm -f rom2vhdl bprom.vhd bprom bprom.bin eprom eprom.srec


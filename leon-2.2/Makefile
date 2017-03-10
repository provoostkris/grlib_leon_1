
VLIB = vlib
VCOM = vcom

all: vsim

vsim:
	cd leon; make
	cd tbench; make

vss:
	cd leon; make VCOM="vhdlan -nc -interp" VLIB="mkdir"
	cd tbench; make VCOM="vhdlan -nc -interp" VLIB="mkdir"

tests: 
	cd tsource; make
clean:
	cd leon; make clean
	cd tbench; make clean
	cd tsource; make clean
	-rm trnscrpt transcript vsim.wlf vsim.wav

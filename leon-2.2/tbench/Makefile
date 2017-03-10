
VLIB = vlib
VCOM = vcom -quiet -O5
CPP = cpp -P 
#CPP = cpp -P -DLEONFT
SOURCES = iram.vhd mspram.vhd testmod.vhd leonlib.vhd bprom.vhd \
	tbgen.vhd tb_msp.vhd tblib.vhd tbdef.vhd tbleon.vhd
	
%.vhd : %.raw
	$(CPP) $(CPP_FLAGS) $< >$@

tags/%.tag : %.vhd
	$(VCOM) $<
	@touch $@

all: tags leonlib tbgen tbdef tb_msp tblib tbleon bprom

tags/iram.tag : ../leon/tags/leon.tag iram.vhd 
iram : tags/iram.tag 
tags/bprom.tag : tags/iram.tag bprom.vhd 
bprom : tags/bprom.tag 
tags/mspram.tag : ../leon/tags/leon.tag mspram.vhd 
mspram : tags/mspram.tag 
tags/testmod.tag : ../leon/tags/leon.tag testmod.vhd 
testmod : tags/testmod.tag 
tags/leonlib.tag : ../leon/tags/leon.tag leonlib.vhd
leonlib : tags/leonlib.tag 
tags/tbgen.tag : tags/leonlib.tag tags/iram.tag tags/testmod.tag tbgen.vhd 
tbgen : tags/tbgen.tag 
tags/tb_msp.tag : tags/leonlib.tag tags/iram.tag tags/mspram.tag tb_msp.vhd 
tb_msp : tags/tb_msp.tag 
tags/tblib.tag : tags/tbgen.tag tblib.vhd
tblib : tags/tblib.tag
tags/tbdef.tag : tags tags/tblib.tag tbdef.vhd
tbdef : tags/tbdef.tag
tags/tbleon.tag : tags/tbdef.tag tbleon.vhd
tbleon : tags/tbleon.tag

tags :
	mkdir tags
clean:
	-rm -rf tags vcx*

vhdl : $(SOURCES)



VLIB = vlib
VCOM = vcom -quiet -O5
VLOG = vlog -quiet -O5
LIBS = tags work
CPP = cpp -P
#CPP = cpp -P -DLEONFT
SOURCES =  config.vhd iface.vhd dcache.vhd icache.vhd ioport.vhd iu.vhd \
	regfile.vhd mctrl.vhd ioport.vhd irqctrl.vhd clkgen.vhd \
	timers.vhd uart.vhd cachemem.vhd mcore.vhd proc.vhd \
	leon.vhd macro.vhd sparcv8.vhd ramlib.vhd cache.vhd \
	target.vhd device.vhd rstgen.vhd fpulib.vhd mkconfig.vhd \
	pcitest.vhd debug.vhd leon_pci.vhd fp1eu.vhd \
	padlib.vhd wprot.vhd lconf.vhd ahbstat.vhd \
	tech_generic.vhd tech_atc35.vhd tech_synplify.vhd \
	tech_leonardo.vhd tech_virtex.vhd \
	ahbtest.vhd pci_is.vhd acache.vhd ahbarb.vhd apbmst.vhd ambacomp.vhd

%.vhd : %.raw
	$(CPP) $(CPP_FLAGS) $< >$@

tags/%.tag : %.vhd
	$(VCOM) $<
	@touch $@

tags/%.tag : %.v
	$(VLOG) $<
	@touch $@

all: $(LIBS) leon leon_pci

tags/amba.tag : amba.vhd
amba : tags/amba.tag 
tags/padlib.tag : tags/tech_generic.tag tags/tech_atc35.tag tags/tech_virtex.tag padlib.vhd
padlib : tags/padlib.tag 
tags/bprom.tag : bprom.vhd
bprom : tags/bprom.tag
tags/tech_synplify.tag : tags/config.tag tech_synplify.vhd
tech_synplify : tags/tech_synplify.tag 
tags/tech_virtex.tag : tags/config.tag tags/tech_generic.tag tech_virtex.vhd
tech_virtex : tags/tech_virtex.tag 
tags/tech_leonardo.tag : tags/config.tag tech_leonardo.vhd
tech_leonardo : tags/tech_leonardo.tag 
tags/tech_generic.tag : tags/config.tag tech_generic.vhd
tech_generic : tags/tech_generic.tag 
tags/tech_atc35.tag : tags/config.tag tags/tech_generic.tag tech_atc35.vhd
tech_atc35 : tags/tech_atc35.tag 
tags/mkconfig.tag : tags/config.tag mkconfig.vhd
mkconfig : tags/mkconfig.tag 
tags/debug.tag : tags/iface.tag debug.vhd
debug : tags/debug.tag 
tags/ambacomp.tag : tags/amba.tag tags/iface.tag ambacomp.vhd
ambacomp : tags/ambacomp.tag 
tags/ahbtest.tag : tags/amba.tag tags/iface.tag ahbtest.vhd
ahbtest : tags/ahbtest.tag 
tags/pci_is.tag : tags/amba.tag tags/iface.tag pci_is.vhd
pci_is : tags/pci_is.tag 
tags/pci_test.tag : tags/amba.tag tags/iface.tag pci_test.vhd
pci_test : tags/pci_test.tag 
tags/ahbarb.tag : tags/amba.tag tags/iface.tag ahbarb.vhd
ahbarb : tags/ahbarb.tag 
tags/ahbstat.tag : tags/amba.tag tags/iface.tag ahbstat.vhd
ahbstat : tags/ahbstat.tag 
tags/wprot.tag : tags/amba.tag tags/iface.tag wprot.vhd
wprot : tags/wprot.tag 
tags/lconf.tag : tags/amba.tag tags/iface.tag lconf.vhd
lconf : tags/lconf.tag 
tags/acache.tag : tags/amba.tag tags/target.tag tags/iface.tag acache.vhd
acache : tags/acache.tag 
tags/apbmst.tag : tags/amba.tag tags/iface.tag apbmst.vhd
apbmst : tags/apbmst.tag 
tags/target.tag : target.vhd
target : tags/target.tag
tags/device.tag : tags/target.tag device.vhd
device : tags/device.tag
tags/config.tag : tags/target.tag tags/device.tag config.vhd
config : tags/config.tag
tags/sparcv8.tag : tags/config.tag sparcv8.vhd
sparcv8 : tags/sparcv8.tag
tags/iface.tag : tags/sparcv8.tag tags/target.tag iface.vhd
iface : tags/iface.tag
tags/macro.tag : tags/iface.tag macro.vhd
macro : tags/macro.tag
tags/rstgen.tag : tags/config.tag tags/iface.tag rstgen.vhd
rstgen : tags/rstgen.tag
tags/mpciif.tag : tags/config.tag tags/iface.tag mpciif.vhd
mpciif : tags/mpciif.tag
tags/fpulib.tag : tags/iface.tag fpulib.vhd
fpulib : tags/fpulib.tag
tags/fp1eu.tag : tags/fpulib.tag tags/iface.tag tags/macro.tag tags/debug.tag tags/ramlib.tag fp1eu.vhd
fp1eu : tags/fp1eu.tag
#tags/fp.tag : tags/fpulib.tag tags/iface.tag tags/macro.tag tags/debug.tag fp.vhd
#fp : tags/fp.tag
#tags/cp.tag : tags/iface.tag tags/macro.tag cp.vhd
#cp : tags/cp.tag
tags/iu.tag : tags/macro.tag iu.vhd
iu : tags/iu.tag
tags/ramlib.tag : tags/iface.tag tags/tech_generic.tag tags/tech_atc35.tag tags/tech_virtex.tag tags/tech_leonardo.tag tags/tech_synplify.tag tags/bprom.tag ramlib.vhd
ramlib : tags/ramlib.tag
tags/regfile.tag : tags/ramlib.tag regfile.vhd
regfile : tags/regfile.tag
tags/dcache.tag : tags/macro.tag dcache.vhd
dcache : tags/dcache.tag
tags/icache.tag : tags/macro.tag icache.vhd
icache : tags/icache.tag
tags/cachemem.tag : tags/ramlib.tag cachemem.vhd
cachemem : tags/cachemem.tag
tags/cache.tag : tags/amba.tag tags/icache.tag tags/dcache.tag tags/cachemem.tag cache.vhd
cache : tags/cache.tag
tags/clkgen.tag : tags/iface.tag clkgen.vhd
clkgen : tags/clkgen.tag
tags/proc.tag : tags/iu.tag tags/clkgen.tag tags/cache.tag tags/acache.tag tags/regfile.tag tags/fpulib.tag tags/fp1eu.tag proc.vhd
proc : tags/proc.tag
tags/irqctrl.tag : tags/amba.tag tags/macro.tag irqctrl.vhd
irqctrl : tags/irqctrl.tag
tags/ioport.tag : tags/amba.tag tags/macro.tag ioport.vhd
ioport : tags/ioport.tag
tags/timers.tag : tags/amba.tag tags/macro.tag timers.vhd
timers : tags/timers.tag
tags/uart.tag : tags/amba.tag tags/macro.tag uart.vhd
uart : tags/uart.tag
tags/mctrl.tag : tags/config.tag tags/amba.tag tags/macro.tag tags/ramlib.tag mctrl.vhd
mctrl : tags/mctrl.tag
tags/mcore.tag : tags/rstgen.tag tags/ambacomp.tag tags/irqctrl.tag tags/debug.tag \
  tags/ioport.tag tags/timers.tag tags/uart.tag tags/lconf.tag tags/clkgen.tag \
  tags/ahbarb.tag tags/apbmst.tag tags/proc.tag tags/mctrl.tag tags/wprot.tag \
  tags/ahbstat.tag tags/ahbtest.tag tags/pci_is.tag mcore.vhd
mcore : tags/mcore.tag
tags/leon.tag : tags/mcore.tag tags/padlib.tag leon.vhd
leon : tags/leon.tag

tags/leon_pci.tag : tags/leon.tag leon_pci.vhd
leon_pci : tags/leon_pci.tag

tags : 
	mkdir tags
work : 
	$(VLIB) work

clean:
	-rm -rf tags work *.tags vcx* trnscr* core vsim.wav

vhdl : $(SOURCES)


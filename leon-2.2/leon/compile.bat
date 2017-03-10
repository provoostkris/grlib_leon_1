vlib work
vcom -quiet amba.vhd 
vcom -quiet target.vhd device.vhd config.vhd sparcv8.vhd iface.vhd
vcom -quiet macro.vhd debug.vhd ambacomp.vhd
vcom -quiet tech_generic.vhd tech_synplify.vhd tech_atc35.vhd
vcom -quiet tech_virtex.vhd tech_leonardo.vhd bprom.vhd
vcom -quiet ramlib.vhd fpulib.vhd fp1eu.vhd
vcom -quiet clkgen.vhd rstgen.vhd iu.vhd regfile.vhd icache.vhd dcache.vhd
vcom -quiet cachemem.vhd acache.vhd cache.vhd proc.vhd
vcom -quiet apbmst.vhd ahbarb.vhd lconf.vhd wprot.vhd ahbtest.vhd ahbstat.vhd
vcom -quiet timers.vhd irqctrl.vhd uart.vhd ioport.vhd mctrl.vhd
vcom -quiet pci_is.vhd mcore.vhd
vcom -quiet padlib.vhd leon_pci.vhd leon.vhd


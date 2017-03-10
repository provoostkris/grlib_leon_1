
----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------
-- Entity: 	mcore
-- File:	mcore.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Module containing the processor, caches, memory controller
--	        and standard peripherals
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;
use work.ambacomp.all;
-- pragma translate_off
use work.debug.all;
-- pragma translate_on

entity mcore is
  port (
    resetn   : in  std_logic;
    clk      : in  std_logic;
    memi     : in  memory_in_type;
    memo     : out memory_out_type;
    ioi      : in  io_in_type;
    ioo      : out io_out_type;
    pcii     : in  pci_in_type;
    pcio     : out pci_out_type;

    test     : in    std_logic
  );
end; 

architecture rtl of mcore is

component clkgen 
port (
    clk    : in  std_logic;
    pciclk : in  std_logic;
    pcihost: in  std_logic;
    clki   : in  clkgen_in_type;
    clko   : out clkgen_out_type
);
end component;

component rstgen 
port (
    resetn : in  std_logic;
    pcirst : in  std_logic;
    clk    : in  clk_type;
    rst    : out rst_type
);
end component;


signal rst   : rst_type;
signal clko  : clkgen_out_type;
signal clki  : clkgen_in_type;
signal iui   : iu_in_type;
signal iuo   : iu_out_type;
signal ahbsto: ahbstat_out_type;
signal mctrlo: mctrl_out_type;
signal wpo   : wprot_out_type;
signal apbi  : apb_slv_in_vector(0 to APB_SLV_MAX-1);
signal apbo  : apb_slv_out_vector(0 to APB_SLV_MAX-1);
signal ahbmi : ahb_mst_in_vector(0 to AHB_MST_MAX-1);
signal ahbmo : ahb_mst_out_vector(0 to AHB_MST_MAX-1);
signal ahbsi : ahb_slv_in_vector(0 to AHB_SLV_MAX-1);
signal ahbso : ahb_slv_out_vector(0 to AHB_SLV_MAX-1);
signal pciresetn, pciirq : std_logic;

signal irqi   : irq_in_type;
signal irqo   : irq_out_type;
signal timo   : timers_out_type;
signal pioo   : pio_out_type;
signal uart1i, uart2i  : uart_in_type;
signal uart1o, uart2o  : uart_out_type;

begin

-- reset generator

  reset0 : rstgen port map (resetn, pciresetn, clko.clk, rst);

-- clock generator

  clkgen0 : clkgen port map (clk, pcii.pci_clk_in, pcii.pci_host, clki, clko);

----------------------------------------------------------------------
-- AHB bus                                                          --
----------------------------------------------------------------------

-- AHB arbiter/decoder

  ahb0 : ahbarb 
	 generic map (masters => AHB_MASTERS, defmast => AHB_DEFMST)
	 port map (rst.syncrst, clko.clk, ahbmi(0 to AHB_MASTERS-1), 
	      ahbmo(0 to AHB_MASTERS-1), ahbsi, ahbso);

-- AHB/APB bridge

  apb0 : apbmst
	 port map (rst.syncrst, clko.clk, ahbsi(1), ahbso(1), apbi, apbo);

-- processor and cache sub-system

  proc0 : proc port map (
	rst.syncrst, clki, clko, apbi(2), apbo(2), ahbmi(0), ahbmo(0), iui, iuo);

-- memory controller

  mctrl0 : mctrl port map (
	rst => rst, clk=> clko.clk, memi => memi, memo => memo,
	ahbsi => ahbsi(0), ahbso => ahbso(0), apbi => apbi(0), apbo => apbo(0), 
	pioo => pioo, wpo => wpo, mctrlo => mctrlo);

-- AHB write protection

  wp0 : if WPROTEN generate
    wpm :  wprot port map ( 
	rst => rst, clk => clko.clk, wpo => wpo,  ahbsi => ahbsi(0), 
	apbi => apbi(3), apbo => apbo(3));
  end generate;
  wp1 : if not WPROTEN generate apbo(3).prdata <= (others => '0'); end generate;

-- AHB status register

  as0 : if AHBSTATEN generate
    asm :  ahbstat port map ( 
	rst => rst, clk => clko.clk, ahbmi => ahbmi(0), ahbsi => ahbsi(0), 
	apbi => apbi(1), apbo => apbo(1), ahbsto => ahbsto);
  end generate;
  as1 : if not AHBSTATEN generate 
    apbo(1).prdata <= (others => '0'); ahbsto.ahberr <= '0';
  end generate;

-- AHB test module

  ahbt : if PCICORE = ahbtst generate
    a0 : ahbtest port map ( rst => rst.syncrst, clk => clko.clk, 
	ahbi => ahbsi(2), ahbo => ahbso(2)
    );
    pci0 : pci_is 
      port map (
      rst => rst.syncrst, app_clk => clko.clk, cfg_clk  => clko.clk,
      pbi => apbi(10), pbo => apbo(10), irq => pciirq,
      TargetMasterOut => ahbmo(1), TargetMasterIn  => ahbmi(1),
      pci_in => pcii, pci_out => pcio,
      MasterSlaveOut => ahbso(3), MasterSlaveIn  => ahbsi(3),
      MasterMasterOut => ahbmo(2), MasterMasterIn => ahbmi(2)
      );
    pciresetn <= '1';
  end generate;

-- Optional InSilicon PCI core

  pci_is0 : if PCICORE = insilicon generate
    pci0 : pci_is 
      port map (
      rst => rst.syncrst, app_clk => clko.clk, cfg_clk  => clko.clk,
      pbi => apbi(10), pbo => apbo(10), irq => pciirq,
      TargetMasterOut => ahbmo(1), TargetMasterIn  => ahbmi(1),
      pci_in => pcii, pci_out => pcio,
      MasterSlaveOut => ahbso(2), MasterSlaveIn  => ahbsi(2),
      MasterMasterOut => ahbmo(2), MasterMasterIn => ahbmi(2)
      );
    pciresetn <= pcii.pci_rst_in_n;
  end generate;

  pr0 : if not PCIEN generate pciirq <= '0'; pciresetn <= '0'; end generate;

-- drive unused part of the AHB bus to stop some stupid synthesis tools
-- from inserting tri-state buffers (!)

  ahbdrv : for i in 0 to AHB_SLV_MAX-1 generate
    u0 : if not AHB_SLVTABLE(i).enable generate
        ahbso(i).hready <= '-'; ahbso(i).hresp  <= "--";
        ahbso(i).hrdata <= (others => '-'); ahbso(i).hsplit <= (others => '-');       
    end generate;
  end generate;

----------------------------------------------------------------------
-- APB bus                                                          --
----------------------------------------------------------------------

-- LEON configuration register

  lc0 : if CFGREG generate
    lcm : lconf port map (rst => rst, apbo => apbo(4));
  end generate;

-- timers (and watchdog)

  timers0 : timers 
  port map (rst => rst.syncrst, clk => clk, apbi => apbi(5), apbo => apbo(5), 
	     timo => timo);

-- UARTS
-- This stupidity exists because synopsys DC is not capable of
-- handling record elements in port maps. Sad really ...

  uart1i.rxd     <= pioo.rxd(0); uart1i.ctsn    <= pioo.ctsn(0);
  uart2i.rxd     <= pioo.rxd(1); uart2i.ctsn    <= pioo.ctsn(1);
  uart1i.scaler  <= pioo.io8lsb; uart2i.scaler  <= pioo.io8lsb;

  uart1 : uart port map ( 
    rst => rst.syncrst, clk => clk, apbi => apbi(6), apbo => apbo(6), 
    uarti => uart1i, uarto => uart1o);
      
  uart2 : uart port map ( 
    rst => rst.syncrst, clk => clk, apbi => apbi(7), apbo => apbo(7), 
    uarti => uart2i, uarto => uart2o);
      
-- interrupt controller

  irqctrl0 : irqctrl 
  port map (rst  => rst.syncrst, clk  => clk, apbi => apbi(8), apbo => apbo(8),
      	     irqi => irqi, irqo => irqo);
  irqi.intack <= iuo.intack; irqi.irl <= iuo.irqvec; iui.irl <= irqo.irl;    

-- parallel I/O port

  ioport0 : ioport 
  port map (rst => rst, clk  => clk, apbi => apbi(9), apbo => apbo(9),
            uart1o => uart1o, uart2o => uart2o, mctrlo => mctrlo,
	    ioi => ioi, pioo => pioo);

-- drive unused part of the APB bus to stop some stupid synthesis tools
-- from inserting tri-state buffers (!)

  apbdrv : for i in 0 to APB_SLV_MAX-1 generate
    u0 : if not APB_TABLE(i).enable generate
	apbo(i).prdata <= (others => '-');
    end generate;
  end generate;

-- IRQ assignments, add you mapping below

  irqi.irq(15) <= '0';             -- unmaskable irq
  irqi.irq(14) <= pciirq;
  irqi.irq(13 downto 10) <= (others => '0'); -- unassigned irqs
  irqi.irq(9) <=  timo.irq(1);		     -- timer 2
  irqi.irq(8) <=  timo.irq(0);		     -- timer 1
  irqi.irq(7 downto 4) <= pioo.irq;	     -- I/O port interrupts
  irqi.irq(3) <= uart1o.irq;		     -- UART 1
  irqi.irq(2) <= uart2o.irq;		     -- UART 2
  irqi.irq(1) <= ahbsto.ahberr;		     -- AHB error

-- drive outputs

  ioo.piol      <= pioo.piol(15 downto 0);
  ioo.piodir    <= pioo.piodir(15 downto 0);
  ioo.wdog      <= timo.wdog;
  ioo.errorn    <= iuo.error;



-- disassambler

-- pragma translate_off
  trace0 : trace(iuo.debug, (test = '1'));
-- pragma translate_on


end ;



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
-- Entity: 	leon_pci
-- File:	leon_pci.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Complete processor with PCI pads
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.padlib.all;
-- pragma translate_off
use work.debug.all;
-- pragma translate_on

entity leon_pci is
  port (
    resetn   : in    std_logic; 			-- system signals
    clk      : in    std_logic;

    errorn   : out   std_logic;
    address  : out   std_logic_vector(27 downto 0); 	-- memory bus

    data     : inout std_logic_vector(31 downto 0);

    ramsn    : out   std_logic_vector(3 downto 0);
    ramoen   : out   std_logic_vector(3 downto 0);
    rwen     : inout std_logic_vector(3 downto 0);
    romsn    : out   std_logic_vector(1 downto 0);
    iosn     : out   std_logic;
    oen      : out   std_logic;
    read     : out   std_logic;
    writen   : inout std_logic;

    brdyn    : in    std_logic;
    bexcn    : in    std_logic;

    pio      : inout std_logic_vector(15 downto 0); 	-- I/O port

    wdogn    : out   std_logic;				-- watchdog output

    test     : in    std_logic;

    pci_rst_in_n   : in std_logic;		-- PCI bus
    pci_clk_in 	   : in std_logic;
    pci_gnt_in_n   : in std_logic;
    pci_idsel_in   : in std_logic;  -- ignored in host bridge core
    pci_lock_in_n  : in std_logic;  -- Phoenix core: input only
    pci_ad 	   : inout std_logic_vector(31 downto 0);
    pci_cbe_n 	   : inout std_logic_vector(3 downto 0);
    pci_frame_n    : inout std_logic;
    pci_irdy_n 	   : inout std_logic;
    pci_trdy_n 	   : inout std_logic;
    pci_devsel_n   : inout std_logic;
    pci_stop_n 	   : inout std_logic;
    pci_perr_n 	   : inout std_logic;
    pci_par 	   : inout std_logic;    
    pci_req_n 	   : inout std_logic;  -- tristate pad but never read
    pci_serr_n     : inout std_logic;  -- open drain output
    pci_host   	   : in std_logic

  );
end; 

architecture rtl of leon_pci is

component mcore
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
end component; 

signal gnd, clko, resetno : std_logic;
signal memi     : memory_in_type;
signal memo     : memory_out_type;
signal ioi      : io_in_type;
signal ioo      : io_out_type;
signal pcii     : pci_in_type;
signal pcio     : pci_out_type;


signal pci_aden   : std_logic_vector(31 downto 0);
signal pci_cbeen   : std_logic_vector(3 downto 0);
signal pci_frame_en   : std_logic;
signal pci_irdy_en   : std_logic;
signal pci_ctrl_en   : std_logic;
signal pci_perr_en   : std_logic;
signal pci_par_en   : std_logic;
signal pci_req_en   : std_logic;
signal pci_req_in_dummy : std_logic;


begin

  gnd <= '0';

-- main processor core

  mcore0  : mcore  
  port map ( 
    resetn => resetno, clk => clko, 
    memi => memi, memo => memo, ioi => ioi, ioo => ioo,
    pcii => pcii, pcio => pcio, test => test

  );

-- pads

--  inpad0   : inpad port map (clk, clko);	-- clock
  clko <= clk;					-- avoid buffering during synthesis
  smpad0   : smpad port map (resetn, resetno);	-- reset

  inpad2   : inpad port map (brdyn, memi.brdyn);	-- bus ready
  inpad3   : inpad port map (bexcn, memi.bexcn);	-- bus exception



    outpad0   : odpad port map (ioo.errorn, errorn);	-- cpu error mode

    iopadb0: for i in 24 to 31 generate			-- data bus
      iopadb01: iopad3 port map (memo.data(i), memo.bdrive(0), memi.data(i), data(i));
    end generate;

    iopadb1: for i in 16 to 23 generate
      iopadb11: iopad3 port map (memo.data(i), memo.bdrive(1), memi.data(i), data(i));
    end generate;

    iopadb2: for i in 8 to 15 generate
      iopadb21: iopad3 port map (memo.data(i), memo.bdrive(2), memi.data(i), data(i));
    end generate;

    iopadb3: for i in 0 to 7 generate
      iopadb31: iopad3 port map (memo.data(i), memo.bdrive(3), memi.data(i), data(i));
    end generate;


    iopadb5: for i in 0 to 15 generate		-- parallel I/O port
      iopadb51: smiopad port map (ioo.piol(i), ioo.piodir(i), ioi.piol(i), pio(i));
    end generate;

    iopadb7: for i in 0 to 3 generate			-- ram write strobe
      iopadb71: iopad2 port map (memo.wrn(i), gnd, memi.wrn(i), rwen(i));
    end generate;

     							-- I/O write strobe
    iopadb8: iopad2 port map (memo.writen, gnd, memi.writen, writen);

    outpadb0: for i in 0 to 27 generate			-- memory address
      outpadb01: outpad3 port map (memo.address(i), address(i));
    end generate;

    outpadb1: for i in 0 to 3 generate			-- ram oen/rasn
      outpadb11: outpad2 port map (memo.ramsn(i), ramsn(i));
    end generate;

    outpadb2: for i in 0 to 3 generate			-- ram chip select
      outpadb21: outpad2 port map (memo.ramoen(i), ramoen(i));
    end generate;

    outpadb3: for i in 0 to 1 generate			-- rom chip select
      outpadb31: outpad2 port map (memo.romsn(i), romsn(i));
    end generate;

    outpadb4: outpad2 port map (memo.read, read);	-- memory read
    outpadb5: outpad2 port map (memo.oen, oen);	-- memory oen
    outpadb6: outpad2 port map (memo.iosn, iosn);	-- I/O select

    wd : if WDOGEN generate
      outpadb7: odpad port map (ioo.wdog, wdogn);	-- watchdog output
    end generate;



    -- Phoenix core delivers active low!
      pcictrl0 : if PCICORE = insilicon generate
        pci_aden     <= (pcio.pci_aden_n);
        pci_cbeen(0) <= (pcio.pci_cbe0_en_n);
        pci_cbeen(1) <= (pcio.pci_cbe1_en_n);
        pci_cbeen(2) <= (pcio.pci_cbe2_en_n);
        pci_cbeen(3) <= (pcio.pci_cbe3_en_n);
        pci_frame_en <= (pcio.pci_frame_en_n);
        pci_irdy_en  <= (pcio.pci_irdy_en_n);
        pci_ctrl_en  <= (pcio.pci_ctrl_en_n);
        pci_perr_en  <= (pcio.pci_perr_en_n);
        pci_par_en   <= (pcio.pci_par_en_n);
        pci_req_en   <= (pcio.pci_req_en_n);
      end generate;
    
      pcictrl1 : if PCICORE /= insilicon generate
        pci_aden     <= not (pcio.pci_aden_n);
        pci_cbeen(0) <= not (pcio.pci_cbe0_en_n);
        pci_cbeen(1) <= not (pcio.pci_cbe1_en_n);
        pci_cbeen(2) <= not (pcio.pci_cbe2_en_n);
        pci_cbeen(3) <= not (pcio.pci_cbe3_en_n);
        pci_frame_en <= not (pcio.pci_frame_en_n);
        pci_irdy_en  <= not (pcio.pci_irdy_en_n);
        pci_ctrl_en  <= not (pcio.pci_ctrl_en_n);
        pci_perr_en  <= not (pcio.pci_perr_en_n);
        pci_par_en   <= not (pcio.pci_par_en_n);
        pci_req_en   <= not (pcio.pci_req_en_n);
      end generate;
    
      pci_rst_in_n_pad : inpad port map(pci_rst_in_n, pcii.pci_rst_in_n);
      pci_clk_in_pad : inpad port map(pci_clk_in, pcii.pci_clk_in);
      pci_gnt_in_n_pad : inpad port map(pci_gnt_in_n, pcii.pci_gnt_in_n);
      pci_idsel_in_pad : inpad port map(pci_idsel_in, pcii.pci_idsel_in);  -- ignored in host bridge core
      pci_lock_in_n_pad : inpad port map(pci_lock_in_n, pcii.pci_lock_in_n);  -- Phoenix core: input only

      pci_ad_pads : for i in 0 to 31 generate
	pci_adio_pad : iopad3
	    port map(pcio.pci_adout(i), pci_aden(i), pcii.pci_adin(i), pci_ad(i));  
      end generate pci_ad_pads;

      pci_cbe_n_pads : for i in 0 to 3 generate
	pci_cbeio_n_pad : iopad3
	    port map(pcio.pci_cbeout_n(i), pci_cbeen(i), pcii.pci_cbein_n(i), pci_cbe_n(i));
      end generate pci_cbe_n_pads;

      pci_frame_io_n_pad : iopad3 port map
	(pcio.pci_frame_out_n, pci_frame_en, pcii.pci_frame_in_n, pci_frame_n);

      pci_irdy_io_n_pad : iopad3 port map
	(pcio.pci_irdy_out_n, pci_irdy_en, pcii.pci_irdy_in_n, pci_irdy_n);

    -- the following 3 pads have common enable pci_ctrl_en_n
      pci_trdy_io_n_pad : iopad3 port map
	(pcio.pci_trdy_out_n, pci_ctrl_en, pcii.pci_trdy_in_n, pci_trdy_n);
      pci_devsel_io_n_pad : iopad3 port map
	(pcio.pci_devsel_out_n, pci_ctrl_en, pcii.pci_devsel_in_n, pci_devsel_n);
      pci_stop_io_n_pad : iopad3 port map
	(pcio.pci_stop_out_n, pci_ctrl_en, pcii.pci_stop_in_n, pci_stop_n);
    
      pci_perr_io_n_pad : iopad3 port map
	(pcio.pci_perr_out_n, pci_perr_en, pcii.pci_perr_in_n, pci_perr_n);

      pci_par_io_pad : iopad3 port map
	(pcio.pci_par_out, pci_par_en, pcii.pci_par_in, pci_par);    

      pci_req_io_n_pad : iopad3 port map  	-- tristate pad but never read
	(pcio.pci_req_out_n, pci_req_en, pci_req_in_dummy, pci_req_n);

    -- open drain output
      pci_serr_n_pad   : iodpad port map (pcio.pci_serr_out_n, pcii.pci_serr_in_n, pci_serr_n);

    -- PCI host select
      pci_host_pad : inpad port map (pci_host, pcii.pci_host);	


end ;


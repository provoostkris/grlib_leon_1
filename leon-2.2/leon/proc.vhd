
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
-- Entity: 	proc
-- File:	proc.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	This unit contains the integer unit, cache memory,
--		clock/reset generation and (optinally) FPU.
------------------------------------------------------------------------------
-- Version control:
-- 11-9-1998:	First implemetation
-- 26-9-1999:	Release 1.0
------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;
use work.fpulib.all;

entity proc is
  port (
    rst    : in  std_logic;
    clki   : out clkgen_in_type;
    clko   : in  clkgen_out_type;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    ahbi   : in  ahb_mst_in_type;
    ahbo   : out ahb_mst_out_type;
    iui    : in  iu_in_type;
    iuo    : out iu_out_type
  );
end; 

architecture rtl of proc is

component iu
port (
    rst    : in  std_logic;			-- Reset
    clk    : in  clk_type;		
    iclk   : in  clk_type;		
    dclk   : in  clk_type;		
    holdn  : in  std_logic;		
    ici    : out icache_in_type;
    ico    : in  icache_out_type;
    dci    : out dcache_in_type;
    dco    : in  dcache_out_type;
    rfi    : out rf_in_type;			-- register-file input
    rfo    : in  rf_out_type;			-- register-file output
    fpui   : out fpu_in_type;
    fpuo   : in  fpu_out_type;
    iui    : in  iu_in_type;
    iuo    : out iu_out_type;			-- system output
    cpi    : out cp_in_type;			-- CP input
    cpo    : in  cp_out_type;			-- CP output
    fpi    : out cp_in_type;			-- FP input
    fpo    : in  cp_out_type			-- FP output
  );
end component;

component regfile
  port (
    clk   : in  clk_type;                       -- Clock
    holdn : in  std_logic;
    rfi   : in  rf_in_type;
    rfo   : out rf_out_type
  );
end component;

component cache
  port (
    rst   : in  std_logic;
    clk   : in  clk_type;
    ici   : in  icache_in_type;
    ico   : out icache_out_type;
    dci   : in  dcache_in_type;
    dco   : out dcache_out_type;
    mcii  : out memory_ic_in_type;
    mcio  : in  memory_ic_out_type;
    mcdi  : out memory_dc_in_type;
    mcdo  : in  memory_dc_out_type;
    fpuholdn : in  std_logic
  );
end component; 

component cp
port (
    rst    : in  std_logic;			-- Reset
    clk    : in  clk_type;			-- main clock	
    iuclk  : in  clk_type;			-- gated IU clock
    holdn  : in  std_logic;			-- pipeline hold
    cpi    : in  cp_in_type;
    cpo    : out cp_out_type
  );
end component;

component fp
port (
    rst    : in  std_logic;			-- Reset
    clk    : in  clk_type;			-- main clock	
    iuclk  : in  clk_type;			-- gated IU clock
    holdn  : in  std_logic;			-- pipeline hold
    xholdn : in  std_logic;			-- pipeline hold
    cpi    : in  cp_in_type;
    cpo    : out cp_out_type
  );
end component;

component fp1eu
port (
    rst    : in  std_logic;			-- Reset
    clk    : in  clk_type;			-- main clock	
    iuclk  : in  clk_type;			-- gated IU clock
    holdn  : in  std_logic;			-- pipeline hold
    xholdn : in  std_logic;			-- pipeline hold
    cpi    : in  cp_in_type;
    cpo    : out cp_out_type
  );
end component;

component acache
  port (
    rst    : in  std_logic;
    clk    : in  clk_type;
    mcii   : in  memory_ic_in_type;
    mcio   : out memory_ic_out_type;
    mcdi   : in  memory_dc_in_type;
    mcdo   : out memory_dc_out_type;
    iui    : in  iu_in_type;
    iuo    : in  iu_out_type;		
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    ahbi   : in  ahb_mst_in_type;
    ahbo   : out ahb_mst_out_type
  );
end component;

signal ici : icache_in_type;
signal ico : icache_out_type;
signal dci : dcache_in_type;
signal dco : dcache_out_type;

signal rfi : rf_in_type;			-- register-file input
signal rfo : rf_out_type;			-- register-file output
signal fpui : fpu_in_type;
signal fpuo : fpu_out_type;
signal cpi, fpi : cp_in_type;
signal cpo, fpo : cp_out_type;
signal pholdn, xholdn : std_logic;
signal mcii : memory_ic_in_type;
signal mcio : memory_ic_out_type;
signal mcdi : memory_dc_in_type;
signal mcdo : memory_dc_out_type;
signal iuol : iu_out_type;		
 
begin

  clki.iholdn <= ico.hold;
  clki.imdsn  <= ico.mds;
  clki.dholdn <= dco.hold;
  clki.dmdsn  <= dco.mds;
  clki.fpuholdn <= fpui.fpuholdn and cpo.holdn and fpo.holdn;
  pholdn <= fpui.fpuholdn and cpo.holdn and fpo.holdn;
  xholdn <= cpo.holdn and dco.hold and ico.hold;
  iuo <= iuol;

-- processor core

  iu0 : iu  port map (rst, clko.iuclk, clko.iclk, clko.dclk, clko.holdn, 
		      ici, ico, dci, dco, rfi, rfo, fpui, fpuo, 
			iui, iuol, cpi, cpo, fpi, fpo
  );

-- register file

  regfile0 : regfile port map (clko.rfclk, clko.holdn, rfi, rfo);

-- cache memory

  c0 : cache port map (rst, clko.clk, ici, ico, dci, dco, mcii, mcio, 
		       mcdi, mcdo, pholdn);

  a0 : acache port map (rst, clko.clk, mcii, mcio, mcdi, mcdo, iui, iuol, 
			apbi, apbo, ahbi, ahbo);

-- FPU (optional)

  fpopt : if FPEN and (FPTYPE = meiko) generate

    fpu0 : fpu port map (
    ss_clock   => clko.clk,
    FpInst     => fpui.FpInst, 
    FpOp       => fpui.fpop, 
    FpLd       => fpui.FpLd, 
    Reset      => fpui.reset, 
    fprf_dout1 => fpui.fprf_dout1, 
    fprf_dout2 => fpui.fprf_dout2, 
    RoundingMode => fpui.RoundingMode, 
    FpBusy    => fpuo.FpBusy,
    FracResult => fpuo.FracResult,
    ExpResult  => fpuo.ExpResult,
    SignResult => fpuo.SignResult,
    SNnotDB    => fpuo.SNnotDB,
    Excep      => fpuo.Excep,
    ConditionCodes => fpuo.ConditionCodes,
    ss_scan_mode => fpui.ss_scan_mode,
    fp_ctl_scan_in => fpui.fp_ctl_scan_in,
    fp_ctl_scan_out => fpuo.fp_ctl_scan_out
   );

  end generate;

-- external floating-point co-processor (optional)

  fpcopt : if (FPTYPE = fpc) generate
--    fp0 : fp port map (rst, clko.clk, clko.iuclk, clko.holdn, xholdn, fpi, fpo);
    fp0 : fp1eu port map (rst, clko.clk, clko.iuclk, clko.holdn, xholdn, fpi, fpo);
  end generate;

  nofpc : if (FPTYPE /= fpc) generate
    fpo.holdn <= '1';
    fpo.ldlock <= '0';
    fpo.ccv <= '1';
  end generate;

-- co-processor (optional)

  cpopt : if CPEN generate
--    cp0 : cp port map (rst, clko.clk, clko.iuclk, clko.holdn, cpi, cpo);
    cp0 : fp1eu port map (rst, clko.clk, clko.iuclk, clko.holdn, xholdn, cpi, cpo);
  end generate;

  nocp : if not CPEN generate
    cpo.holdn <= '1';
    cpo.ldlock <= '0';
  end generate;
end ;


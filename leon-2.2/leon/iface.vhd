
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
-- Entity:      iface
-- File:        iface.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Package with type declarations for module interconnections
------------------------------------------------------------------------------
  
library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.sparcv8.all;

package iface is


subtype clk_type is std_logic;


------------------------------------------------------------------------------
-- Add I/Os for custom peripherals in the records below
------------------------------------------------------------------------------
-- peripheral inputs
type io_in_type is record
  piol             : std_logic_vector(15 downto 0); -- I/O port inputs
end record;
-- peripheral outputs
type io_out_type is record
  piol             : std_logic_vector(15 downto 0); -- I/O port outputs
  piodir           : std_logic_vector(15 downto 0); -- I/O port direction
  errorn  : std_logic;				    -- CPU in error mode
  wdog 	  : std_logic;				    -- watchdog output

end record;
------------------------------------------------------------------------------

-- register file inputs

type rf_in_type is record
  rd1addr 	: std_logic_vector(RABITS-1 downto 0); -- read address 1
  rd2addr 	: std_logic_vector(RABITS-1 downto 0); -- read address 2
  wraddr 	: std_logic_vector(RABITS-1 downto 0); -- write address
  wrdata 	: std_logic_vector(RDBITS-1 downto 0);     -- write data
  wren          : std_logic;			     -- write enable

end record;

-- instruction cache diagnostic access inputs

type icdiag_in_type is record
  addr             : std_logic_vector(31 downto 0); -- memory stage address
  enable           : std_logic;
  read             : std_logic;
  tag              : std_logic;
  flush            : std_logic;

end record;

-- data cache controller inputs

type dcache_in_type is record
  asi              : std_logic_vector(7 downto 0); -- ASI for load/store
  maddress         : std_logic_vector(31 downto 0); -- memory stage address
  eaddress         : std_logic_vector(31 downto 0); -- execute stage address
  edata            : std_logic_vector(31 downto 0); -- execute stage data
  size             : std_logic_vector(1 downto 0);
  signed           : std_logic;
  enaddr           : std_logic;
  eenaddr          : std_logic;
  nullify          : std_logic;
  lock             : std_logic;
  read             : std_logic;
  write            : std_logic;
  flush            : std_logic;

end record;

-- data cache controller outputs

type dcache_out_type is record
  data             : std_logic_vector(31 downto 0); -- Data bus address
  mexc             : std_logic;		-- memory exception
  hold             : std_logic;
  mds              : std_logic;
  werr             : std_logic;		-- memory write error
  icdiag           : icdiag_in_type;
  cache            : std_logic;		-- cacheable data
end record;

type icache_in_type is record
  rpc              : std_logic_vector(31 downto PCLOW); -- raw address (npc)
  fpc              : std_logic_vector(31 downto PCLOW); -- latched address (fpc)
  dpc              : std_logic_vector(31 downto PCLOW); -- latched address (dpc)
  rbranch          : std_logic;			-- Instruction branch
  fbranch          : std_logic;			-- Instruction branch
  nullify          : std_logic;			-- instruction nullify
  su               : std_logic;			-- super-user
  flush            : std_logic;			-- flush icache
end record;

type icache_out_type is record
  data             : std_logic_vector(31 downto 0);
  exception        : std_logic;
  hold             : std_logic;
  flush            : std_logic;			-- flush in progress
  diagrdy          : std_logic;			-- diagnostic access ready
  diagdata         : std_logic_vector(31 downto 0); -- diagnostic data
  mds              : std_logic;			-- memory data strobe
  cache            : std_logic;		-- cacheable data
end record;

type rf_out_type is record
  data1    	: std_logic_vector(RDBITS-1 downto 0); -- read data 1
  data2    	: std_logic_vector(RDBITS-1 downto 0); -- read data 2
end record;

type memory_ic_in_type is record
  address          : std_logic_vector(31 downto 0); -- memory address
  burst            : std_logic;			-- burst request
  req              : std_logic;			-- memory cycle request
  su               : std_logic;			-- supervisor address space
  flush            : std_logic;			-- flush in progress

end record;

type memory_ic_out_type is record
  data             : std_logic_vector(31 downto 0); -- memory data
  ready            : std_logic;			    -- cycle ready
  grant            : std_logic;			    -- 
  retry            : std_logic;			    -- 
  mexc             : std_logic;			    -- memory exception
  burst            : std_logic;			    -- memory burst enable
  ics              : std_logic_vector(1 downto 0); -- icache state (from CCR)
  cache            : std_logic;		-- cacheable data

end record;

type memory_dc_in_type is record
  address          : std_logic_vector(31 downto 0); 
  data             : std_logic_vector(31 downto 0);
  asi              : std_logic_vector(3 downto 0);
  size             : std_logic_vector(1 downto 0);
  burst            : std_logic;
  read             : std_logic;
  req              : std_logic;
  flush            : std_logic;			-- flush in progress
  lock             : std_logic;

end record;

type memory_dc_out_type is record
  data             : std_logic_vector(31 downto 0); -- memory data
  ready            : std_logic;			    -- cycle ready
  grant            : std_logic;			    -- 
  retry            : std_logic;			    -- 
  mexc             : std_logic;			    -- memory exception
  werr             : std_logic;			    -- memory write error
  dcs              : std_logic_vector(1 downto 0);
  cache            : std_logic;		-- cacheable data

end record;

type memory_in_type is record
  data             : std_logic_vector(31 downto 0); -- Data bus address
  brdyn            : std_logic;
  bexcn            : std_logic;
  writen           : std_logic;
  wrn              : std_logic_vector(3 downto 0);

end record;

type memory_out_type is record
  address          : std_logic_vector(27 downto 0);
  data             : std_logic_vector(31 downto 0);

  ramsn            : std_logic_vector(3 downto 0);
  ramoen           : std_logic_vector(3 downto 0); 
  iosn             : std_logic;
  romsn            : std_logic_vector(1 downto 0);
  oen              : std_logic;
  writen           : std_logic;
  wrn              : std_logic_vector(3 downto 0);
  bdrive           : std_logic_vector(3 downto 0);
  read             : std_logic;
end record;

type pio_in_type is record
  piol             : std_logic_vector(15 downto 0);
  pioh             : std_logic_vector(15 downto 0);
end record;

type pio_out_type is record
  irq              : std_logic_vector(3 downto 0);
  piol             : std_logic_vector(15 downto 0);
  piodir           : std_logic_vector(15 downto 0);
  io8lsb           : std_logic_vector(7 downto 0);
  rxd              : std_logic_vector(1 downto 0);
  ctsn   	   : std_logic_vector(1 downto 0);
end record;

type wprot_out_type is record
  wprothit          : std_logic;
end record;

type ahbstat_out_type is record
  ahberr           : std_logic;
end record;

type mctrl_out_type is record
  pioh             : std_logic_vector(15 downto 0);

end record;


type itram_in_type is record
  tag    	: std_logic_vector(ITAG_BITS - ILINE_SIZE - 1 downto 0);
  valid  	: std_logic_vector(ILINE_SIZE -1 downto 0);
  enable	: std_logic;
  write		: std_logic;

end record;

type itram_out_type is record
  tag    	: std_logic_vector(ITAG_BITS - ILINE_SIZE -1 downto 0);
  valid  	: std_logic_vector(ILINE_SIZE -1 downto 0);

end record;

type idram_in_type is record
  address	: std_logic_vector((IOFFSET_BITS + ILINE_BITS -1) downto 0);
  data   	: std_logic_vector(31 downto 0);
  enable	: std_logic;
  write		: std_logic;

end record;

type idram_out_type is record
  data   	: std_logic_vector(31 downto 0);

end record;

type dtram_in_type is record
  tag    	: std_logic_vector(DTAG_BITS - DLINE_SIZE - 1 downto 0);
  valid  	: std_logic_vector(DLINE_SIZE -1 downto 0);
  enable	: std_logic;
  write		: std_logic;

end record;

type dtram_out_type is record
  tag    	: std_logic_vector(DTAG_BITS - DLINE_SIZE -1 downto 0);
  valid  	: std_logic_vector(DLINE_SIZE -1 downto 0);

end record;

type ddram_in_type is record
  address	: std_logic_vector((DOFFSET_BITS + DLINE_BITS -1) downto 0);
  data   	: std_logic_vector(31 downto 0);
  enable	: std_logic;
  write		: std_logic;

end record;

type ddram_out_type is record
  data   	: std_logic_vector(31 downto 0);

end record;

type icram_in_type is record
  itramin	: itram_in_type;
  idramin	: idram_in_type;
end record;

type icram_out_type is record
  itramout	: itram_out_type;
  idramout	: idram_out_type;
end record;

type dcram_in_type is record
  dtramin	: dtram_in_type;
  ddramin	: ddram_in_type;
end record;

type dcram_out_type is record
  dtramout	: dtram_out_type;
  ddramout	: ddram_out_type;
end record;

type cram_in_type is record
  icramin	: icram_in_type;
  dcramin	: dcram_in_type;
end record;

type cram_out_type is record
  icramout	: icram_out_type;
  dcramout	: dcram_out_type;
end record;

type irq_in_type is record
  irq		: std_logic_vector(15 downto 1);
  intack	: std_logic;
  irl		: std_logic_vector(3 downto 0);
end record;

type irq_out_type is record
  irl   	: std_logic_vector(3 downto 0);
end record;

type timers_out_type is record
  irq   	: std_logic_vector(1 downto 0);
  tick 		: std_logic;
  wdog 		: std_logic;
end record;

type uart_in_type is record
  rxd   	: std_logic;
  ctsn   	: std_logic;
  scaler	: std_logic_vector(7 downto 0);
end record;

type uart_out_type is record
  rxen    	: std_logic;
  txen    	: std_logic;
  flow   	: std_logic;
  irq   	: std_logic;
  rtsn   	: std_logic;
  txd   	: std_logic;
end record;

type clkgen_in_type is record
  iholdn 	: std_logic;			-- Instruction hold
  imdsn  	: std_logic;			-- Instruction memory data strobe
  dholdn 	: std_logic;			-- Data hold
  dmdsn  	: std_logic;			-- Data memory data strobe
  fpuholdn	: std_logic;			-- FPU/CP busy
end record;

type clkgen_out_type is record
  clk    	: clk_type;			-- Common clock
  iuclk 	: clk_type;			-- Processor clock
  dclk   	: clk_type;			-- Data latch clock
  iclk   	: clk_type;			-- Instruction latch clock
  rfclk  	: clk_type;			-- register file clock
  pciclk 	: clk_type;			-- PCI config-block clock
  holdn  	: std_logic;			-- Instruction latch clock
end record;

-- iu pipeline control type (defined here to be visible to debug and coprocessor)

type pipeline_control_type is record
  inst   : std_logic_vector(31 downto 0);     -- instruction word
  pc     : std_logic_vector(31 downto PCLOW);     -- program counter
  annul  : std_logic;			      -- instruction annul
  cnt    : std_logic_vector(1 downto 0);      -- cycle number (multi-cycle inst)
  ld     : std_logic;			      -- load cycle
  pv     : std_logic;			      -- PC valid
  rett   : std_logic;			      -- RETT indicator
  trap   : std_logic;			      -- trap pending flag
  tt     : std_logic_vector(5 downto 0);      -- trap type
  rd     : std_logic_vector(RABITS-1 downto 0); -- destination register address
end record;
  
-- Stucture for FPU/CP control
type cp_in_type is record
  flush  	: std_logic;			  -- pipeline flush
  exack    	: std_logic;			  -- CP exception acknowledge
  dannul   	: std_logic;			  -- decode stage annul
  dtrap    	: std_logic;			  -- decode stage trap
  dcnt          : std_logic_vector(1 downto 0);     -- decode stage cycle counter
  dinst         : std_logic_vector(31 downto 0);     -- decode stage instruction
  ex       	: pipeline_control_type;	  -- iu pipeline ctrl (ex)
  me       	: pipeline_control_type;	  -- iu pipeline ctrl (me)
  wr       	: pipeline_control_type;	  -- iu pipeline ctrl (wr)
  lddata        : std_logic_vector(31 downto 0);     -- load data
end record;

type cp_out_type is record
  data          : std_logic_vector(31 downto 0); -- store data
  exc  	        : std_logic;			 -- CP exception
  cc            : std_logic_vector(1 downto 0);  -- CP condition codes
  ccv  	        : std_logic;			 -- CP condition codes valid
  holdn	        : std_logic;			 -- CP pipeline hold
  ldlock        : std_logic;			 -- CP load/store interlock
end record;


-- iu debug port

type iu_debug_type is record
  clk   : std_logic;
  rst   : std_logic;
  holdn : std_logic;
  de	: pipeline_control_type;
  ex	: pipeline_control_type;
  me	: pipeline_control_type;
  wr	: pipeline_control_type;
  write_reg  : std_logic;
  result     : std_logic_vector(31 downto 0);
  trap  : std_logic;
  tt    : std_logic_vector(7 downto 0);

end record;

type iu_in_type is record
  irl              : std_logic_vector(3 downto 0); -- interrupt request level
end record;

type iu_out_type is record
  error   : std_logic;
  intack  : std_logic;
  irqvec  : std_logic_vector(3 downto 0);
  ipend   : std_logic;
-- pragma translate_off
  debug	  : iu_debug_type;
-- pragma translate_on
end record;

-- Meiko FPU interface
type fpu_in_type is record
    ss_clock   : std_logic;
    FpInst     : std_logic_vector(9 downto 0);
    FpOp       : std_logic;
    FpLd       : std_logic;
    Reset      : std_logic;
    fprf_dout1 : std_logic_vector(63 downto 0);
    fprf_dout2 : std_logic_vector(63 downto 0);
    RoundingMode : std_logic_vector(1 downto 0);
    ss_scan_mode : std_logic;
    fp_ctl_scan_in : std_logic;
    fpuholdn   : std_logic;
end record;

type fpu_out_type is record
    FpBusy     : std_logic;
    FracResult : std_logic_vector(54 downto 3);
    ExpResult  : std_logic_vector(10 downto 0);
    SignResult : std_logic;
    SNnotDB    : std_logic;
    Excep      : std_logic_vector(5 downto 0);
    ConditionCodes : std_logic_vector(1 downto 0);
    fp_ctl_scan_out : std_logic;
end record;

type cp_unit_in_type is record		-- coprocessor execution unit input
  op1      : std_logic_vector (63 downto 0); -- operand 1
  op2      : std_logic_vector (63 downto 0); -- operand 2
  opcode   : std_logic_vector (9 downto 0);  -- opcode
  start    : std_logic;		             -- start
  load     : std_logic;		             -- load operands
  flush    : std_logic;		             -- cancel operation
end record;

type cp_unit_out_type is record	-- coprocessor execution unit output
  res      : std_logic_vector (63 downto 0); -- result
  cc       : std_logic_vector (1 downto 0);  -- condition codes
  exc      : std_logic_vector (5 downto 0);  -- exception
  busy     : std_logic;		             -- eu busy  
end record;

type rst_type is record
  syncrst : std_logic;		-- synchronous reset
  rawrst  : std_logic;		-- asynchronous reset
end record;

-- pci_[in|out]_type groups all EXTERNAL pci ports in unidirectional form
-- as well as the required enable signals for the pads
type pci_in_type is record

  pci_rst_in_n 	   : std_logic;
  pci_clk_in 	   : std_logic;
  pci_gnt_in_n 	   : std_logic;
  pci_idsel_in 	   : std_logic;
 
  pci_adin 	   : std_logic_vector(31 downto 0);
  pci_cbein_n 	   : std_logic_vector(3 downto 0);
  pci_frame_in_n   : std_logic;
  pci_irdy_in_n    : std_logic;
  pci_trdy_in_n    : std_logic;
  pci_devsel_in_n  : std_logic;
  pci_stop_in_n    : std_logic;
  pci_lock_in_n    : std_logic;
  pci_perr_in_n    : std_logic;
  pci_serr_in_n    : std_logic;
  pci_par_in 	   : std_logic;
  pci_host   	   : std_logic;

end record;


type pci_out_type is record

  pci_aden_n 	   : std_logic_vector(31 downto 0);
  pci_cbe0_en_n    : std_logic;
  pci_cbe1_en_n    : std_logic;
  pci_cbe2_en_n    : std_logic;
  pci_cbe3_en_n    : std_logic;
  
  pci_frame_en_n   : std_logic;
  pci_irdy_en_n    : std_logic;
  pci_ctrl_en_n    : std_logic;
  pci_perr_en_n    : std_logic;
  pci_par_en_n 	   : std_logic;
  pci_req_en_n 	   : std_logic;
   
  pci_req_out_n    : std_logic;
  pci_adout 	   : std_logic_vector(31 downto 0);
  pci_cbeout_n 	   : std_logic_vector(3 downto 0);
  pci_frame_out_n  : std_logic;
  pci_irdy_out_n   : std_logic;
  pci_trdy_out_n   : std_logic;
  pci_devsel_out_n : std_logic;
  pci_stop_out_n   : std_logic;
  pci_perr_out_n   : std_logic;
  pci_serr_out_n   : std_logic;
  pci_par_out 	   : std_logic;

end record;

end;


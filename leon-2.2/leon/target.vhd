
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
-- Entity: 	target
-- File:	target.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	LEON target configuration package
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package target is
type targettechs is (gen, virtex, atc35);
type syntools is (synplify, leonardo); -- synthesis tools      
type boottype is (memory, prom, icache);
type multypes is (none, iterative); -- multiplier type : none or slow iterative
type fputype is (none, meiko, fpc); 	 -- FPU type
type cptype is (none, cpc); -- CP type
type pcitype is (none, insilicon, estec, ahbtst); -- PCI core type
type pci_cfgclk_type is (mainclk, pciclk, both); -- clock source for PCI config write

-- synthesis configuration
type syn_config_type is record
  syntool	: syntools;
  targettech	: targettechs;
  infer_ram 	: boolean;	-- infer cache ram automatically 
  infer_regf 	: boolean;	-- infer regfile automatically 
  infer_rom	: boolean;	-- infer boot prom automatically
  infer_pads	: boolean;	-- infer pads automatically
  gatedclk  	: boolean;	-- select clocking strategy
  rfsyncrd 	: boolean;	-- synchronous register-file read port
  rfsyncwr 	: boolean;	-- synchronous register-file write port
end record;

-- processor configuration
type iu_config_type is record
  nwindows	: integer;	-- # register windows (2 - 32)
  multiplier	: multypes;	-- multiplier type
  fpuen		: integer range 0 to 1;	-- FPU enable (integer due to synopsys limitations....sigh!)
  cpen		: boolean;	-- co-processor enable 
  fastjump   	: boolean;	-- enable fast jump address generation
  icchold   	: boolean;	-- enable fast branch logic
  lddelay	: integer range 1 to 2; -- # load delay cycles (1-2)
  fastdecode 	: boolean;	-- optimise instruction decoding (FPGA only)
  impl   	: integer range 0 to 15; -- IU implementation ID
  version	: integer range 0 to 15; -- IU version ID
end record;

-- FPU configuration
type fpu_config_type is record
  fpu		: fputype;	-- FPU type
  fregs		: integer;	-- 32 for internal meiko, 0 for external FPC
  version	: integer range 0 to 7; -- FPU version ID
end record;

-- co-processor configuration
type cp_config_type is record
  cp		: cptype;	-- Co-processor type
  version	: integer range 0 to 7; -- CP version ID
-- add your CP-specific configuration options here!!
end record;

-- cache configuration
type cache_config_type is record
  icachesize	: integer;	-- size of I-cache in Kbytes
  ilinesize	: integer;	-- # words per I-cache line
  dcachesize	: integer;	-- size of D-cache in Kbytes
  dlinesize	: integer;	-- # words per D-cache line
  bootcache  	: boolean;	-- boot from cache (Xilinx only) 
end record;

-- memory controller configuration
type mctrl_config_type is record
  bus8en    	: boolean;	-- enable 8-bit bus operation
  bus16en    	: boolean;	-- enable 16-bit bus operation
  rawaddr  	: boolean;	-- enable unlatched address option
end record;

type boot_config_type is record
  boot 		: boottype;	-- select boot source
  promabits	: integer range 1 to 26;-- boot prom address bits
  ramrws   	: integer range 0 to 3;	-- ram read waitstates
  ramwws   	: integer range 0 to 3;	-- ram write waitstates
  sysclk   	: integer;	-- cpu clock
  baud     	: positive;	-- UART baud rate
  extbaud  	: boolean;	-- use external baud rate setting
end record;
-- PCI configuration
type pci_config_type is record
  pcicore   	: pcitype;	-- PCI core type
  cfgclk    	: pci_cfgclk_type; -- Selects clock source for PCI config writes
  ahbmasters	: integer;	-- number of ahb master interfaces
  ahbslaves 	: integer;	-- number of ahb slave interfaces
end record;

-- debug configuration
type debug_config_type is record
  enable    	: boolean;	-- enable debug port
  uart     	: boolean;	-- enable fast uart data to console
  iureg    	: boolean;	-- enable tracing of iu register writes
  fpureg      	: boolean;	-- enable tracing of fpu register writes
  nohalt      	: boolean;	-- dont halt on error
  pclow       	: integer;	-- set to 2 for synthesis, 0 for debug
end record;



-- AMBA configuration types
constant AHB_MST_MAX	: integer := 4;   -- maximum AHB masters
constant AHB_SLV_MAX	: integer := 7;   -- maximum AHB slaves
constant AHB_SLV_ADDR_MSB : integer := 4; -- MSB address bits to decode slaves
constant AHB_CACHE_MAX	: integer := 4;   -- maximum cacheability ranges
constant AHB_CACHE_ADDR_MSB : integer := 3; -- MSB address bits to decode cacheability
subtype ahb_range_addr_type is std_logic_vector(AHB_SLV_ADDR_MSB-1 downto 0);
subtype ahb_cache_addr_type is std_logic_vector(AHB_CACHE_ADDR_MSB-1 downto 0);
type ahb_slv_config_type is record
  firstaddr	: ahb_range_addr_type;
  lastaddr	: ahb_range_addr_type;
  index   	: integer range 0 to AHB_SLV_MAX-1;
  split		: boolean;
  enable	: boolean;
end record;
type ahb_slv_config_vector is array (Natural Range <> ) of ahb_slv_config_type;
constant ahb_slv_config_void : ahb_slv_config_type :=
  ((others => '0'), (others => '0'), 0, false, false);

type ahb_cache_config_type is record
  firstaddr	: ahb_cache_addr_type;
  lastaddr	: ahb_cache_addr_type;
end record;
type ahb_cache_config_vector is array (Natural Range <> ) of ahb_cache_config_type;
constant ahb_cache_config_void : ahb_cache_config_type :=
  ((others => '0'), (others => '0'));

type ahb_config_type is record
  masters	: integer range 1 to AHB_MST_MAX;
  defmst 	: integer range 0 to AHB_MST_MAX-1;
  split  	: boolean;	-- add support for SPLIT reponse
  slvtable 	: ahb_slv_config_vector(0 to AHB_SLV_MAX-1);
  cachetable 	: ahb_cache_config_vector(0 to AHB_CACHE_MAX-1);
end record;

constant APB_SLV_MAX	   : integer := 16;  -- maximum APB slaves
constant APB_SLV_ADDR_BITS : integer := 10;  -- address bits to decode APB slaves
subtype apb_range_addr_type is std_logic_vector(APB_SLV_ADDR_BITS-1 downto 0);
type apb_slv_config_type is record
  firstaddr	: apb_range_addr_type;
  lastaddr	: apb_range_addr_type;
  index   	: integer;
  enable	: boolean;
end record;
type apb_slv_config_vector is array (Natural Range <> ) of apb_slv_config_type;
constant apb_slv_config_void : apb_slv_config_type :=
  ((others => '0'), (others => '0'), 0, false);

type apb_config_type is record
  table    	: apb_slv_config_vector(0 to APB_SLV_MAX-1);
end record;

type peri_config_type is record
  cfgreg   	: boolean;	-- enable LEON configuration register
  ahbstat  	: boolean;	-- enable AHB status register
  wprot  	: boolean;	-- enable RAM write-protection unit
  wdog   	: boolean;	-- enable watchdog
end record;

-- complete configuration record type
type config_type is record
  synthesis	: syn_config_type;
  iu   		: iu_config_type;
  fpu  		: fpu_config_type;
  cp  		: cp_config_type;
  cache		: cache_config_type;
  ahb  		: ahb_config_type;
  apb  		: apb_config_type;
  mctrl		: mctrl_config_type;
  boot 		: boot_config_type;
  debug		: debug_config_type;
  pci  		: pci_config_type;
  peri 		: peri_config_type;

end record;

----------------------------------------------------------------------------
-- Synthesis configurations
----------------------------------------------------------------------------

constant syn_none  : syn_config_type := (
  syntool => synplify, targettech => gen, infer_pads => true,
  infer_ram => false, infer_regf => false, infer_rom => false,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_atc35 : syn_config_type := (  
  syntool => synplify, targettech => atc35, infer_pads => false,
  infer_ram => false, infer_regf => false, infer_rom => true,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_synplify : syn_config_type := (
  syntool => synplify, targettech => gen, infer_pads => true,
  infer_ram => true, infer_regf => true, infer_rom => true,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_synplify_vprom : syn_config_type := (
  syntool => synplify, targettech => gen, infer_pads => true,
  infer_ram => true, infer_regf => true, infer_rom => false,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_leonardo : syn_config_type := (
  syntool => leonardo, targettech => gen, infer_pads => true,
  infer_ram => true, infer_regf => true, infer_rom => true,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_virtex  : syn_config_type := (
  syntool => synplify, targettech => virtex, infer_pads => true,
  infer_ram => false, infer_regf => false, infer_rom => true,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);
constant syn_virtex_vprom  : syn_config_type := (
  syntool => synplify, targettech => virtex, infer_pads => true,
  infer_ram => false, infer_regf => false, infer_rom => false,
  gatedclk => false, rfsyncrd => true, rfsyncwr => true);

----------------------------------------------------------------------------
-- IU configurations
----------------------------------------------------------------------------

constant iu_std : iu_config_type := (
  nwindows => 8, multiplier => iterative, fpuen => 0, cpen => false,
  fastjump => false, icchold => false, lddelay => 1, fastdecode => false,
  impl => 0, version => 0);
constant iu_fpga : iu_config_type := (
  nwindows => 8, multiplier => none, fpuen => 0, cpen => false,
  fastjump => true, icchold => true, lddelay => 1, fastdecode => true,
  impl => 0, version => 0);

----------------------------------------------------------------------------
-- FPU configurations
----------------------------------------------------------------------------

constant fpu_none : fpu_config_type := (fpu => none, fregs => 0, version => 0);
constant fpu_meiko: fpu_config_type := (fpu => meiko, fregs => 32, version => 0);
constant fpu_fpc  : fpu_config_type := (fpu => fpc, fregs => 0, version => 0);

----------------------------------------------------------------------------
-- CP configurations
----------------------------------------------------------------------------

constant cp_none : cp_config_type := (cp => none, version => 0);
constant cp_cpc  : cp_config_type := (cp => cpc, version => 0);

----------------------------------------------------------------------------
-- cache configurations
----------------------------------------------------------------------------

constant cache_2k1k : cache_config_type := (
  icachesize => 2, ilinesize => 4, dcachesize => 1, dlinesize => 4,
  bootcache => false);
constant cache_2k2k : cache_config_type := (
  icachesize => 2, ilinesize => 4, dcachesize => 2, dlinesize => 4,
  bootcache => false);
constant cache_2kl8_2kl4 : cache_config_type := (
  icachesize => 2, ilinesize => 8, dcachesize => 2, dlinesize => 4,
  bootcache => false);
constant cache_4k2k : cache_config_type := (
  icachesize => 4, ilinesize => 8, dcachesize => 2, dlinesize => 4,
  bootcache => false);
constant cache_4k4k : cache_config_type := (
  icachesize => 4, ilinesize => 4, dcachesize => 4, dlinesize => 4,
  bootcache => false);
constant cache_8k8k : cache_config_type := (
  icachesize => 8, ilinesize => 8, dcachesize => 8, dlinesize => 4,
  bootcache => false);

----------------------------------------------------------------------------
-- Memory controller configurations
----------------------------------------------------------------------------

constant mctrl_std : mctrl_config_type := (
  bus8en => true, bus16en => true, rawaddr => false);
constant mctrl_fpga : mctrl_config_type := (
  bus8en => true, bus16en => true, rawaddr => false);
constant mctrl_mem32 : mctrl_config_type := (
  bus8en => false, bus16en => false, rawaddr => false);
constant mctrl_bprom : mctrl_config_type := (
  bus8en => false, bus16en => false, rawaddr => false);
constant mctrl_xess16 : mctrl_config_type := (
  bus8en => false, bus16en => true, rawaddr => false);

----------------------------------------------------------------------------
-- boot configurations
----------------------------------------------------------------------------

constant boot_mem : boot_config_type := (boot => memory, promabits => 1, 
  ramrws => 0, ramwws => 0, sysclk => 1000000, baud => 19200, extbaud => false);
constant boot_prom : boot_config_type := (boot => prom, promabits => 8,
  ramrws => 0, ramwws => 0, sysclk => 24576000, baud => 38400, extbaud=> false);
constant boot_cache : boot_config_type := (boot => icache, promabits => 8,
  ramrws => 0, ramwws => 0, sysclk => 24576000, baud => 38400, extbaud=> false);
constant boot_prom_xess16 : boot_config_type := (boot => prom, promabits => 8,
  ramrws => 0, ramwws => 0, sysclk => 25000000, baud => 38400, extbaud=> false);

----------------------------------------------------------------------------
--  PCI configurations
----------------------------------------------------------------------------

constant pci_none : pci_config_type := (
  pcicore => none, cfgclk => mainclk, ahbmasters => 0, ahbslaves => 0);
constant pci_test : pci_config_type := (
  pcicore => ahbtst, cfgclk => mainclk, ahbmasters => 2, ahbslaves => 1);
constant pci_insilicon : pci_config_type := (
  pcicore => insilicon, cfgclk => both, ahbmasters => 2, ahbslaves => 1);
constant pci_estec : pci_config_type := (
  pcicore => estec, cfgclk => mainclk, ahbmasters => 1, ahbslaves => 1);
constant pci_ahb_test : pci_config_type := (
  pcicore => ahbtst, cfgclk => mainclk, ahbmasters => 0, ahbslaves => 1);

----------------------------------------------------------------------------
--  Peripherals configurations
----------------------------------------------------------------------------

constant peri_std : peri_config_type := (
  cfgreg => true, ahbstat => true, wprot => true, wdog => true);
constant peri_fpga : peri_config_type := (
  cfgreg => true, ahbstat => false, wprot => false, wdog => false);

----------------------------------------------------------------------------
-- Debug configurations
----------------------------------------------------------------------------

constant debug_none : debug_config_type := ( enable => false, uart => false, 
  iureg => false, fpureg => false, nohalt => false, pclow => 2);
constant debug_disas : debug_config_type := ( enable => true, uart => false, 
  iureg => false, fpureg => false, nohalt => true, pclow => 2);
constant debug_all  : debug_config_type := ( enable => true, uart => true, 
  iureg => true, fpureg => true, nohalt => false, pclow => 0);

----------------------------------------------------------------------------
-- Amba AHB configurations
----------------------------------------------------------------------------

-- standard slave config
constant ahbslvcfg_std : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
   others => ahb_slv_config_void);

-- AHB test slave config
constant ahbslvcfg_test : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1010", "1010",  2,   true,  true), -- AHB test module      0xA- 0xA
  ("1100", "1111",  3,   false, true), -- PCI initiator        0xC- 0xF
   others => ahb_slv_config_void);

-- PCI slave config
constant ahbslvcfg_pci : ahb_slv_config_vector(0 to AHB_SLV_MAX-1) := (
-- first    last  index  split  enable  function            HADDR[31:28]
  ("0000", "0111",  0,   false, true), -- memory controller,   0x0- 0x7
  ("1000", "1000",  1,   false, true), -- APB bridge, 128 MB   0x8- 0x8
  ("1010", "1111",  2,   false, true), -- PCI initiator        0xA- 0xF
   others => ahb_slv_config_void);

-- standard cacheability config
constant ahbcachecfg_std : ahb_cache_config_vector(0 to AHB_CACHE_MAX-1) := (
-- first    last        function   HADDR[31:29]
  ("000", "000"),   -- PROM area    0x0- 0x0
  ("010", "011"),   -- RAM area     0x2- 0x3
   others => ahb_cache_config_void);

-- standard config record
constant ahb_std : ahb_config_type := (		
  masters => 1, defmst => 0, split => false, 
  slvtable => ahbslvcfg_std, cachetable => ahbcachecfg_std);
-- FPGA config record
constant ahb_fpga : ahb_config_type := (		
  masters => 1, defmst => 0, split => false, 
  slvtable => ahbslvcfg_std, cachetable => ahbcachecfg_std);
-- Phoenix PCI core config record (uses two AHB master instefaces)
constant ahb_insilicon_pci : ahb_config_type := (
  masters => 3, defmst => 0, split => false, 
  slvtable => ahbslvcfg_pci, cachetable => ahbcachecfg_std);
-- ESTEC PCI core config record (uses one AHB master insteface)
constant ahb_estec_pci : ahb_config_type := (
  masters => 2, defmst => 0, split => false, 
  slvtable => ahbslvcfg_pci, cachetable => ahbcachecfg_std);
-- AHB test config
constant ahb_test : ahb_config_type := (
  masters => 3, defmst => 0, split => true, 
  slvtable => ahbslvcfg_test, cachetable => ahbcachecfg_std);

----------------------------------------------------------------------------
-- Amba APB configurations
----------------------------------------------------------------------------

-- standard config
constant apbslvcfg_std : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "0000000000", "0000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "0000001100", "0000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "0000010100", "0000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "0000011100", "0000100000",  3,   true), -- write protection,  0x1C - 0x20
( "0000100100", "0000100100",  4,   true), -- config register,   0x24 - 0x24
( "0001000000", "0001101100",  5,   true), -- timers,            0x40 - 0x6C
( "0001110000", "0001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "0010000000", "0010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "0010010000", "0010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "0010100000", "0010101100",  9,   true), -- I/O port           0xA0 - 0xAC
  others => apb_slv_config_void);

-- PCI config
constant apbslvcfg_pci : apb_slv_config_vector(0 to APB_SLV_MAX-1) := (
--   first         last      index  enable     function           PADDR[9:0]
( "0000000000", "0000001000",  0,   true), -- memory controller, 0x00 - 0x08
( "0000001100", "0000010000",  1,   true), -- AHB status reg.,   0x0C - 0x10
( "0000010100", "0000011000",  2,   true), -- cache controller,  0x14 - 0x18
( "0000011100", "0000100000",  3,   true), -- write protection,  0x1C - 0x20
( "0000100100", "0000100100",  4,   true), -- config register,   0x24 - 0x24
( "0001000000", "0001101100",  5,   true), -- timers,            0x40 - 0x6C
( "0001110000", "0001111100",  6,   true), -- uart1,             0x70 - 0x7C
( "0010000000", "0010001100",  7,   true), -- uart2,             0x80 - 0x8C
( "0010010000", "0010011100",  8,   true), -- interrupt ctrl     0x90 - 0x9C
( "0010100000", "0010101100",  9,   true), -- I/O port           0xA0 - 0xAC
( "0100000000", "0111111100", 10,   true), -- PCI configuration  0x100- 0x1FC
  others => apb_slv_config_void);

constant apb_std : apb_config_type := (table => apbslvcfg_std);
constant apb_pci : apb_config_type := (table => apbslvcfg_pci);
	
----------------------------------------------------------------------------
-- Pre-defined LEON configurations
----------------------------------------------------------------------------

-- standard simulation
constant sim_std : config_type := (
  synthesis => syn_none, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std, 
  boot => boot_mem, debug => debug_disas, pci => pci_none, peri => peri_std);

-- simulatiom with Insilicon PCI core
constant sim_insilicon_pci : config_type := (
  synthesis => syn_none, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_insilicon_pci, apb => apb_pci, 
  mctrl => mctrl_std, boot => boot_mem, debug => debug_disas, 
  pci => pci_insilicon, peri => peri_std);

-- use AHB test module
constant sim_ahb_test : config_type := (
  synthesis => syn_none, iu => iu_std, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_test, apb => apb_pci, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_ahb_test,
  peri => peri_std);

-- synthesis using synplify, 2 + 2 Kbyte cache
constant synplify_2k2 : config_type := (
  synthesis => syn_synplify, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_fpga,
  boot => boot_mem, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis using synplify, internal boot prom (soft)
constant synplify_2k2k_softprom : config_type := (
  synthesis => syn_synplify, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_fpga,
  boot => boot_prom, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis using synplify, internal boot prom (virtex only)
constant synplify_2k2k_virtexprom : config_type := (
  synthesis => syn_synplify_vprom, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_fpga,
  boot => boot_prom, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis using leonardo, 2 + 2 Kbyte cache
constant leonardo_2k2 : config_type := (
  synthesis => syn_leonardo, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_fpga,
  boot => boot_mem, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis using leonardo, internal boot prom (soft)
constant leonardo_2k2k_softprom : config_type := (
  synthesis => syn_leonardo, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_fpga,
  boot => boot_prom, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis for VIRTEX, any syntool
constant gen_virtex_2k2k : config_type := (
  synthesis => syn_virtex, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_mem32,
  boot => boot_mem, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis for VIRTEX, any syntool, soft boot prom
constant gen_virtex_2k2k_bprom : config_type := (
  synthesis => syn_virtex, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_bprom,
  boot => boot_prom, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis for VIRTEX, any syntool, hard boot prom
constant gen_virtex_2k2k_vprom : config_type := (
  synthesis => syn_virtex_vprom, iu => iu_fpga, fpu => fpu_none, cp => cp_none,
  cache => cache_2k2k, ahb => ahb_fpga, apb => apb_std, mctrl => mctrl_bprom,
  boot => boot_prom, debug => debug_disas, pci => pci_none, peri => peri_fpga);

-- synthesis targetting ATC35 asic lib, any syntools
constant gen_atc35 : config_type := (
  synthesis => syn_atc35, iu => iu_std, fpu => fpu_fpc, cp => cp_none,
  cache => cache_4k4k, ahb => ahb_std, apb => apb_std, mctrl => mctrl_std,
  boot => boot_mem, debug => debug_disas, pci => pci_none, peri => peri_std);
end;

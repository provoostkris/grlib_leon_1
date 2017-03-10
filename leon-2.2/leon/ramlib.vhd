
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
-- Package: 	ramlib
-- File:	ramlib.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Vendor independant generators for regfile and cache rams.
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;

package ramlib is

-- three-port regfile with async read, sync write
  component regfile_as
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
  end component;

-- three-port regfile with sync read, sync write
  component regfile_ss_dn
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
  end component;

-- three-port regfile with sync read, sync write
  component regfile_ss
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
  end component;

-- single-port sync ram
  component syncram 
  generic ( abits : integer := 10; dbits : integer := 8);
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
  ); 
  end component;     

-- sync prom (used for boot-prom option)
  component bprom
  port (
    clk       : in std_logic;
    cs        : in std_logic;
    addr      : in std_logic_vector(31 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
  end component;

-- complete cache memory sub-system for bootable caches
  component boot_cache_mem
  generic ( 
    itdbits : integer := 10; itabits : integer := 8;
    iddbits : integer := 10; idabits : integer := 8;
    dtdbits : integer := 10; dtabits : integer := 8;
    dddbits : integer := 10; ddabits : integer := 8
  );
  port (
    clk       : in std_logic;
    enable    : in std_logic;
    itaddr    : in std_logic_vector((itabits -1) downto 0);
    itdatain  : in std_logic_vector((itdbits -1) downto 0);
    itdataout : out std_logic_vector((itdbits -1) downto 0);
    itwrite   : in std_logic;
    idaddr    : in std_logic_vector((idabits -1) downto 0);
    iddatain  : in std_logic_vector((iddbits -1) downto 0);
    iddataout : out std_logic_vector((iddbits -1) downto 0);
    idwrite   : in std_logic;
    dtaddr    : in std_logic_vector((dtabits -1) downto 0);
    dtdatain  : in std_logic_vector((dtdbits -1) downto 0);
    dtdataout : out std_logic_vector((dtdbits -1) downto 0);
    dtwrite   : in std_logic;
    ddaddr    : in std_logic_vector((ddabits -1) downto 0);
    dddatain  : in std_logic_vector((dddbits -1) downto 0);
    dddataout : out std_logic_vector((dddbits -1) downto 0);
    ddwrite   : in std_logic
  );
  end component;

end ramlib;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity syncram is
  generic ( abits : integer := 8; dbits : integer := 32);
  port (
    address : in std_logic_vector (abits -1 downto 0);
    clk     : in std_logic;
    datain  : in std_logic_vector (dbits -1 downto 0);
    dataout : out std_logic_vector (dbits -1 downto 0);
    enable  : in std_logic;
    write   : in std_logic
  );
end;

architecture behav of syncram is
begin

  inf : if INFER_RAM generate 
    synp : if (SYNTOOL = synplify) generate 
      u0 : synplify_syncram generic map (abits => abits, dbits => dbits)
     port map (address, clk, datain, dataout, enable, write);
    end generate;
    leo : if (SYNTOOL = leonardo) generate 
      u0 : leonardo_syncram generic map (abits => abits, dbits => dbits)
     port map (address, clk, datain, dataout, enable, write);
    end generate;
  end generate;

  hb : if (not INFER_RAM) generate 
    at : if TARGET_TECH = atc35 generate
      u0 : atc35_syncram generic map (abits => abits, dbits => dbits)
	 port map (address, clk, datain, dataout, enable, write);
    end generate;
    xcv : if TARGET_TECH = virtex generate 
      u0 : virtex_syncram generic map (abits => abits, dbits => dbits)
	   port map (address, clk, datain, dataout, enable, write);
    end generate;
    sim : if TARGET_TECH = gen generate
      u0 : generic_syncram generic map (abits => abits, dbits => dbits)
           port map (address, clk, datain, dataout, enable, write);
    end generate;    
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity regfile_ss_dn is
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
end;

architecture rtl of regfile_ss_dn is
signal vcc : std_logic;
begin

  vcc <= '1';
  inf : if INFER_REGF generate 
    synp : if (SYNTOOL = synplify) generate 
      u0 : synplify_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    leon : if (SYNTOOL = leonardo) generate 
      u0 : leonardo_regfile_ss generic map (abits, dbits, words)
           port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
  end generate;

  ninf : if not INFER_REGF generate 
    atm0 : if TARGET_TECH = atc35 generate 
      u0 : atc35_regfile_ss_dn generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    xcv : if TARGET_TECH = virtex generate 
      u0 : virtex_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    sim : if TARGET_TECH = gen generate
      u0 : synplify_regfile_ss generic map (abits, dbits, words)
         port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2); 
    end generate;
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity regfile_ss is
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
end;

architecture rtl of regfile_ss is
signal vcc : std_logic;
begin

  vcc <= '1';

  inf : if INFER_REGF generate 
    synp : if (SYNTOOL = synplify) generate 
      u0 : synplify_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    leon : if (SYNTOOL = leonardo) generate 
      u0 : leonardo_regfile_ss generic map (abits, dbits, words)
           port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
  end generate;

  ninf : if not INFER_REGF generate 
    atm0 : if TARGET_TECH = atc35 generate 
      u0 : atc35_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    xcv : if TARGET_TECH = virtex generate 
      u0 : virtex_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    sim : if TARGET_TECH = gen generate
      u0 : synplify_regfile_ss generic map (abits, dbits, words)
         port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2); 
    end generate;
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity regfile_as is
  generic ( 
    abits : integer := 8; dbits : integer := 32; words : integer := 128
  );
  port (
    clk      : in std_logic;
    datain   : in std_logic_vector (dbits -1 downto 0);
    raddr1   : in std_logic_vector (abits -1 downto 0);
    raddr2   : in std_logic_vector (abits -1 downto 0);
    waddr    : in std_logic_vector (abits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic;
    dataout1 : out std_logic_vector (dbits -1 downto 0);
    dataout2 : out std_logic_vector (dbits -1 downto 0));
end;

architecture rtl of regfile_as is
signal vcc : std_logic;
begin

  vcc <= '1';

  inf : if INFER_REGF generate 
    synp : if (SYNTOOL = synplify) generate 
      u0 : synplify_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
    leon : if (SYNTOOL = leonardo) generate 
      u0 : leonardo_regfile_ss generic map (abits, dbits, words)
	   port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
    end generate;
  end generate;

  ninf : if not INFER_REGF generate
    u0 : synplify_regfile_as generic map (abits, dbits, words)
       port map (clk, datain, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
  end generate;        

end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity boot_cache_mem is
  generic ( 
    itdbits : integer := 10; itabits : integer := 8;
    iddbits : integer := 10; idabits : integer := 8;
    dtdbits : integer := 10; dtabits : integer := 8;
    dddbits : integer := 10; ddabits : integer := 8
  );
  port (
    clk       : in std_logic;
    enable    : in std_logic;
    itaddr    : in std_logic_vector((itabits -1) downto 0);
    itdatain  : in std_logic_vector((itdbits -1) downto 0);
    itdataout : out std_logic_vector((itdbits -1) downto 0);
    itwrite   : in std_logic;
    idaddr    : in std_logic_vector((idabits -1) downto 0);
    iddatain  : in std_logic_vector((iddbits -1) downto 0);
    iddataout : out std_logic_vector((iddbits -1) downto 0);
    idwrite   : in std_logic;
    dtaddr    : in std_logic_vector((dtabits -1) downto 0);
    dtdatain  : in std_logic_vector((dtdbits -1) downto 0);
    dtdataout : out std_logic_vector((dtdbits -1) downto 0);
    dtwrite   : in std_logic;
    ddaddr    : in std_logic_vector((ddabits -1) downto 0);
    dddatain  : in std_logic_vector((dddbits -1) downto 0);
    dddataout : out std_logic_vector((dddbits -1) downto 0);
    ddwrite   : in std_logic
  );
end;

architecture rtl of boot_cache_mem is
signal vcc : std_logic;
begin

  vcc <= '1';

  bc : if (TARGET_TECH = virtex) generate 
    bc0 : virtex_boot_cache_mem
      generic map ( itdbits => ITAG_BITS, itabits => IOFFSET_BITS,
                    iddbits => 32, idabits => IOFFSET_BITS + ILINE_BITS,
                    dtdbits => DTAG_BITS, dtabits => DOFFSET_BITS,
                    dddbits => 32, ddabits => DOFFSET_BITS + DLINE_BITS)
      port map ( clk, vcc,
                 itaddr, itdatain, itdataout, itwrite, 
                 idaddr, iddatain, iddataout, idwrite, 
                 dtaddr, dtdatain, dtdataout, dtwrite, 
                 ddaddr, dddatain, dddataout, ddwrite);
  end generate;
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.tech_atc35.all;
use work.tech_generic.all;
use work.tech_leonardo.all;
use work.tech_synplify.all;
use work.tech_virtex.all;

entity bprom is
  port (
    clk       : in std_logic;
    cs        : in std_logic;
    addr      : in std_logic_vector(31 downto 0);
    data      : out std_logic_vector(31 downto 0)
  );
end;

architecture rtl of bprom is
begin

  b0: if INFER_ROM generate
    u0 : synplify_bprom port map (clk, cs, addr(31 downto 2), data);
  end generate;

  b1: if (not INFER_ROM) and (TARGET_TECH = virtex) generate
    u0 : virtex_bprom port map (clk, addr(31 downto 2), data);
  end generate;
end;

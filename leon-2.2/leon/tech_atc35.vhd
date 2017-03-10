
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
-- Entity: 	tech_atc35
-- File:	tech_atc35.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Contains Atmel ATC35 specific pads and ram generators
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;

package tech_atc35 is

-- sync ram generator

  component atc35_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic);
  end component;

-- regfile generator

component atc35_regfile_ss_dn
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

component atc35_regfile_ss
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

-- pads

  component 
    pc3d01 port (pad : in std_logic; cin : out std_logic); 
  end component; 
  component
    pc3d21 port (pad : in std_logic; cin : out std_logic);
  end component; 
  component
    pt3o01 port (i : in std_logic; pad : out std_logic);
  end component; 
  component
    pt3o02 port (i : in std_logic; pad : out std_logic);
  end component; 
  component
    pt3o03 port (i : in std_logic; pad : out std_logic);
  end component; 
  component
    pc3t01u port (i, oen : in std_logic; pad : out std_logic);
  end component; 
  component
    pc3t02u port (i, oen : in std_logic; pad : out std_logic);
  end component; 
  component
    pc3t03u port (i, oen : in std_logic; pad : out std_logic);
 end component; 
  component pt3b01
    port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
  end component; 
  component pt3b02
    port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
  end component; 
  component pt3b03
    port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
  end component; 
end;

------------------------------------------------------------------
-- behavioural ram models ----------------------------------------
------------------------------------------------------------------
-- Only needed for simulation, not synthesis.
-- Address, control and data signals latched on rising ME. 
-- Write enable (WEN) active low.

-- pragma translate_off
library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_256x26 is
  port (
    add   : in std_logic_vector(7 downto 0);
    di    : in std_logic_vector(25 downto 0);
    do    : out std_logic_vector(25 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_256x26 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 8, dbits => 26)
    port map ( add, me, di, do, vcc, we);
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_1024x32 is
  port (
    add   : in std_logic_vector(9 downto 0);
    di    : in std_logic_vector(31 downto 0);
    do    : out std_logic_vector(31 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_1024x32 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 10, dbits => 32)
    port map ( add, me, di, do, vcc, we);
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_2048x32 is
  port (
    add   : in std_logic_vector(10 downto 0);
    di    : in std_logic_vector(31 downto 0);
    do    : out std_logic_vector(31 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_2048x32 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 11, dbits => 32)
    port map ( add, me, di, do, vcc, we);
end behavioral;


library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_256x28 is
  port (
    add   : in std_logic_vector(7 downto 0);
    di    : in std_logic_vector(27 downto 0);
    do    : out std_logic_vector(27 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_256x28 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 8, dbits => 28)
    port map ( add, me, di, do, vcc, we);
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_1024x34 is
  port (
    add   : in std_logic_vector(9 downto 0);
    di    : in std_logic_vector(33 downto 0);
    do    : out std_logic_vector(33 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_1024x34 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 10, dbits => 34)
    port map ( add, me, di, do, vcc, we);
end behavioral;

library ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity RAM_2048x34 is
  port (
    add   : in std_logic_vector(10 downto 0);
    di    : in std_logic_vector(33 downto 0);
    do    : out std_logic_vector(33 downto 0);
    me    : in std_logic;
    wen   : in std_logic
  );
end;

architecture behavioral of RAM_2048x34 is
signal we, vcc : std_logic;
begin
  vcc <= '1'; we <= not wen;
  syncram0 : generic_syncram
    generic map ( abits => 11, dbits => 34)
    port map ( add, me, di, do, vcc, we);
end behavioral;


LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity DPRAMRWRW_16X32 is
 port (
    ADDA : in  std_logic_vector(3 downto 0);
    ADDB : in  std_logic_vector(3 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end;

architecture behav of DPRAMRWRW_16X32 is
signal wen : std_logic;
begin
    wen <= not wenb;
    dp0 : generic_dpram_ss_dn generic map (abits => 4, dbits => 32, words => 16)
	              port map ( dib, adda, addb, wen, mea, meb, doa);
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity DPRAMRWRW_136X32 is
 port (
    ADDA : in  std_logic_vector(7 downto 0);
    ADDB : in  std_logic_vector(7 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end;

architecture behav of DPRAMRWRW_136X32 is
signal wen : std_logic;
begin
    wen <= not wenb;
    dp0 : generic_dpram_ss_dn generic map (abits => 8, dbits => 32, words => 136)
	              port map ( dib, adda, addb, wen, mea, meb, doa);
end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.tech_generic.all;

entity DPRAMRWRW_168X32 is
 port (
    ADDA : in  std_logic_vector(7 downto 0);
    ADDB : in  std_logic_vector(7 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end;

architecture behav of DPRAMRWRW_168X32 is
signal wen : std_logic;
begin
    wen <= not wenb;
    dp0 : generic_dpram_ss_dn generic map (abits => 8, dbits => 32, words => 168)
	              port map ( dib, adda, addb, wen, mea, meb, doa);
end;



------------------------------------------------------------------
-- sync ram generator --------------------------------------------
------------------------------------------------------------------
-- pragma translate_on

library IEEE;
use IEEE.std_logic_1164.all;

entity atc35_syncram is
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector(abits -1 downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector(dbits -1 downto 0);
    dataout  : out std_logic_vector(dbits -1 downto 0);
    enable   : in std_logic;
    write    : in std_logic
  );
end;

architecture rtl of atc35_syncram is
-- Atmel ram cells
  component RAM_256x26 
    port (
    add   : in std_logic_vector(7 downto 0);
    di    : in std_logic_vector(25 downto 0);
    do    : out std_logic_vector(25 downto 0);
    me    : in std_logic;
    wen   : in std_logic);
  end component;
  component RAM_1024x32 
    port (
    add   : in std_logic_vector(9 downto 0);
    di    : in std_logic_vector(31 downto 0);
    do    : out std_logic_vector(31 downto 0);
    me    : in std_logic;
    wen   : in std_logic);
  end component;
  component RAM_2048x32 
    port (
    add   : in std_logic_vector(10 downto 0);
    di    : in std_logic_vector(31 downto 0);
    do    : out std_logic_vector(31 downto 0);
    me    : in std_logic;
    wen   : in std_logic);
  end component;

  signal wr   : std_logic;
  signal a    : std_logic_vector(19 downto 0);
  signal d, q : std_logic_vector(34 downto 0);
begin

  wr <= not write; 
  a(abits -1 downto 0) <= address; a(abits+1 downto abits) <= "00";
  d(dbits -1 downto 0) <= datain; d(dbits+1 downto dbits) <= "00";
  dataout <= q(dbits -1 downto 0);

  a8d26 : if (abits <= 8) and (dbits <= 26) generate
    id0 : RAM_256x26 
	  port map ( a(7 downto 0), d(25 downto 0), q(25 downto 0), clk, wr);
  end generate;
  a10d32 : if (abits > 8) and (abits <= 10) and (dbits <= 32) generate
    id0 : RAM_1024X32 
	  port map ( a(9 downto 0), d(31 downto 0), q(31 downto 0), clk, wr);
  end generate;
  a11d32 : if (abits = 11) and (dbits <= 32) generate
    id0 : RAM_2048X32 
	  port map ( a(10 downto 0), d(31 downto 0), q(31 downto 0), clk, wr);
  end generate;

end rtl;

------------------------------------------------------------------
-- regfile generator  --------------------------------------------
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity atc35_regfile_ss_dn is
  generic ( 
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 128
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
    dataout2 : out std_logic_vector (dbits -1 downto 0)
  );
end;

architecture rtl of atc35_regfile_ss_dn is
component DPRAMRWRW_16X32
 port (
    ADDA : in  std_logic_vector(3 downto 0);
    ADDB : in  std_logic_vector(3 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end component;
component DPRAMRWRW_136X32
 port (
    ADDA : in  std_logic_vector(7 downto 0);
    ADDB : in  std_logic_vector(7 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end component;
component DPRAMRWRW_168X32
 port (
    ADDA : in  std_logic_vector(7 downto 0);
    ADDB : in  std_logic_vector(7 downto 0);
    DIA  : in  std_logic_vector(31 downto 0);
    DIB  : in  std_logic_vector(31 downto 0);
    DOA  : out std_logic_vector(31 downto 0);
    DOB  : out std_logic_vector(31 downto 0);
    MEA  : in  std_logic;
    MEB  : in  std_logic;
    WENA : in  std_logic;
    WENB : in  std_logic 
    );
end component;

signal din, dx, qq1, qq2, qx1, qx2 : std_logic_vector(31 downto 0);

signal vcc, wen : std_logic;
signal ra1, ra2, wa : std_logic_vector(12 downto 0);
begin
  wen <= not write; dx <= (others => '0'); vcc <= '1';
  din(dbits-1 downto 0) <= datain;
  ra1(abits-1 downto 0) <= raddr1;
  ra1(12 downto abits) <= (others => '0');
  ra2(abits-1 downto 0) <= raddr2;
  ra2(12 downto abits) <= (others => '0');
  wa(abits-1 downto 0) <= waddr;
  wa(12 downto abits) <= (others => '0');
  dataout1 <= qq1(dbits-1 downto 0);
  dataout2 <= qq2(dbits-1 downto 0);


  dp16x32 : if (words = 16) and (dbits = 32) generate
    u0: DPRAMRWRW_16X32
	port map (ra1(3 downto 0), wa(3 downto 0), dx(31 downto 0), 
		  din(31 downto 0), qq1(31 downto 0), qx1(31 downto 0), clk, 
		  clk, vcc, wen);
    u1: DPRAMRWRW_16X32
	port map (ra2(3 downto 0), wa(3 downto 0), dx(31 downto 0), 
		  din(31 downto 0), qq2(31 downto 0), qx2(31 downto 0), clk, 
		  clk, vcc, wen);
  end generate;

  dp136x32 : if (words = 136) and (dbits = 32) generate
    u0: DPRAMRWRW_136X32
	port map (ra1(7 downto 0), wa(7 downto 0), dx(31 downto 0), din(31 downto 0), 
		  qq1(31 downto 0), qx1(31 downto 0), clk, clk, vcc, wen);
    u1: DPRAMRWRW_136X32
	port map (ra2(7 downto 0), wa(7 downto 0), dx(31 downto 0), din(31 downto 0), 
		  qq2(31 downto 0), qx2(31 downto 0), clk, clk, vcc, wen);
  end generate;

  dp168x32 : if (words = 168) and (dbits = 32) generate
    u0: DPRAMRWRW_168X32
	port map (ra1(7 downto 0), wa(7 downto 0), dx(31 downto 0), din(31 downto 0), 
		  qq1(31 downto 0), qx1(31 downto 0), clk, clk, vcc, wen);
    u1: DPRAMRWRW_168X32
	port map (ra2(7 downto 0), wa(7 downto 0), dx(31 downto 0), din(31 downto 0), 
		  qq2(31 downto 0), qx2(31 downto 0), clk, clk, vcc, wen);
  end generate;



end;

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tech_atc35.all;

entity atc35_regfile_ss is
  generic ( 
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 128
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
    dataout2 : out std_logic_vector (dbits -1 downto 0)
  );
end;

architecture rtl of atc35_regfile_ss is
signal dlat : std_logic_vector(dbits -1 downto 0);
signal vcc : std_logic;
begin

  vcc <= '1';
  lat : process(datain, clk)
  begin 
    if (clk = '0') then dlat <= datain; end if;
  end process;

  u0 : atc35_regfile_ss_dn generic map (abits, dbits, words)
       port map (clk, dlat, raddr1, raddr2, waddr, vcc, write, dataout1, dataout2);
  
end;

------------------------------------------------------------------
-- behavioural pad models --------------------------------------------
------------------------------------------------------------------

-- pragma translate_off
-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
entity pc3d01 is port (pad : in std_logic; cin : out std_logic); end; 
architecture rtl of pc3d01 is begin cin <= to_x01(pad) after 1 ns; end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
entity pc3d21 is port (pad : in std_logic; cin : out std_logic); end; 
architecture rtl of pc3d21 is begin cin <= to_x01(pad) after 1 ns; end;

-- output pads
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3o01 is port (i : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pt3o01 is begin pad <= to_x01(i) after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3o02 is port (i : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pt3o02 is begin pad <= to_x01(i) after 2 ns; end;
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3o03 is port (i : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pt3o03 is begin pad <= to_x01(i) after 2 ns; end;

-- output tri-state pads
library IEEE;
use IEEE.std_logic_1164.all;
entity pc3t01u is port (i, oen : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pc3t01u is
begin pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns; end; 
library IEEE;
use IEEE.std_logic_1164.all;
entity pc3t02u is port (i, oen : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pc3t02u is
begin pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns; end; 
library IEEE;
use IEEE.std_logic_1164.all;
entity pc3t03u is port (i, oen : in  std_logic; pad : out  std_logic); end; 
architecture rtl of pc3t03u is
begin pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns; end; 

-- bidirectional pad
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3b01 is
  port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
end; 
architecture rtl of pt3b01 is
begin 
  pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns;
  cin <= to_x01(pad) after 2 ns;
end;
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3b02 is
  port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
end; 
architecture rtl of pt3b02 is
begin 
  pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns;
  cin <= to_x01(pad) after 2 ns;
end;
library IEEE;
use IEEE.std_logic_1164.all;
entity pt3b03 is
  port ( i, oen : in std_logic; cin : out std_logic; pad : inout std_logic);
end; 
architecture rtl of pt3b03 is
begin 
  pad <= to_x01(i) after 2 ns when oen = '0' else 'Z' after 2 ns;
  cin <= to_x01(pad) after 2 ns;
end;

-- pragma translate_on

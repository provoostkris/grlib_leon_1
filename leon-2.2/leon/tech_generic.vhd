
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
-- Entity: 	tech_generic
-- File:	tech_generic.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	Contains behavioural pads and ram generators
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;

package tech_generic is

-- generic sync ram

component generic_syncram
  generic ( abits : integer := 10; dbits : integer := 8 );
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
   ); 
end component;

-- suncronous dpram with data latched on falling edge

component generic_dpram_ss_dn
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
    data: in std_logic_vector (dbits -1 downto 0);
    rdaddress: in std_logic_vector (abits -1 downto 0);
    wraddress: in std_logic_vector (abits -1 downto 0);
    wren : in std_logic;
    clka, clkb : in std_logic;
    q: out std_logic_vector (dbits -1 downto 0)
  );
end component;

-- pads

component geninpad port (pad : in std_logic; q : out std_logic); end component; 
component gensmpad port (pad : in std_logic; q : out std_logic); end component;
component genoutpad port (d : in  std_logic; pad : out  std_logic); end component; 
component geniopad 
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end component;
component geniodpad 
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end component;
component genodpad port ( d : in std_logic; pad : out std_logic); end component;

end;

library IEEE;
use IEEE.std_logic_1164.all;

------------------------------------------------------------------
-- behavioural ram models --------------------------------------------
------------------------------------------------------------------

-- pragma translate_off

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity generic_syncram is
  generic (
    abits : integer := 10;
    dbits : integer := 8
  );
  port (
    address  : in std_logic_vector((abits -1) downto 0);
    clk      : in std_logic;
    datain   : in std_logic_vector((dbits -1) downto 0);
    dataout  : out std_logic_vector((dbits -1) downto 0);
    enable   : in std_logic;
    write    : in std_logic
  ); 
end generic_syncram;     

architecture behavioral of generic_syncram is

  subtype word is std_logic_vector((dbits -1) downto 0);
  type mem is array(0 to (2**abits -1)) of word;

begin

  main : process(clk)
  variable memarr : mem;
  begin
    if rising_edge(clk) then
      if enable = '1' then
        if not is_x(address) then
          if write = '1' then
            memarr(conv_integer(unsigned(address))) := datain;
	    dataout <= (others => 'X');
          else
            dataout <= memarr(conv_integer(unsigned(address)));
          end if;
        end if;
      end if;
    end if;
  end process;
 
end behavioral;


--  Address and control latched on rising clka, data latched on falling clkb. 

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity generic_dpram_ss_dn is
  generic (
    abits : integer := 8;
    dbits : integer := 32;
    words : integer := 256
  );
  port (
    data: in std_logic_vector (dbits -1 downto 0);
    rdaddress: in std_logic_vector (abits -1 downto 0);
    wraddress: in std_logic_vector (abits -1 downto 0);
    wren : in std_logic;
    clka, clkb : in std_logic;
    q: out std_logic_vector (dbits -1 downto 0)
  );
end;

architecture behav of generic_dpram_ss_dn is
signal dr : std_logic_vector (dbits -1 downto 0);
signal ra,wa : std_logic_vector (abits -1 downto 0);
signal wer : std_logic;
begin
  rp : process(clka, clkb, rdaddress, wren, wraddress, data, wa, ra, wer)
  subtype dword is std_logic_vector(dbits -1 downto 0);
  type dregtype is array (0 to words - 1) of DWord;
  variable rfd : dregtype;
  begin
    if falling_edge(clkb) and (wer = '1') then
      if not is_x (wa) then 
   	rfd(conv_integer(unsigned(wa)) mod words) := data; 
      end if;
    end if;
    if rising_edge(clka) then
      ra <= rdaddress; wa <= wraddress; wer <= wren;
    end if;
    if not (is_x (ra) or ((wer = '1') and (ra = wa))) then 
      q <= rfd(conv_integer(unsigned(ra)) mod words);
    else q <= (others => 'X'); end if;
  end process;
end;

------------------------------------------------------------------
-- behavioural pad models --------------------------------------------
------------------------------------------------------------------

-- pragma translate_on

-- input pad
library IEEE;
use IEEE.std_logic_1164.all;
entity geninpad is port (pad : in std_logic; q : out std_logic); end; 
architecture rtl of geninpad is begin q <= to_x01(pad); end;

-- input schmitt pad
library IEEE;
use IEEE.std_logic_1164.all;
entity gensmpad is port (pad : in std_logic; q : out std_logic); end; 
architecture rtl of gensmpad is begin q <= to_x01(pad); end;

-- output pad
library IEEE;
use IEEE.std_logic_1164.all;
entity genoutpad is port (d : in  std_logic; pad : out  std_logic); end; 
architecture rtl of genoutpad is begin pad <= to_x01(d); end;

-- bidirectional pad
library IEEE;
use IEEE.std_logic_1164.all;
entity geniopad is
  port ( d, en : in std_logic; q : out std_logic; pad : inout std_logic);
end; 
architecture rtl of geniopad is
begin pad <= to_x01(d) when en = '0' else 'Z'; q <= to_x01(pad); end;

-- bidirectional open-drain pad
library IEEE;
use IEEE.std_logic_1164.all;
entity geniodpad is
  port ( d : in std_logic; q : out std_logic; pad : inout std_logic);
end; 
architecture rtl of geniodpad is
begin pad <= '0' when d = '0' else 'Z'; q <= to_x01(pad); end;

-- open-drain pad
library IEEE;
use IEEE.std_logic_1164.all;
entity genodpad is port ( d : in std_logic; pad : out std_logic); end; 
architecture rtl of genodpad is begin pad <= '0' when d = '0' else 'Z'; end;


-----------------------------------------------------------------------------
--  This file is a part of the LEON VHDL model
--  Copyright (C) 1999  European Space Agency (ESA)
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  See the file COPYING for the full details of the license.


-----------------------------------------------------------------------------
-- Entity:      tbgen
-- File:        tbgen.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Generic test bench for LEON. The test bench uses generate
--		statements to build a LEON system with the desired memory
--		size and data width.
------------------------------------------------------------------------------
-- Version control:
-- 11-08-1999:  First implemetation
-- 26-09-1999:  Release 1.0
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.config.all;
use work.iface.all;
use work.leonlib.all;
use work.debug.all;
use STD.TEXTIO.all;

entity tbgen is
  generic (

    msg1      : string := "8 kbyte 32-bit rom, 0-ws, EDAC";
    msg2      : string := "2x128 kbyte 32-bit ram, 0-ws, EDAC";
    pci       : boolean := false;	-- use the PCI version of leon
    pcihost   : boolean := false;	-- be PCI host
    DISASS    : integer := 0;	-- enable disassembly to stdout
    clkperiod : integer := 20;		-- system clock period
    romfile   : string := "tsource/rome.dat";  -- rom contents
    ramfile   : string := "tsource/ram.dat";  -- ram contents
    romwidth  : integer := 32;		-- rom data width (8/32)
    romdepth  : integer := 11;		-- rom address depth
    romedac   : boolean := true;	-- rom EDAC enable
    romtacc   : integer := 10;		-- rom access time (ns)
    ramwidth  : integer := 32;		-- ram data width (8/32)
    ramdepth  : integer := 15;		-- ram address depth
    rambanks  : integer := 2;		-- number of ram banks
    ramedac   : boolean := true;	-- ram EDAC enable
    ramtacc   : integer := 10		-- ram access time (ns)
  );
end; 

architecture behav of tbgen is


component iram
      generic (index : integer := 0;		-- Byte lane (0 - 3)
	       Abits: Positive := 10;		-- Default 10 address bits (1 Kbyte)
	       echk : integer := 0;		-- Generate EDAC checksum
	       tacc : integer := 10;		-- access time (ns)
	       fname : string := "ram.dat");	-- File to read from
      port (  
	A : in std_logic_vector;
        D : inout std_logic_vector(7 downto 0);
        CE1 : in std_logic;
        WE : in std_logic;
        OE : in std_logic

); end component;

component testmod
  port (
	error	: in   	 std_logic;
	iosn 	: in   	 std_logic;
	oen  	: in   	 std_logic;
	read 	: in   	 std_logic;
	writen	: in   	 std_logic;
	brdyn  	: out    std_logic;
	bexcn  	: out    std_logic;
	address : in     std_logic_vector(7 downto 0);
	data	: inout  std_logic_vector(31 downto 0);
	ioport  : out     std_logic_vector(15 downto 0)
	);
end component;

  function to_xlhz(i : std_logic) return std_logic is
  begin
    case to_X01Z(i) is
    when 'Z' => return('Z');
    when '0' => return('L');
    when '1' => return('H');
    when others => return('X');
    end case;
  end;


signal clk : std_logic := '0';
signal Rst    : std_logic := '0';			-- Reset
constant ct : integer := clkperiod/2;

signal address  : std_logic_vector(27 downto 0);
signal data     : std_logic_vector(31 downto 0);

signal ramsn    : std_logic_vector(3 downto 0);
signal ramoen   : std_logic_vector(3 downto 0);
signal rwen     : std_logic_vector(3 downto 0);
signal romsn    : std_logic_vector(1 downto 0);
signal iosn     : std_logic;
signal oen      : std_logic;
signal read     : std_logic;
signal writen   : std_logic;
signal brdyn    : std_logic;
signal bexcn    : std_logic;
signal error    : std_logic;
signal wdog     : std_logic;
signal test     : std_logic;
signal pio	: std_logic_vector(15 downto 0);
signal GND      : std_logic := '0';
signal VCC      : std_logic := '1';
signal NC       : std_logic := 'Z';
    
signal pci_rst_n 	           : std_logic := '0';
signal pci_clk	           : std_logic := '1';
signal pci_gnt_in_n 	   : std_logic;
signal pci_ad 	   : std_logic_vector(31 downto 0);
signal pci_cbe_n   : std_logic_vector(3 downto 0);
signal pci_frame_n : std_logic;
signal pci_irdy_n  : std_logic;
signal pci_trdy_n  : std_logic;
signal pci_devsel_n: std_logic;
signal pci_stop_n  : std_logic;
signal pci_perr_n  : std_logic;
signal pci_par 	   : std_logic;    
signal pci_req_n   : std_logic;
signal pci_serr_n    : std_logic;
signal pci_idsel_in   : std_logic;
signal pci_lock_in_n   : std_logic;
signal pci_host   : std_logic;

begin

-- clock and reset

  clk <= not clk after ct * 1 ns;
  rst <= '0', '1' after clkperiod*10 * 1 ns;

  pci_clk <= not clk after ct * 1 ns;
  pci_rst_n <= '0', '1' after clkperiod*10 * 1 ns;
  pci_frame_n      <= 'H';
  pci_irdy_n       <= 'H';
  pci_trdy_n       <= 'H';
  pci_devsel_n     <= 'H';
  pci_stop_n       <= 'H';
  pci_perr_n       <= 'H';
  pci_serr_n   <= 'H';
  pci_host <= '1' when pcihost else '0';


-- processor (no PCI)
    p0 : if not pci generate
      leon0 : leon 
 	      port map (rst, clk, 

		error, address, data, 

		ramsn, ramoen, rwen, romsn, iosn, oen, read, writen, 
		brdyn, bexcn, pio, wdog, test);

    end generate;

-- processor (PCI)
    p1 : if pci generate
          leon0 : leon_pci 
 	      port map (rst, clk, 

		error, address, data, 

		ramsn, ramoen, rwen, romsn, iosn, oen, read, writen, 
		brdyn, bexcn, pio, wdog, test, 
        	pci_rst_n, pci_clk, pci_gnt_in_n, pci_idsel_in,
		pci_lock_in_n, pci_ad, pci_cbe_n, pci_frame_n, pci_irdy_n,
		pci_trdy_n, pci_devsel_n, pci_stop_n, pci_perr_n, pci_par,
		pci_req_n, pci_serr_n, pci_host );

  end generate;
-- 8-bit rom 

  rom8d : if romwidth = 8 generate

    pio(1 downto 0) <= "LL";	  -- 8-bit data bus

    rome : if romedac generate
      rom0 : iram 
        generic map (index => 0, abits => romdepth, echk => 3, tacc => romtacc,
		     fname => romfile)
        port map (A => address(romdepth-1 downto 0), D => data(31 downto 24),
                  CE1 => romsn(0), WE => VCC, OE => oen);
      pio(2) <= 'H';  -- enable EDAC
    end generate;
    romne : if not romedac generate
      rom0 : iram 
        generic map (index => 0, abits => romdepth, echk => 2, tacc => romtacc,
		     fname => romfile)
        port map (A => address(romdepth-1 downto 0), D => data(31 downto 24),
                  CE1 => romsn(0), WE => VCC, OE => oen);
      pio(2) <= 'L';  -- disable EDAC
    end generate;
  end generate;

-- 16-bit rom 

  rom16d : if romwidth = 16 generate

    pio(1 downto 0) <= "LH";	  -- 16-bit data bus

    romarr : for i in 0 to 1 generate
      rom0 : iram 
	generic map (index => i, abits => romdepth, echk => 4, tacc => romtacc,
		     fname => romfile)
        port map (A => address(romdepth downto 1), 
		  D => data((31 - i*8) downto (24-i*8)), CE1 => romsn(0),
		  WE => VCC, OE => oen);
    end generate;
  end generate;

-- 32-bit rom 

  rom32d : if romwidth = 32 generate

    pio(1 downto 0) <= "HH";	  -- 32-bit data bus

    romarr : for i in 0 to 3 generate
      rom0 : iram 
	generic map (index => i, abits => romdepth, echk => 0, tacc => romtacc,
		     fname => romfile)
        port map (A => address(romdepth+1 downto 2), 
		  D => data((31 - i*8) downto (24-i*8)), CE1 => romsn(0),
		  WE => VCC, OE => oen);
    end generate;


    pio(2) <= 'L';

  end generate;

-- 8-bit ram

  ram8d : if ramwidth = 8 generate
    rame : if ramedac generate
      ram0 : iram 
        generic map (index => 0, abits => ramdepth, echk => 3, tacc => ramtacc,
		     fname => ramfile)
        port map (A => address(ramdepth-1 downto 0), D => data(31 downto 24),
                  CE1 => ramsn(0), WE => rwen(0), OE => ramoen(0));
    end generate;
    ramne : if not ramedac generate
      ram0 : iram 
        generic map (index => 0, abits => ramdepth, echk => 2, tacc => ramtacc,
		     fname => ramfile)
        port map (A => address(ramdepth-1 downto 0), D => data(31 downto 24),
                  CE1 => ramsn(0), WE => rwen(0), OE => ramoen(0));
    end generate;
  end generate;


-- 16-bit ram

  ram16d : if ramwidth = 16 generate
    rambnk : for i in 0 to rambanks-1 generate
      ramarr : for j in 0 to 1 generate
        ram0 : iram 
	  generic map (index => j, abits => ramdepth, echk => 4, 
		       tacc => ramtacc, fname => ramfile)
          port map (A => address(ramdepth downto 1),
		    D => data((31 - j*8) downto (24-j*8)), CE1 => ramsn(i), 
		    WE => rwen(j), OE => ramoen(i));
      end generate;
    end generate;
  end generate;

-- 32-bit ram

  ram32d : if ramwidth = 32 generate
    rambnk : for i in 0 to rambanks-1 generate
      ramarr : for j in 0 to 3 generate
        ram0 : iram 
	  generic map (index => j, abits => ramdepth, echk => 0, 
		       tacc => ramtacc, fname => ramfile)
          port map (A => address(ramdepth+1 downto 2),
		    D => data((31 - j*8) downto (24-j*8)), CE1 => ramsn(i), 
		    WE => rwen(j), OE => ramoen(i));
      end generate;


    end generate;


  end generate;

-- boot message

    bootmsg : process(rst)
    begin
      if rst'event and (rst = '1') then --'
        print("LEON-1 VHDL model and generic testbench, copyright ESA/ESTEC 1999");
        print("Comments and bug reports to Jiri Gaisler, jgais@ws.estec.esa.nl");
	print("");
        print("Testbench configuration:");
        print(msg1); print(msg2); print("");
      end if;
    end process;


-- test module

  testmod0 : testmod port map (error, iosn, oen, read, writen, brdyn, bexcn,
			       address(7 downto 0), data , pio);
  test <= '1' when DISASS > 0 else '0';

-- cross-strap UARTs

  pio(14) <= to_XLHZ(pio(11));	-- RX1 <- TX2
  pio(10) <= to_XLHZ(pio(15));	-- RX2 <- TX1
  pio(12) <= to_XLHZ(pio(9));	-- CTS1 <- RTS2
  pio(8) <= to_XLHZ(pio(13));	-- CTS2 <- RTS1

  pio(3) <= wdog;  		  -- WDOG output on IO3
  wdog <= 'H';			  -- WDOG pull-up
  error <= 'H';			  -- ERROR pull-up

-- waitstates 

  wsgen : process
  begin
    if (romtacc < (clkperiod - 5)) then pio(5 downto 4) <= "LL";
    elsif (romtacc < (2*clkperiod - 5)) then pio(5 downto 4) <= "LH";
    elsif (romtacc < (3*clkperiod - 5)) then pio(5 downto 4) <= "HL";
    else pio(5 downto 4) <= "HH"; end if;
    if (ramtacc < (clkperiod - 5)) then pio(7 downto 6) <= "LL";
    elsif (ramtacc < (2*clkperiod - 5)) then pio(7 downto 6) <= "LH";
    elsif (ramtacc < (3*clkperiod - 5)) then pio(7 downto 6) <= "HL";
    else pio(7 downto 6) <= "HH"; end if;
    wait on rst;
  end process;

end ;


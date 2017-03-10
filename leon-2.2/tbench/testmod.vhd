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
-- Entity:      testmod
-- File:        testmod.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: This module is connected to the I/O area and generates
--		debug messages and bus exceptions for the test bench.
------------------------------------------------------------------------------  
-- Version control:
-- 17-12-1998:  : First implemetation
-- 27-08-1999:  : Moved trace function from iu 
-- 26-09-1999:  : Release 1.0
------------------------------------------------------------------------------  

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.Std_Logic_unsigned.conv_integer;
use STD.TEXTIO.all;
use work.debug.all;

entity testmod is
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
	
end;


architecture behav of testmod is

subtype restype is string(1 to 6);
type resarr is array (0 to 2) of restype;
constant res : resarr := ("      ", "OK    ", "FAILED");
signal ioporti  : std_logic_vector(15 downto 0);
    
subtype msgtype is string(1 to 40);
type msgarr is array (0 to 17) of msgtype;
constant msg : msgarr := (
    "*** Starting LEON system test ***       ", -- 0
    "Cache memory                            ", -- 1
    "Register file                           ", -- 2
    "Logical instructions                    ", -- 3
    "Arithmetical instructions               ", -- 4
    "Load/store instruction                  ", -- 5
    "Control flow instruction                ", -- 6
    "Floating-point unit                     ", -- 7
    "PCI interface                           ", -- 8
    "Memory interface                        ", -- 9
    "Interrupt controller                    ", -- 10
    "Timers, watchdog and power-down         ", -- 11
    "UARTs                                   ", -- 12
    "Parallel I/O port                       ", -- 13
    "EDAC operation                          ", -- 14
    "DMA interface                           ", -- 15
    "Memory interface test                   ", -- 16
    "Test completed OK, halting with failure "  -- 17
);


begin


  rep : process
  variable aint : natural;
  variable dint : natural;
  variable ioval,ioout : std_logic_vector(15 downto 0);
  variable datal : std_logic_vector(31 downto 0) := (others => '0');
  variable iodir : std_logic_vector(15 downto 0) := (others => '0');
  begin

    for i in ioport'range loop	--'
      if iodir(i) = '1' then ioout(i) := ioval(i); else ioout(i) := 'Z'; end if;
    end loop;
    ioporti <= ioout;
    brdyn <= '1' after 5 ns; bexcn <= '1' after 5 ns;
    data <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" after 5 ns;

    wait until  ((iosn or (writen and oen)) = '0');
    wait for 10 ns;
    aint := conv_integer(address);
    if not is_x(data) then dint := conv_integer(data(31 downto 24)); end if;
    if aint < 64 then
      if dint = 0 then
        print (string(msg(aint)));
        if aint = 17 then
	  assert false report "TEST COMPLETED OK, ending with FAILURE" 
	    severity failure ;
        end if;
      else
        print (string(msg(aint)) & "ERROR(" & tost(std_logic_vector(conv_unsigned(dint, 8))) & ")");
        assert false report "TEST ABORTED DUE TO FAILURE" severity failure ;
      end if;
      brdyn  <= '0' after 10 ns;
    else
      brdyn  <= '0' after 10 ns;
      case aint is 
      when 64 => if read = '0' then iodir(7 downto 0) := data(31 downto 24); end if;
      when 65 => if read = '0' then iodir(15 downto 8) := data(31 downto 24); end if;
      when 66 => if read = '0' then ioval(7 downto 0) := data(31 downto 24); end if;
      when 67 => if read = '0' then ioval(15 downto 8) := data(31 downto 24); end if;
      when 72 => bexcn <= '0';
      when 76 => bexcn <= '0';
      when 80 => bexcn <= '0';
      when 92 => bexcn <= '0';
      when 94 => bexcn <= '0';
      when others => null;
      end case;
    end if;
    if read = '1' then data <= datal; end if;
    wait until (iosn = '1');

  end process;

  ioport <= ioporti;

  errmode : process(error)
  begin
    if now > 10 ns then
      assert  to_x01(error) = '1' report "processor in error mode!" 
	  severity failure ;
    end if;
  end process;



end;



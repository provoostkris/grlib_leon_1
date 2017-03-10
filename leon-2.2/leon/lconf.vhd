
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
-- Entity: 	lconf
-- File:	lconf.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	LEON configuration register. Returns the configuration
--		of the processor.
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;
entity lconf is
  port (
    rst    : in  rst_type;
    apbo   : out apb_slv_out_type
  );
end; 

architecture rtl of lconf is

begin

  beh : process(rst)
  variable regsd : std_logic_vector(31 downto 0);
  begin
    regsd := (others => '0');
    if WPROTEN then regsd(1 downto 0) := "01"; end if;
    case PCICORE is
    when insilicon =>  regsd(3 downto 2) := "01";
    when estec     =>  regsd(3 downto 2) := "10";
    when ahbtst    =>  regsd(3 downto 2) := "11";
    when others    =>  regsd(3 downto 2) := "00";
    end case;
    if FPEN then regsd(5 downto 4) := "01"; end if;
    if AHBSTATEN then regsd(6) := '1'; end if;
    if WDOGEN then regsd(7) := '1'; end if;
    if MULTIPLIER /= none  then regsd(8) := '1'; end if;
    regsd(9) := '0';	-- no division hardware
    regsd(11 downto 10) := std_logic_vector(conv_unsigned(DLINE_BITS, 2));
    regsd(14 downto 12) := std_logic_vector(conv_unsigned(DLINE_BITS+DOFFSET_BITS-8, 3));
    regsd(16 downto 15) := std_logic_vector(conv_unsigned(ILINE_BITS, 2));
    regsd(19 downto 17) := std_logic_vector(conv_unsigned(ILINE_BITS+IOFFSET_BITS-8, 3));
    regsd(24 downto 20) := std_logic_vector(conv_unsigned(NWINDOWS-1,5));

    apbo.prdata <= regsd;

  end process;


end;



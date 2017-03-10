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
-- Entity: 	leonlib
-- File:	leonlib.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	package containing LEON 
------------------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all;
use work.iface.all;

package leonlib is
component leon 
  port (
    resetn   : in  std_logic;
    clk      : in  std_logic;

    errorn   : inout std_logic;

    address  : inout std_logic_vector(27 downto 0);
    data     : inout std_logic_vector(31 downto 0);

    ramsn    : inout std_logic_vector(3 downto 0);
    ramoen   : inout std_logic_vector(3 downto 0);
    rwen     : inout std_logic_vector(3 downto 0);
    romsn    : inout std_logic_vector(1 downto 0);
    iosn     : inout std_logic;
    oen      : inout std_logic;
    read     : inout std_logic;
    writen   : inout std_logic;
    brdyn    : in  std_logic;
    bexcn    : in  std_logic;

    pio      : inout std_logic_vector(15 downto 0);
    wdogn    : inout std_logic;
    test     : in    std_logic
  );
end component;

component leon_pci 
  port (
    resetn   : in  std_logic;
    clk      : in  std_logic;

    errorn   : inout std_logic;

    address  : inout std_logic_vector(27 downto 0);
    data     : inout std_logic_vector(31 downto 0);

    ramsn    : inout std_logic_vector(3 downto 0);
    ramoen   : inout std_logic_vector(3 downto 0);
    rwen     : inout std_logic_vector(3 downto 0);
    romsn    : inout std_logic_vector(1 downto 0);
    iosn     : inout std_logic;
    oen      : inout std_logic;
    read     : inout std_logic;
    writen   : inout std_logic;
    brdyn    : in  std_logic;
    bexcn    : in  std_logic;

    pio      : inout std_logic_vector(15 downto 0);
    wdogn    : inout std_logic;
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
end component;

end; 




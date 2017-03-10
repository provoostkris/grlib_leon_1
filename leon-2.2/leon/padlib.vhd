
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
-- Entity: 	various pads
-- File:	pads.vhd
-- Author:	Jiri Gaisler - ESA/ESTEC
-- Description:	generic and technology specific pads.
------------------------------------------------------------------------------

------------------------------------------------------------------
-- Pad package
------------------------------------------------------------------

LIBRARY ieee;
use IEEE.std_logic_1164.all; 

package padlib is

component inpad port (pad : in std_logic; q : out std_logic); end component;
component smpad port (pad : in std_logic; q : out std_logic); end component;
component outpad1 port (d : in std_logic; pad : out std_logic); end component;
component outpad2 port (d : in std_logic; pad : out std_logic); end component;
component outpad3 port (d : in std_logic; pad : out std_logic); end component;
component odpad port (d : in std_logic; pad : out std_logic); end component;
component iodpad port ( d : in std_logic; q : out std_logic; pad : inout std_logic); end component;
component iopad1
  port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
end component;
component iopad2
  port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
end component;
component iopad3
  port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
end component;
component smiopad 
  port ( d, en : in  std_logic; q : out std_logic; pad : inout std_logic);
end component; 

end padlib;


------------------------------------------------------------------
-- Pad models with technology selection --------------------------
------------------------------------------------------------------

-- input pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity inpad is port (pad : in std_logic; q : out std_logic); end; 

architecture rtl of inpad is
begin
  inf : if INFER_PADS generate
    ginpad0 : geninpad port map (q => q, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    ip2 : if TARGET_TECH = atc35 generate
      pc3d010 : pc3d01 port map (cin => q, pad => pad);
    end generate;
  end generate;
end;

-- input schmitt pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity smpad is port (pad : in std_logic; q : out std_logic); end; 

architecture rtl of smpad is
begin
  inf : if INFER_PADS generate
    gsmpad0 : gensmpad port map (pad => pad, q => q);
  end generate;
  ninf : if not INFER_PADS generate
    sm2 : if TARGET_TECH = atc35 generate
      pc3d210 : pc3d21 port map (cin => q, pad => pad);
    end generate;
  end generate;
end;

-- output pads

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity outpad1 is port (d : in std_logic; pad : out std_logic); end; 
architecture rtl of outpad1 is
begin
  inf : if INFER_PADS generate
    goutpad0 : genoutpad port map (d => d, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    op2 : if TARGET_TECH = atc35 generate
      pt3o030 : pt3o01 port map (i => d, pad => pad);
    end generate;
  end generate;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity outpad2 is port (d : in std_logic; pad : out std_logic); end; 
architecture rtl of outpad2 is
begin
  inf : if INFER_PADS generate
    goutpad0 : genoutpad port map (d => d, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    op2 : if TARGET_TECH = atc35 generate
      pt3o030 : pt3o02 port map (i => d, pad => pad);
    end generate;
  end generate;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity outpad3 is port (d : in std_logic; pad : out std_logic); end; 
architecture rtl of outpad3 is
begin
  inf : if INFER_PADS generate
    goutpad0 : genoutpad port map (d => d, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    op2 : if TARGET_TECH = atc35 generate
      pt3o030 : pt3o03 port map (i => d, pad => pad);
    end generate;
  end generate;
end;

-- bidirectional pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity iopad1 is
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of iopad1 is
signal eni : std_logic;
begin
  inf : if INFER_PADS generate
    giop0 : geniopad port map (d => d, en => en, q => q, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    iop2 : if TARGET_TECH = atc35 generate
      pt3b030 : pt3b01 port map (i => d, oen => en, cin => q, pad => pad);
    end generate;
  end generate;
end;
library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity iopad2 is
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of iopad2 is
signal eni : std_logic;
begin
  inf : if INFER_PADS generate
    giop0 : geniopad port map (d => d, en => en, q => q, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    iop2 : if TARGET_TECH = atc35 generate
      pt3b030 : pt3b02 port map (i => d, oen => en, cin => q, pad => pad);
    end generate;
  end generate;
end;

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity iopad3 is
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of iopad3 is
signal eni : std_logic;
begin
  inf : if INFER_PADS generate
    giop0 : geniopad port map (d => d, en => en, q => q, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    iop2 : if TARGET_TECH = atc35 generate
      pt3b030 : pt3b03 port map (i => d, oen => en, cin => q, pad => pad);
    end generate;
  end generate;
end;

-- bidirectional pad with schmitt trigger for I/O ports

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity smiopad is
  port (
    d     : in  std_logic;
    en    : in  std_logic;
    q     : out std_logic;
    pad   : inout std_logic
  );
end; 

architecture rtl of smiopad is
signal eni : std_logic;
begin
  inf : if INFER_PADS generate
    giop0 : geniopad port map (d => d, en => en, q => q, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    smiop2 : if TARGET_TECH = atc35 generate
      pt3b030 : pt3b03 port map (i => d, oen => en, cin => q, pad => pad);
    end generate;
  end generate;
end;

-- open-drain pad

library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;
 
entity odpad is port (d : in std_logic; pad : out std_logic); end; 
architecture rtl of odpad is
signal en, lp, gnd : std_logic;
begin
  gnd <= '0';
  inf : if INFER_PADS generate
    godpad0 : genodpad port map (d => d, pad => pad);
  end generate;
  ninf : if not INFER_PADS generate
    odp2 : if TARGET_TECH = atc35 generate
      pc3t01u0 : pc3t01u port map (i => gnd, oen => d, pad => pad);
    end generate;
  end generate;
end;

-- bi-directional open-drain
library IEEE;
use IEEE.std_logic_1164.all;
use work.target.all;
use work.config.all;
use work.padlib.all;
use work.tech_atc35.all;
use work.tech_generic.all;

entity iodpad is
  port ( d : in  std_logic; q : out std_logic; pad : inout std_logic);
end; 

architecture rtl of iodpad is
signal gnd : std_logic;
begin 
  gnd <= '0';
  ninf : if not INFER_PADS generate
    iodp0 : if TARGET_TECH = atc35 generate
      pt3b030 : pt3b03 port map (i => gnd, oen => d, cin => q, pad => pad);
    end generate;
  end generate;
  inf : if INFER_PADS generate
    giodp0 : geniodpad port map (d => d, q => q, pad => pad);
  end generate;
end;

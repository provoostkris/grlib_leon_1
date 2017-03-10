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
-- File:        debug.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Various test bench configurations
------------------------------------------------------------------------------  
-- Version control:
-- 11-09-1998:  : First implemetation
-- 26-09-1999:  : Release 1.0
------------------------------------------------------------------------------  


-- 32-bit prom, 32-bit ram, 0ws

configuration tb_32_0_32_0 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 0-ws",
        msg2 => "2x128 kbyte 32-bit ram, 0-ws",
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	ramedac  => false,
	romdepth => 11
      );
    end for;
  end for;
end tb_32_0_32_0;

-- 32-bit prom, 32-bit ram, 0ws, pci

configuration tb_32_0_32_0_pci of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 0-ws",
        msg2 => "2x128 kbyte 32-bit ram, 0-ws, PCI",
	pci => true,
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	ramedac  => false,
	romdepth => 11
      );
    end for;
  end for;
end tb_32_0_32_0_pci;

-- 32-bit prom, 32-bit ram, 0ws, debug

configuration tb_32_0_32_0_d of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 0-ws",
        msg2 => "2x128 kbyte 32-bit ram, 0-ws",
 	DISASS => 1,
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	ramedac  => false,
	romdepth => 11
      );
    end for;
  end for;
end tb_32_0_32_0_d;

-- 32-bit prom, 32-bit ram, 1ws

configuration tb_32_1_32_1 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 1-ws ",
        msg2 => "2x128 kbyte 32-bit ram, 1-ws",
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	romtacc  => 30,
	romdepth => 11,
	ramedac  => false,
	ramtacc  => 30
      );
    end for;
  end for;
end tb_32_1_32_1;

-- 32-bit prom, 32-bit ram, 1ws, debug

configuration tb_32_1_32_1_d of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 1-ws",
        msg2 => "2x128 kbyte 32-bit ram, 1-ws",
 	DISASS => 1,
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	romtacc  => 30,
	romdepth => 11,
	ramedac  => false,
	ramtacc  => 30
      );
    end for;
  end for;
end tb_32_1_32_1_d;

-- 32-bit prom, 32-bit ram, 3ws

configuration tb_32_3_32_3 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 32-bit rom, 3-ws",
        msg2 => "2x128 kbyte 32-bit ram, 3-ws",
        romfile  => "tsource/rom.dat",
	romwidth => 32,
	romedac  => false,
	romtacc  => 70,
	romdepth => 11,
	ramedac  => false,
	ramtacc  => 70
      );
    end for;
  end for;
end tb_32_3_32_3;

-- 16-bit prom, 16-bit ram, 0ws

configuration tb_16_0_16_0 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 16-bit rom, 0-ws",
        msg2 => "1x256 kbyte 16-bit ram, 0-ws",
        romfile  => "tsource/rom16.dat",
	romwidth => 16,
	romdepth => 12,
	romedac  => false,
        rambanks => 1,
	ramedac  => false,
        ramwidth => 16,
	ramdepth => 17
      );
    end for;
  end for;
end tb_16_0_16_0;

-- 16-bit prom, 16-bit ram, 0ws, disas

configuration tb_16_0_16_0_d of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 16-bit rom, 0-ws",
        msg2 => "1x256 kbyte 16-bit ram, 0-ws",
 	DISASS => 1,
        romfile  => "tsource/rom16.dat",
	romwidth => 16,
	romdepth => 12,
	romedac  => false,
	ramedac  => false,
        rambanks => 1,
        ramwidth => 16,
	ramdepth => 17
      );
    end for;
  end for;
end tb_16_0_16_0_d;

-- 16-bit prom, 16-bit ram, 1ws

configuration tb_16_1_16_1 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 16-bit rom, 1-ws",
        msg2 => "1x256 kbyte 16-bit ram, 1-ws",
        romfile  => "tsource/rom16.dat",
	romwidth => 16,
	romdepth => 12,
	romtacc  => 30,
	romedac  => false,
	ramedac  => false,
        rambanks => 1,
        ramwidth => 16,
	ramtacc  => 30,
	ramdepth => 17
      );
    end for;
  end for;
end tb_16_1_16_1;


-- 8-bit boot-prom, 8-bit ram, 0 ws

configuration tb_8_0_8_0 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 8-bit rom, 0-ws",
        msg2 => "1x256 kbyte 8-bit ram, 0-ws",
        romfile  => "tsource/rom8.dat",
        romwidth => 8,
	romdepth => 13,
	romedac  => false,
        ramwidth => 8,
	ramedac  => false,
	ramdepth => 18
      );
    end for;
  end for;
end tb_8_0_8_0;

-- 8-bit boot-prom, 8-bit ram, 0 ws, debug

configuration tb_8_0_8_0_d of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 8-bit rom, 0-ws",
        msg2 => "1x256 kbyte 8-bit ram, 0-ws",
 	DISASS => 1,
        romfile  => "tsource/rom8.dat",
        romwidth => 8,
	romdepth => 13,
	romedac  => false,
        ramwidth => 8,
	ramedac  => false,
	ramdepth => 18
      );
    end for;
  end for;
end tb_8_0_8_0_d;

-- 8-bit boot-prom, 8-bit ram, 1 ws

configuration tb_8_1_8_1 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 8-bit rom, 1-ws",
        msg2 => "1x256 kbyte 8-bit ram, 1-ws",
        romfile  => "tsource/rom8.dat",
        romwidth => 8,
	romdepth => 13,
	romedac  => false,
	romtacc  => 30,
        ramwidth => 8,
	ramdepth => 18,
	ramedac  => false,
	ramtacc  => 30
      );
    end for;
  end for;
end tb_8_1_8_1;

-- 8-bit boot-prom, 8-bit ram, 1 ws, debug

configuration tb_8_1_8_1_d of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 8-bit rom, 1-ws",
        msg2 => "1x256 kbyte 8-bit ram, 1-ws",
 	DISASS => 1,
        romfile  => "tsource/rom8.dat",
        romwidth => 8,
	romdepth => 13,
	romedac  => false,
	romtacc  => 30,
        ramwidth => 8,
	ramdepth => 18,
	ramedac  => false,
	ramtacc  => 30
      );
    end for;
  end for;
end tb_8_1_8_1_d;

-- 8-bit boot-prom, 8-bit ram, 2 ws

configuration tb_8_2_8_2 of tbleon is
  for behav 
    for all: 
      tbgen use entity work.tbgen(behav) generic map ( 
        msg1 => "8 kbyte 8-bit rom, 2-ws",
        msg2 => "1x256 kbyte 8-bit ram, 2-ws",
        romfile  => "tsource/rom8.dat",
        romwidth => 8,
	romdepth => 13,
	romedac  => false,
	romtacc  => 50,
        ramwidth => 8,
	ramdepth => 18,
	ramedac  => false,
	ramtacc  => 50
      );
    end for;
  end for;
end tb_8_2_8_2;


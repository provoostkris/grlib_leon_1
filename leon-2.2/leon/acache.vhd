
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
-- Entity:      acache
-- File:        acache.vhd
-- Author:      Jiri Gaisler - ESA/ESTEC
-- Description: Interface module between I/D cache controllers and Amba AHB
------------------------------------------------------------------------------  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use work.target.all;
use work.config.all;
use work.iface.all;
use work.amba.all;


entity acache is
  port (
    rst    : in  std_logic;
    clk    : in  clk_type;
    mcii   : in  memory_ic_in_type;
    mcio   : out memory_ic_out_type;
    mcdi   : in  memory_dc_in_type;
    mcdo   : out memory_dc_out_type;
    iui    : in  iu_in_type;
    iuo    : in  iu_out_type;
    apbi   : in  apb_slv_in_type;
    apbo   : out apb_slv_out_type;
    ahbi   : in  ahb_mst_in_type;
    ahbo   : out ahb_mst_out_type
  );
end;

architecture rtl of acache is

-- cache control register type

type cctrltype is record
  ib     : std_logic;				-- icache burst enable
  dfrz   : std_logic;				-- dcache freeze enable
  ifrz   : std_logic;				-- icache freeze enable
  dcs    : std_logic_vector(1 downto 0);	-- dcache state
  ics    : std_logic_vector(1 downto 0);	-- icache state
end record;

type reg_type is record
  bg    : std_logic; 	-- bus grant
  bo    : std_logic; 	-- bus owner
  ba    : std_logic;	-- bus active
  retry : std_logic;	-- retry/split pending
  werr  : std_logic;	-- write error
  cctrl		   : cctrltype;
  pwd   : std_logic;	-- power-down
end record;

signal r, rin : reg_type;
begin
  comb : process(ahbi, r, rst, mcii, mcdi, iuo, apbi)
  variable v : reg_type;
  variable haddr   : std_logic_vector(31 downto 0);   -- address bus
  variable htrans  : std_logic_vector(1 downto 0);    -- transfer type 
  variable hwrite  : std_logic;  		      -- read/write
  variable hlock   : std_logic;  		      -- bus lock
  variable hsize   : std_logic_vector(2 downto 0);    -- transfer size
  variable hburst  : std_logic_vector(2 downto 0);    -- burst type
  variable hwdata  : std_logic_vector(31 downto 0);   -- write data
  variable hbusreq : std_logic;   -- bus request
  variable iready, dready : std_logic;   
  variable igrant, dgrant : std_logic;   
  variable iretry, dretry : std_logic;   
  variable ihcache, dhcache : std_logic;   
  variable imexc, dmexc, nbo, dreq : std_logic;   
  variable cctrl   : std_logic_vector(31 downto 0);
  begin

-- initialisation

    htrans := HTRANS_IDLE;
    v := r; iready := '0'; v.werr := '0';
    dready := '0'; igrant := '0'; dgrant := '0'; 
    imexc := '0'; dmexc := '0'; hlock := '0'; iretry := '0'; dretry := '0';
    ihcache := '0'; dhcache := '0';

-- generate AHB signals

    dreq := mcdi.req and not r.pwd;
    hbusreq := mcii.req or dreq;
    if hbusreq = '1' then htrans := HTRANS_NONSEQ; end if;
    hwdata := mcdi.data;
    nbo := (dreq and not (r.ba and mcii.req and not r.bo));

    if nbo = '0' then
      haddr := mcii.address; hwrite := '0'; hsize := HSIZE_WORD; hlock := '0';
      if mcii.burst = '1' then hburst := HBURST_INCR; 
      else hburst := HBURST_SINGLE; end if;
      if (mcii.req and r.ba and not r.bo and not r.retry) = '1' then
        htrans := HTRANS_SEQ; haddr(4 downto 2) := haddr(4 downto 2) +1;
        hburst := HBURST_INCR; 
      end if;
      if (mcii.req and r.bg and ahbi.hready and not r.retry) = '1' 
      then igrant := '1'; end if; 
    else
      haddr := mcdi.address; hwrite := not mcdi.read; hsize := '0' & mcdi.size;
      hlock := mcdi.lock;
      if hsize = "011" then hsize := "010"; end if;
      if mcdi.burst = '1' then hburst := HBURST_INCR; 
      else hburst := HBURST_SINGLE; end if;
      if (dreq and r.ba and r.bo and not r.retry) = '1' then 
        htrans := HTRANS_SEQ; haddr(4 downto 2) := haddr(4 downto 2) +1;
        hburst := HBURST_INCR; 
      end if;
      if (dreq and r.bg and ahbi.hready and not r.retry) = '1' 
      then dgrant := '1'; end if; 
    end if;

    if (r.ba = '1') and 
       ((ahbi.hresp = HRESP_RETRY) or (ahbi.hresp = HRESP_SPLIT))
    then v.retry := not ahbi.hready; else v.retry := '0'; end if;
      
    if r.retry = '1' then htrans := HTRANS_IDLE; end if;

    if r.bo = '0' then
      if r.ba = '1' then
	ihcache := ahbi.hcache;
        if ahbi.hready = '1' then
	  case ahbi.hresp is
	  when HRESP_OKAY => iready := '1'; 
	  when HRESP_RETRY | HRESP_SPLIT=> iretry := '1'; 
	  when others => iready := '1'; imexc := '1';
	  end case;
        end if;
      end if;
    else
      if r.ba = '1' then
	dhcache := ahbi.hcache;
        if ahbi.hready = '1' then
	  case ahbi.hresp is
	  when HRESP_OKAY => dready := '1'; 
	  when HRESP_RETRY | HRESP_SPLIT=> dretry := '1'; 
	  when others => dready := '1'; dmexc := '1'; v.werr := not mcdi.read;
	  end case;
        end if;
      end if;
    end if;

    if ahbi.hready = '1' then
      v.bo := nbo; 
      v.bg := ahbi.hgrant;
      if (htrans = HTRANS_NONSEQ) or (htrans = HTRANS_SEQ) then
	v.ba := r.bg;
      else v.ba := '0'; end if;
    end if;

-- cache control and power-down handling

    -- cache freeze operation
    if (r.cctrl.ifrz and iuo.intack and r.cctrl.ics(0)) = '1' then
      v.cctrl.ics := "01";
    end if;
    if (r.cctrl.dfrz and iuo.intack and r.cctrl.dcs(0)) = '1' then
      v.cctrl.dcs := "01";
    end if;

    if (apbi.psel and apbi.penable and apbi.pwrite) = '1' then
      case apbi.paddr(2 downto 2) is
      when "1" =>
        v.cctrl.ib   := apbi.pwdata(16);
        v.cctrl.dfrz := apbi.pwdata(5);
        v.cctrl.ifrz := apbi.pwdata(4);
        v.cctrl.dcs  := apbi.pwdata(3 downto 2);
        v.cctrl.ics  := apbi.pwdata(1 downto 0);
      when others =>
	v.pwd := '1';
      end case;
    end if;

    cctrl := (others => '0');
    cctrl(16 downto 14) := r.cctrl.ib & mcii.flush  &  mcdi.flush; 
    cctrl(5 downto 0) := r.cctrl.dfrz & r.cctrl.ifrz & r.cctrl.dcs & r.cctrl.ics;
  
    v.pwd := v.pwd and not iuo.ipend;

-- reset operation

    if rst = '0' then
      v.bg := '0'; v.bo := '0'; v.ba := '0'; v.retry := '0'; v.werr := '0';
      if (BOOTOPT = icache) then
        v.cctrl.dcs := "01"; v.cctrl.ics := "01";
      else
        v.cctrl.dcs := "00"; v.cctrl.ics := "00";
      end if;
      v.cctrl.ib := '0'; v.pwd := '0';
    end if;

-- drive ports

    ahbo.haddr   <= haddr ;
    ahbo.htrans  <= htrans;
    ahbo.hbusreq <= hbusreq;
    ahbo.hwdata  <= hwdata;
    ahbo.hlock   <= hlock;
    ahbo.hwrite  <= hwrite;
    ahbo.hsize   <= hsize;
    ahbo.hburst  <= hburst;
    ahbo.hprot   <= (others => '0');
    mcio.grant   <= igrant;
    mcio.ready   <= iready;
    mcio.mexc    <= imexc;
    mcio.retry   <= iretry;
    mcio.cache   <= ihcache;
    mcdo.grant   <= dgrant;
    mcdo.ready   <= dready;
    mcdo.mexc    <= dmexc;
    mcdo.retry   <= dretry;
    mcdo.werr    <= r.werr;
    mcdo.cache   <= dhcache;
    apbo.prdata  <= cctrl;

    rin <= v;

  end process;

  mcio.data <= ahbi.hrdata; mcdo.data <= ahbi.hrdata;

  mcio.ics <= r.cctrl.ics; mcdo.dcs <= r.cctrl.dcs;
  mcio.burst <= r.cctrl.ib;

  reg : process(clk)
  begin if rising_edge(clk) then r <= rin; end if; end process;


end;


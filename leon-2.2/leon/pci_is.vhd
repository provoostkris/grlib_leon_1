-------------------------------------------------------------------------------
-- Title         : PCI interface for LEON processor
-- Project       : pci4leon
-------------------------------------------------------------------------------
-- File          : pci.vhd
-- Author        : Roland Weigand  <weigand@ws.estec.esa.nl>
-- Created       : 2000/02/29
-- Last modified : 2000/02/29
-------------------------------------------------------------------------------
-- Description :
-- This Unit is the top level of the PCI interface. It is connected
-- to the peripheral bus of LEON and the DMA port.
-- PCI ports must be connected to the top level pads.
-- It includes the Phoenix/In-Silicon PCI core
-------------------------------------------------------------------------------
-- THIS IS JUST A DUMMY VERSION TO TEST THE LEON/AHB INTERFACE
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

use work.amba.all;
use work.iface.all;

entity pci_is is
   port (
      rst             : in  std_logic;
      app_clk         : in  clk_type;
      cfg_clk         : in  clk_type;          -- switched clock for PCI config regs

      -- peripheral bus
      pbi             : in  APB_Slv_In_Type;   -- peripheral bus in
      pbo             : out APB_Slv_Out_Type;  -- peripheral bus out
      irq             : out std_logic;         -- interrupt request

      -- PCI-Target DMA-Port = AHB master
      TargetMasterOut : out ahb_mst_out_type;  -- dma port out
      TargetMasterIn  : in  ahb_mst_in_type;   -- dma port in
--    TargetAsi       : out std_logic_vector(3 downto 0);  -- sparc ASI

      -- PCI PORTS for top level
      pci_in          : in  pci_in_type;       -- PCI bus inputs
      pci_out         : out pci_out_type;      -- PCI bus outputs

      -- PCI-Master Word-Interface = AHB slave
      MasterSlaveOut  : out ahb_slv_out_type;  -- Direct master I/F
      MasterSlaveIn   : in  ahb_slv_in_type;   -- Direct master I/F

      -- PCI-Master DMA-Port = AHB master
      MasterMasterOut : out ahb_mst_out_type;  -- dma port out
      MasterMasterIn  : in  ahb_mst_in_type    -- dma port in
--    MasterAsi       : out std_logic_vector(3 downto 0);  -- sparc ASI
       
      );
end;      

architecture struct of pci_is is
begin

    MasterMasterOut.haddr   <= (others => '0') ;
    MasterMasterOut.htrans  <= HTRANS_IDLE;
    MasterMasterOut.hbusreq <= '0';
    MasterMasterOut.hwdata  <= (others => '0');
    MasterMasterOut.hlock   <= '0';
    MasterMasterOut.hwrite  <= '0';
    MasterMasterOut.hsize   <= HSIZE_WORD;
    MasterMasterOut.hburst  <= HBURST_SINGLE;
    MasterMasterOut.hprot   <= (others => '0');      

    TargetMasterOut.haddr   <= (others => '0') ;
    TargetMasterOut.htrans  <= HTRANS_IDLE;
    TargetMasterOut.hbusreq <= '0';
    TargetMasterOut.hwdata  <= (others => '0');
    TargetMasterOut.hlock   <= '0';
    TargetMasterOut.hwrite  <= '0';
    TargetMasterOut.hsize   <= HSIZE_WORD;
    TargetMasterOut.hburst  <= HBURST_SINGLE;
    TargetMasterOut.hprot   <= (others => '0');      

    MasterSlaveOut.hrdata <= (others => '0');
    MasterSlaveOut.hready <= '1';
    MasterSlaveOut.hresp  <= HRESP_OKAY;         

    irq <= '0';
end;

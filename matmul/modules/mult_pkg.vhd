------------------------------------------------------------------------------

-- Title      :  Matrix multiplication package

------------------------------------------------------------------------------

-- Author     :  Melissa Aguiar

-- Company    : CNPEM LNLS-DIG

-- Platform   : FPGA-generic

-------------------------------------------------------------------------------

-- Description:  Package for the matrix multiplication core

-------------------------------------------------------------------------------

-- Copyright (c) 2020 CNPEM

-- Licensed under GNU Lesser General Public License (LGPL) v3.0

-------------------------------------------------------------------------------

-- Revisions  :

-- Date        Version  Author                Description

-- 2021-04-07  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mult_pkg is

  type t_record is
  record
  r_a : signed(32-1 downto 0);   -- value of input a[k]
  r_k : unsigned(32-1 downto 0); -- value of index k
  end record;

  component matmul is
    generic(
      -- Width for input a[k]
      g_a_width                       : natural := 32;
      -- Width for input b[k]
      g_b_width                       : natural := 32;
      -- Width for output c
      g_c_width                       : natural := 32
      );
    port(
      -- Core clock
      clk_i                           : in std_logic;
      -- Reset
      rst_n_i                         : in std_logic;
      -- Clear
      clear_acc_i                     : in std_logic;
      -- Data valid input
      valid_i                         : in std_logic;
      -- Input a[k]
      a_i                             : in signed(g_a_width-1 downto 0);
      -- Input b[k]
      b_i                             : in signed(g_b_width-1 downto 0);
      -- Result output
      c_o                             : out signed(g_c_width-1 downto 0);
      -- Data valid output
      valid_o                         : out std_logic
      );
  end component;

  component mac_fofb is

  generic(
    -- Width for input a[k]
    g_a_width                         : natural := 32;
    -- Width for input b[k]
    g_b_width                         : natural := 32;
    -- Width for output c
    g_c_width                         : natural := 32;
    -- Extra bits for accumulator
    g_extra_width                     : natural := 4
    );

  port (
    -- Core clock
    clk_i                             : in std_logic;
    -- Reset
    rst_n_i                           : in std_logic;
    -- Data valid input
    valid_i                           : in std_logic;
    -- Input a[k] and index k
    a_i                               : in t_record;
    -- Input b[k]
    b_i                               : in signed(g_b_width-1 downto 0);
    -- Result output
    c_o                               : out signed(g_c_width-1 downto 0);
    -- Data valid output
    valid_o                           : out std_logic;
    -- Validate the end of fofb cycle
    valid_end_o                       : out std_logic
    );
  end component;

end package mult_pkg;

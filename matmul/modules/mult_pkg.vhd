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

-- 2021-30-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mult_pkg is

  type t_record is
  record
    r_a : unsigned(32-1 downto 0); -- value of input a[k]
    r_k : unsigned(32-1 downto 0); -- value of index k
  end record;

  component matmul is
    generic(
      -- Width for input b[k]
      g_b_width                 : natural := 32;
      -- Width for output c
      g_c_width                 : natural := 32
      );
    port(
      -- Core clock
      clk_i                     : in std_logic;
      -- Reset
      rst_n_i                   : in std_logic;
      -- Data valid input
      v_i                       : in std_logic;
      -- Input a[k] and index k
      a_i                       : in t_record;
      -- Input b[k]
      b_i                       : in unsigned(g_b_width-1 downto 0);
      -- Result output
      c_o                       : out unsigned(g_c_width-1 downto 0);
      -- Data valid output
      v_o                       : out std_logic
      );
  end component;
end package mult_pkg;

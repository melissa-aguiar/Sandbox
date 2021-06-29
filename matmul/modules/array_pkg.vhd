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

-- 2021-18-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_pkg is

  type t_record is
  record
    r_a : signed(32-1 downto 0);   -- value of input a[k]
    r_k : unsigned(32-1 downto 0); -- value of index k
  end record;

  component matmul is
    port(
      clk_i   : in std_logic;
      rst_n_i : in std_logic;
      v_i     : in std_logic;
      a_i     : in t_record;
      c_o     : out signed(32-1 downto 0);
      v_o     : out std_logic
      );
  end component;
end package array_pkg;

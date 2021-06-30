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

-- 2021-29-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mult_pkg is

--   type t_record is
--   record
--     r_a : unsigned(32-1 downto 0);   -- value of input a[k]
--     r_k : unsigned(32-1 downto 0); -- value of index k
--   end record;

  component matmul is
  generic(
    -- Width for input a[k]
    g_a_width                         : natural := 16;
    -- Width for input b[k]
    g_b_width                         : natural := 16;
    -- Input data tag width
    g_tag_width                       : natural := 1;
    -- Width for output c
    g_c_width                         : natural := 16;
    -- Multiplier pipeline
    g_levels                          : natural := 7
    );
  port (
    -- Core clock
    clk_i                           : in std_logic;
    -- Reset
    rst_n_i                         : in std_logic;
    -- Data valid input
    valid_i                         : in std_logic;
    -- Data tag input
    tag_i                           : in std_logic_vector(g_tag_width-1 downto 0);
    -- Input a[k] and index k
    a_i                             : in std_logic_vector(g_a_width-1 downto 0);
    -- Input b[k]
    b_i                             : in std_logic_vector(g_b_width-1 downto 0);
    -- Result output
    c_o                             : out std_logic_vector(g_c_width-1 downto 0);
    -- Data tag output
    tag_o                           : out std_logic_vector(g_tag_width-1 downto 0);
    -- Data valid output
    valid_o                         : out std_logic
    );
  end component;
end package mult_pkg;

------------------------------------------------------------------------------

-- Title      :  Matrix multiplication testbench

------------------------------------------------------------------------------

-- Author     :  Melissa Aguiar

-- Company    : CNPEM LNLS-DIG

-- Platform   : FPGA-generic

-------------------------------------------------------------------------------

-- Description:  Testbench for the matrix multiplication core

-------------------------------------------------------------------------------

-- Copyright (c) 2020 CNPEM

-- Licensed under GNU Lesser General Public License (LGPL) v3.0

-------------------------------------------------------------------------------

-- Revisions  :

-- Date        Version  Author                Description

-- 2021-29-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

--library UNISIM;
--use UNISIM.vcomponents.all;

-- library work;
-- use work.matmul.all;

library work;
use work.mult_pkg.all;

entity mult_tb is
end mult_tb;

architecture behave of mult_tb is

  constant clk_period : time := 10 ns;

  -- Width for input a[k]
  constant g_a_width                         : natural := 16;
  -- Width for input b[k]
  constant g_b_width                         : natural := 16;
  -- Input data tag width
  constant g_tag_width                       : natural := 1;
  -- Width for output c
  constant g_c_width                         : natural := 16;
  -- Multiplier pipeline
  constant g_levels                          : natural := 7;

  -- Core clock
  signal clk_s                           : std_logic := '0';
  -- Reset
  signal rst_s                           : std_logic := '0';
  -- Data valid input
  signal valid_i_s                       : std_logic := '0';
  -- Data tag input
  signal tag_i_s                         : std_logic_vector(g_tag_width-1 downto 0) := (others => '0');
  -- Input a[k] and index k
  signal a_s                             : std_logic_vector(g_a_width-1 downto 0);
  -- Input b[k]
  signal b_s                             : std_logic_vector(g_b_width-1 downto 0);
  -- Result output
  signal c_s                             : std_logic_vector(g_c_width-1 downto 0);
  -- Data tag output
  signal tag_o_s                         : std_logic_vector(g_tag_width-1 downto 0);
  -- Data valid output
  signal valid_o_s                       : std_logic := '0';

begin

  matmul_INST : matmul
  port map (
    clk_i         => clk_s,
    rst_n_i       => rst_s,
    valid_i       => valid_i_s,
    tag_i         => tag_i_s,
    a_i           => a_s,
    b_i           => b_s,
    c_o           => c_s,
    tag_o         => tag_o_s,
    valid_o       => valid_o_s
    );

  clk_process : process is
  begin
    wait for clk_period/2;
    clk_s <= not clk_s;
  end process clk_process;

  process
  begin

  --rst_s <= '0';

  --wait for clk_period;

  rst_s <= '1';

  valid_i_s <= '1';

  a_s <= std_logic_vector(to_signed(1, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;

  a_s <= std_logic_vector(to_signed(2, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;

  --valid_i_s <= '0';

  wait for clk_period;

  --valid_i_s <= '1';

  a_s <= std_logic_vector(to_signed(3, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;

  a_s <= std_logic_vector(to_signed(3, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;

  a_s <= std_logic_vector(to_signed(1, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;

  a_s <= std_logic_vector(to_signed(2, a_s'length));
  b_s <= std_logic_vector(to_signed(1, b_s'length));

  wait for clk_period;
  wait for clk_period;

  if c_s = std_logic_vector(to_signed(6, c_s'length)) then
      report "SUCESS";
  --else
   --   report "FAILURE";
  end if;

  end process;

end behave;

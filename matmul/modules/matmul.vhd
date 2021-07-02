------------------------------------------------------------------------------

-- Title      :  Matrix multiplication

------------------------------------------------------------------------------

-- Author     :  Melissa Aguiar

-- Company    : CNPEM LNLS-DIG

-- Platform   : FPGA-generic

-------------------------------------------------------------------------------

-- Description:  Matrix multiplication module for the Fast Orbit Feedback

-------------------------------------------------------------------------------

-- Copyright (c) 2020 CNPEM

-- Licensed under GNU Lesser General Public License (LGPL) v3.0

-------------------------------------------------------------------------------

-- Revisions  :

-- Date        Version  Author                Description

-- 2021-01-07  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.mult_pkg.all;

entity matmul is
  generic(
    -- Width for input a[k]
    g_a_width                   : natural := 32;
    -- Width for input b[k]
    g_b_width                   : natural := 32;
    -- Width for output c
    g_c_width                   : natural := 32
  );
  port (
    -- Core clock
    clk_i                       : in std_logic;
    -- Reset
    rst_n_i                     : in std_logic;
    -- Clear
    clr_n_i                     : in std_logic;
    -- Data valid input
    v_i                         : in std_logic;
    -- Input a[k]
    a_i                         : in unsigned(g_a_width-1 downto 0);
    -- Input b[k]
    b_i                         : in unsigned(g_b_width-1 downto 0);
    -- Result output
    c_o                         : out unsigned(g_c_width-1 downto 0);
    -- Data valid output
    v_o                         : out std_logic
    );
end matmul;

architecture behave of matmul is

  attribute use_dsp : string;
  attribute use_dsp of behave    : architecture is "yes";

  signal result_s, prod_s, prod  : unsigned(2*g_c_width-1 downto 0) := (others =>'0');
  signal a_s, b_s                : unsigned(g_b_width-1 downto 0)   := (others =>'0');

begin
  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then
    if (rst_n_i = '0') then
      result_s <= (others =>'0');
      prod_s <= (others =>'0');
    else
      a_s <= a_i;
      b_s <= b_i;

      prod_s <= a_s*b_s;
      prod <= prod_s;
      
      result_s <= result_s + prod;
 
      if (clr_n_i = '0') then
        result_s <= (others =>'0');
      end if;
    end if; -- Reset
  end if; -- Clock
end process;
  c_o <= resize(result_s, c_o'length);
end behave;

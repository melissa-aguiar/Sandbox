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

-- 2021-02-07  1.0      melissa.aguiar        Created

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
    clr_p_i                     : in std_logic;
    -- Data valid input
    valid_i                     : in std_logic;
    -- Input a[k]
    a_i                         : in unsigned(g_a_width-1 downto 0);
    -- Input b[k]
    b_i                         : in unsigned(g_b_width-1 downto 0);
    -- Result output
    c_o                         : out unsigned(g_c_width-1 downto 0);
    -- Data valid output
    valid_o                     : out std_logic
    );
end matmul;

architecture behave of matmul is
  -- Attribute to use DSP
  attribute use_dsp                              : string;
  attribute use_dsp of behave                    : architecture is "yes";
  -- Registers for intermediate values
  signal mult_reg_s, adder_out_s, old_result_s   : unsigned(2*g_c_width-1 downto 0) := (others =>'0');
  signal a_reg_s, b_reg_s                        : unsigned(g_b_width-1 downto 0)   := (others =>'0');
  signal clr_reg_s                               : std_logic;

begin

  process (adder_out_s, clr_reg_s)
  begin
    if (clr_reg_s = '1') then
      -- Clear the accumulated data
      old_result_s <= (others => '0');
      -- Validating the last output before it's cleared
      valid_o <= '1';
    else
      -- Update old result
      old_result_s <= adder_out_s;
      -- The output is not valid yet
      valid_o <= '0';
    end if;
  end process;

  process (clk_i)
  begin
    if (rising_edge(clk_i)) then
      if rst_n_i = '0' then
        adder_out_s <= (others => '0');
      else
        -- Store the inputs in a register
        a_reg_s <= a_i; -- The inputs must have a valid bit
        b_reg_s <= b_i;
        -- Store multiplication result in a register
        mult_reg_s <= a_reg_s * b_reg_s;
        -- Store clear in a register
        clr_reg_s <= clr_p_i;
        -- Store accumulation result in a register
        adder_out_s <= old_result_s + mult_reg_s;
      end if;
    end if;
  end process;
  -- Truncate the output
  c_o <= resize(adder_out_s, c_o'length); -- The output must have a valid bit
end behave;

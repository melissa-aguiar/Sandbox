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
    -- Data valid input
    v_i                         : in std_logic;
    -- Input a[k] and index k
    a_i                         : in t_record;
    -- Input b[k]
    b_i                         : in unsigned(g_b_width-1 downto 0);
    -- Result output
    c_o                         : out unsigned(g_c_width-1 downto 0);
    -- Data valid output
    v_o                         : out std_logic
    );
end matmul;

architecture behave of matmul is
  signal a_s                    : t_record;
  signal result_s               : unsigned(2*g_c_width-1 downto 0) := (others =>'0');
  signal a, b                   : unsigned(g_b_width-1 downto 0)   := (others =>'0');
  signal r1, r2, r3, r4, r5, r6 : unsigned(2*g_c_width-1 downto 0) := (others =>'0');
  constant cnt_max              : integer                          := 3;
  signal cnt                    : integer range 0 to cnt_max+1     := 0;

begin
  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then
    if rst_n_i = '0' then
      cnt <= 0;
      result_s <= (others =>'0');
      c_o <= (others =>'0');
    else
      a <= a_i.r_a;
      b <= b_i;
      if v_i = '1' then
        result_s <= result_s + a*b; -- The optimal number of pipeline stagies is 6
        r1 <= result_s;
        r2 <= r1;
        r3 <= r2;
        r4 <= r3;
        r5 <= r4;
        r6 <= r5;
        cnt <= cnt + 1;
        v_o <= '0';
      end if;

      if cnt = cnt_max then
        c_o <= resize(result_s, c_o'length); -- Studies to round the output
        result_s <= (others =>'0');
        cnt <= 0;
        v_o <= '1';
      end if;
    end if;
  end if;
end process;
end behave;

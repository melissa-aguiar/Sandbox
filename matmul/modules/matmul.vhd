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

-- 2021-29-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.mult_pkg.all;

entity matmul is
  generic(
  g_BITS : natural := 32
  );
  port (
    -- Core clock
    clk_i                           : in std_logic;
    -- Reset
    rst_n_i                         : in std_logic;
    -- Data valid input
    v_i                             : in std_logic;
    -- Input a[k] and index k
    a_i                             : in t_record;
    -- Input b[k]
    b_i                             : in signed(g_BITS-1 downto 0);
    -- Result output
    c_o                             : out signed(g_BITS-1 downto 0);
    -- Data valid output
    v_o                             : out std_logic
    );
end matmul;

architecture behave of matmul is
  signal result_s        : signed(2*g_BITS-1 downto 0) := (others =>'0');
  signal a_s             : t_record;
  constant cnt_max       : integer := 3;
  signal cnt             : integer range 0 to cnt_max+1 := 0;

begin
  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then
    if rst_n_i='0' then
      cnt <= 0;
      result_s <= (others =>'0');
      c_o <= (others =>'0');
    else

      if v_i='1' then
        result_s <= result_s + a_s.r_a*b_i; -- Add pipeline stages here
        cnt <= cnt + 1;
        v_o <= '0';
      end if;

      if cnt=cnt_max then
        c_o <= resize(result_s, c_o'length); -- Studies to round the output
        cnt <= 0;
        result_s <= (others =>'0');
        v_o <= '1';
      end if;
    end if;
  end if;
end process;
  a_s <= a_i;
end behave;

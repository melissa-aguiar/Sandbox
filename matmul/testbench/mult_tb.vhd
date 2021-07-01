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

-- 2021-30-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.mult_pkg.all;

entity mult_tb is
end mult_tb;

architecture behave of mult_tb is

  constant clk_period : time := 10 ns;

  constant g_b_width  : natural := 32;
  constant g_c_width  : natural := 32;

  signal clk_s        : std_logic := '0';
  signal rst_s        : std_logic := '0';
  signal v_i_s        : std_logic := '0';
  signal a_s          : t_record;
  signal b_s          : unsigned(g_b_width-1 downto 0) := (others => '0');
  signal c_s          : unsigned(g_c_width-1 downto 0);
  signal v_o_s        : std_logic := '0';

begin

  matmul_INST : matmul
  port map (
    clk_i   => clk_s,
    rst_n_i => rst_s,
    v_i     => v_i_s,
    a_i     => a_s,
    b_i     => b_s,
    c_o     => c_s,
    v_o     => v_o_s
    );

  clk_process : process is
  begin
    wait for clk_period/2;
    clk_s <= not clk_s;
  end process clk_process;

  process
  begin

    rst_s <= '1';

    v_i_s <= '1';

    a_s.r_a <= to_unsigned(1, a_s.r_a'length);
    a_s.r_k <= to_unsigned(2, a_s.r_k'length);
    b_s <= to_unsigned(1, b_s'length);

    wait for clk_period;

    a_s.r_a <= to_unsigned(2, a_s.r_a'length);
    a_s.r_k <= to_unsigned(1, a_s.r_k'length);

    wait for clk_period;

    a_s.r_a <= to_unsigned(3, a_s.r_a'length);
    a_s.r_k <= to_unsigned(0, a_s.r_k'length);

    wait for clk_period;

    a_s.r_a <= to_unsigned(3, a_s.r_a'length);
    a_s.r_k <= to_unsigned(2, a_s.r_k'length);
    b_s <= to_unsigned(2, b_s'length);

    wait for clk_period;

    a_s.r_a <= to_unsigned(2, a_s.r_a'length);
    a_s.r_k <= to_unsigned(1, a_s.r_k'length);

    wait for clk_period;

    a_s.r_a <= to_unsigned(1, a_s.r_a'length);
    a_s.r_k <= to_unsigned(0, a_s.r_k'length);

    wait for clk_period;
    wait for clk_period;

    if c_s = to_unsigned(6, c_s'length) then -- 1*1 + 2*1 + 3*1
      report "SUCESS";
    else
        report "FAILURE";
    end if;

  end process;

end behave;

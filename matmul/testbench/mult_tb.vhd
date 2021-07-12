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

-- 2021-12-07  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

library work;
use work.mult_pkg.all;

entity mult_tb is
end mult_tb;

architecture behave of mult_tb is

  constant clk_period : time      := 10 ns;

  constant g_a_width  : natural   := 32;
  constant g_b_width  : natural   := 32;
  constant g_c_width  : natural   := 32;

  signal clk_s        : std_logic := '0';
  signal rst_s        : std_logic := '0';
  signal v_i_s        : std_logic := '0';
  signal v_o_s        : std_logic := '0';
  signal a_s          : t_record;
  signal b_s          : signed(g_b_width-1 downto 0) := (others => '0');
  signal c_s          : signed(g_c_width-1 downto 0);

  signal valid_tr     : std_logic;

begin

  mac_fofb_INST : mac_fofb
  port map (
    clk_i       => clk_s,
    rst_n_i     => rst_s,
    valid_i    => v_i_s,
    a_i        => a_s,
    b_i        => b_s,
    c_o        => c_s,
    valid_o    => v_o_s
    );

  clk_process : process is
  begin
    wait for clk_period/2;
    clk_s <= not clk_s;
  end process clk_process;

  valid_tr_gen : process
  begin
  if rst_s = '1' then
      valid_tr <= '0';
      wait for clk_period;
      valid_tr <= '1';
      wait for clk_period;
    else
      valid_tr <= '0';
      wait for clk_period;
    end if;
  end process;

  input_read : process(clk_s)
    file a_data_file            : text open read_mode is "a_k.txt";
    file b_data_file            : text open read_mode is "b_k.txt";
    variable a_line, b_line     : line;
    variable a_datain, b_datain : integer;
    begin
      if rising_edge(clk_s) then
        rst_s <= '1';
        if not endfile(a_data_file) and valid_tr = '1' then
          -- Reading input a[k] from a txt file
          readline(a_data_file, a_line);
          read(a_line, a_datain);
          -- Reading input b[k] from a txt file
          readline(b_data_file, b_line);
          read(b_line, b_datain);
          -- Pass the variable to a signal
          a_s.r_a <= to_signed(a_datain, a_s.r_a'length);
          b_s     <= to_signed(b_datain, b_s'length);
          -- Update valid input bit
          v_i_s <= '1';
        else
        -- Update valid input bit
          v_i_s <= '0';
        end if;
      end if;
  end process input_read;

  output_write : process(clk_s)
    file ouput_file   : text open write_mode is "my_output.txt";
    variable c_line   : line;
    variable dataout  : integer;
    begin
      if rising_edge(clk_s) then
        -- Write output to a txt file
        dataout := to_integer(c_s);
        write(c_line, dataout);
        writeline(ouput_file, c_line);
      end if;
  end process output_write;
  end architecture behave;

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

-- 2021-30-06  1.0      melissa.aguiar        Created

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
    g_c_width                   : natural := 32;
    -- Multiplier pipeline
    g_levels                    : natural := 6
  );
  port (
    -- Core clock
    clk_i                       : in std_logic;
    -- Reset
    rst_n_i                     : in std_logic;
    -- Data valid input
    valid_i                     : in std_logic;
    -- Input a[k] and index k
    a_i                         : in t_record;
    -- Input b[k]
    b_i                         : in unsigned(g_b_width-1 downto 0);
    -- Result output
    c_o                         : out unsigned(g_c_width-1 downto 0);
    -- Data valid output
    valid_o                     : out std_logic
    );

  attribute mult_style                       : string;
  attribute mult_style of matmul : entity is "pipe_block";

end entity matmul;

architecture behave of matmul is

  type pipe is array(g_levels-1 downto 0) of unsigned(2*g_c_width-1 downto 0);
  type pipe_valid is array(g_levels-1 downto 0) of std_logic;

signal valid_in     : std_logic                                      := '0';
  signal product      : pipe                                         := (others => (others => '0'));
  signal product_full : unsigned(2*g_c_width-1 downto 0)             := (others => '0');
  signal valid        : pipe_valid                                   := (others => '0');
  signal valid_full   : std_logic                                    := '0';
  signal product_int  : unsigned(g_c_width-1 downto 0)               := (others => '0');
  signal product_out  : unsigned(g_c_width-1 downto 0)               := (others => '0');
  signal valid_int    : std_logic                                    := '0';
  signal valid_out    : std_logic                                    := '0';

  signal a, b         : unsigned(g_b_width-1 downto 0)               := (others =>'0');

begin

  -- Last stage of multiplication pipeline
  product_full <= product(g_levels-1);
  valid_full   <= valid(g_levels-1);


  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then

    if rst_n_i='0' then
      product_int <= (others => '0');
      valid_int <= '0';
    else
    -- Instantiate a register before multiplier to improve speed
      valid_in <= valid_i;
      a <= a_i.r_a;
      b <= b_i;

      product(0) <= a*b;
      valid(0) <= valid_in;

      for n in 1 to g_levels-1 loop
      product(n) <= product(n-1);
      valid(n) <= valid(n-1);
      end loop;

      product_int <= resize(product_full, product_int'length);
      -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
      valid_int <= valid_full;

      -- Output stage
      product_out <= product_int;
      valid_out <= valid_int;

    end if; -- Reset
  end if; -- Clock
end process;
  c_o <= product_out;
  valid_o <= valid_out;
end behave;

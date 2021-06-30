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
use ieee.math_real.all;

--library UNISIM;
--use UNISIM.vcomponents.all;

library work;
use work.mult_pkg.all;

entity matmul is
  generic(
  -- Width for input a[k]
  g_a_width                         : natural := 16;
  -- Width for input b[k]
  g_b_width                         : natural := 16;
  -- Signed or unsigned multiplication
  g_signed                          : boolean := true;
  -- Input data tag width
  g_tag_width                       : natural := 1;
  -- Width for output c
  g_c_width                         : natural := 16;
  -- Use round convergent or not
  g_round_convergent                : natural := 1;
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
    tag_i                           : in std_logic_vector(g_tag_width-1 downto 0) := (others => '0');
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

  attribute mult_style                       : string;
  attribute mult_style of matmul : entity is "pipe_block";

end matmul;

architecture behave of matmul is
  constant c_product_width             : natural                                           := g_a_width + g_b_width;
  constant c_product_extra_bits        : natural                                           := c_product_width - g_c_width;
  constant c_zeros_extra_bits_m1       : std_logic_vector(c_product_extra_bits-2 downto 0) := (others => '0');
  constant c_product_extra_bits_mid    : std_logic_vector(c_product_extra_bits-1 downto 0) := '1' & c_zeros_extra_bits_m1;
  constant c_zeros_extra_bits_m2       : std_logic_vector(c_product_extra_bits-3 downto 0) := (others => '0');
  constant c_product_extra_bits_mid_m1 : std_logic_vector(c_product_extra_bits-2 downto 0) := '1' & c_zeros_extra_bits_m2;

  type pipe is array(g_levels-1 downto 0) of std_logic_vector(c_product_width-1 downto 0);
  type pipe_valid is array(g_levels-1 downto 0) of std_logic;
  type pipe_tag is array(g_levels-1 downto 0) of std_logic_vector(g_tag_width-1 downto 0);

  signal a       : std_logic_vector(g_a_width-1 downto 0) := (others => '0');
  signal b       : std_logic_vector(g_b_width-1 downto 0) := (others => '0');
  signal valid_in : std_logic                             := '0';
  signal tag_in  : std_logic_vector(g_tag_width-1 downto 0) := (others => '0');
  signal product : pipe                                   := (others => (others => '0'));
  signal product_full : std_logic_vector(c_product_width-1 downto 0) := (others => '0');
  signal valid        : pipe_valid                                   := (others => '0');
  signal valid_full   : std_logic                                    := '0';
  signal tag          : pipe_tag                                     := (others => (others => '0'));
  signal tag_full     : std_logic_vector(g_tag_width-1 downto 0)     := (others => '0');
  signal product_int  : std_logic_vector(c_product_width-1 downto 0) := (others => '0');
  signal product_out  : std_logic_vector(g_c_width-1 downto 0)       := (others => '0');
  signal valid_int    : std_logic                                    := '0';
  signal valid_out    : std_logic                                    := '0';
  signal tag_int      : std_logic_vector(g_tag_width-1 downto 0)     := (others => '0');
  signal tag_out      : std_logic_vector(g_tag_width-1 downto 0)     := (others => '0');

begin

   -----------------------------------------------------------------------------
   -- Component instantiations
   -----------------------------------------------------------------------------

   -- Last stage of multiplication pipeline
   product_full <= product(g_levels-1);
   valid_full   <= valid(g_levels-1);
   tag_full     <= tag(g_levels-1);

  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then

    if rst_n_i = '0' then
      product_int <= (others => '0');
      valid_int <= '0';
      tag_int <= (others => '0');

    elsif valid_i = '1' then
        -- Instantiate a register before multiplier to improve speed
        a <= a_i;
        b <= b_i;
        valid_in <= valid_i;
        tag_in <= tag_i;

        -- If both are signed, there are two signals. Drop the redundancy.
        if g_signed = true then
          product(0) <= std_logic_vector(signed(a) * signed(b));
          valid(0) <= valid_in;
          tag(0) <= tag_in;
          for n in 1 to g_levels-1 loop
            product(n) <= product(n-1);
            valid(n) <= valid(n-1);
            tag(n) <= tag(n-1);
          end loop;

          if g_c_width < c_product_width then
            product_int <= product_full;
            -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
            valid_int <= valid_full;
            tag_int <= tag_full;

            -- Output stage. Generate convergent rounding or not
            if (g_round_convergent = 1) then
              if (unsigned(product_int(c_product_extra_bits-1 -1 downto 0)) = unsigned(c_product_extra_bits_mid_m1)) then
                product_out <= std_logic_vector(unsigned(product_int(c_product_width-2 downto c_product_extra_bits-1)) +
                                              unsigned'("" & product_int(c_product_extra_bits-1)));
              else
                product_out <= std_logic_vector(unsigned(product_int(c_product_width-2 downto c_product_extra_bits-1)) +
                                              unsigned'("" & product_int(c_product_extra_bits-1 -1)));
              end if;

              valid_out <= valid_int;
              tag_out <= tag_int;
            else
              product_out <= product_int(c_product_width-2 downto c_product_extra_bits - 1);
              -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
              valid_out <= valid_int;
              tag_out <= tag_int;
            end if;

          else
            product_int <= std_logic_vector(resize(signed(product_full), g_c_width));
            -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
            valid_int <= valid_full;
            tag_int <= tag_full;

            -- Output stage
            product_out <= product_int;
            valid_out <= valid_int;
            tag_out <= tag_int;
          end if;


        else
          product(0) <= std_logic_vector(unsigned(a) * unsigned(b));
          valid(0) <= valid_in;
          tag(0) <= tag_in;

          for n in 1 to g_levels-1 loop
            product(n) <= product(n-1);
            valid(n) <= valid(n-1);
            tag(n) <= tag(n-1);
          end loop;

          if g_c_width < c_product_width then
            product_int <= product_full(c_product_width-1 downto c_product_extra_bits);
            -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
            valid_int <= valid_full;
            tag_int <= tag_full;

            -- Output stage. Generate convergent rounding or not
            if (g_round_convergent = 1) then
              if (unsigned(product_int(c_product_extra_bits-1 downto 0)) = unsigned(c_product_extra_bits_mid)) then
                product_out <= std_logic_vector(unsigned(product_int(c_product_width-1 downto c_product_extra_bits)) +
                                              unsigned'("" & product_int(c_product_extra_bits)));
              else
                product_out <= std_logic_vector(unsigned(product_int(c_product_width-1 downto c_product_extra_bits)) +
                                            unsigned'("" & product_int(c_product_extra_bits-1)));
            end if;

            valid_out <= valid_int;
            tag_out <= tag_int;
          else
            product_out <= product_int(c_product_width-1 downto c_product_extra_bits);
            valid_out <= valid_int;
            tag_out <= tag_int;
          end if;

          else
            product_int <= std_logic_vector(resize(signed(product_full), g_c_width));
            -- Keep "valid_int" grouped with "product_int" so we don't forget to keep them synchronized
            valid_int <= valid_full;
            tag_int <= tag_full;

            -- Output stage
            product_out <= product_int;
            valid_out <= valid_int;
            tag_out <= tag_int;
          end if;
        end if;
      end if; -- Reset
    end if; -- Clock
  end process matmul_process;

  c_o <= product_out;
  valid_o <= valid_out;
  tag_o <= tag_out;
end behave;

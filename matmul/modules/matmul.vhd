------------------------------------------------------------------------------

-- Title      :  Matrix multiplication

------------------------------------------------------------------------------

-- Author     :  Melissa Aguiar

-- Company    : CNPEM LNLS-DIG

-- Platform   : FPGA-generic

-------------------------------------------------------------------------------

-- Description:  Matrix multiplication core for the Fast Orbit Feedback

-------------------------------------------------------------------------------

-- Copyright (c) 2012 CNPEM

-- Licensed under GNU Lesser General Public License (LGPL) v3.0

-------------------------------------------------------------------------------

-- Revisions  :

-- Date        Version  Author                Description

-- 2021-18-06  1.0      melissa.aguiar        Created

------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.array_pkg.all;

entity matmul is
  generic(
  g_BITS : natural := 32
  );
  port (
    clk_i   : in std_logic;
    rst_i   : in std_logic;
    v_i     : in std_logic; -- sinal de dado valido na entrada
    wr_i    : in std_logic; -- enable pra escrever na memoria
    a_i     : in t_array;   -- entrada a[k] e seu indice
    d_i     : in t_array;   -- termo a entrar na memoria provisoria e seu indice (depois usar a memoria padronizada do hdlmaker)
    c_o     : out integer;  -- resultado do produto interno
    v_o     : out std_logic -- sinal de dado valido na entrada
    );
end matmul;

architecture behave of matmul is
  signal result_s : integer := 0;
  signal a_s      : t_array;
  constant M      : integer := 3; -- tamanho exato do vetor a (ate onde k varia)
  signal cnt      : integer := 0;

  -- memoria provisoria
  type mem_type is array(0 to M-1) of integer; -- especifica o numero de elementos e o tipo de cada elemento
  signal mem : mem_type := (3, 2, 1); -- criando e inicializando uma memoria para testes
begin
  matmul_process : process (clk_i) is
  begin

  if rising_edge(clk_i) then
    if(wr_i = '1') then
      mem(d_i(1)) <= d_i(0);
    end if;

    if rst_i='0' then
      cnt <= 0;
      result_s <= 0;
      c_o <= 0;
    else

      if v_i='1' then
        result_s <= result_s + a_s(0)*mem(a_i(1));
        cnt <= cnt + 1; -- contador para saber quando o produto interno foi finalizado
        v_o <= '0';
      end if;

      if cnt=M then
        c_o <= result_s;
        cnt <= 0;
        result_s <= 0;
        v_o <= '1'; -- validando a saida de dados
      end if;
    end if;
  end if;
end process;
    a_s <= a_i;
end behave;


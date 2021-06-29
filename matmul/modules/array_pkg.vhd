library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_pkg is
  type t_array is array (0 to 1) of integer; -- vetor de 2 termos que vai conter o valor de a e o seu indice k

  component matmul is
    port(
      clk_i   : in std_logic;
      rst_i   : in std_logic;
      wr_i    : in std_logic;
      v_i     : in std_logic;
      a_i     : in t_array; -- termo do vetor de entrada a[k] e seu indice
      d_i     : in t_array; -- termo a entrar na memoria provisoria e seu respectivo indice
      c_o     : out integer;   -- resultado do produto interno
      v_o     : out std_logic
      );
  end component;
end package array_pkg;

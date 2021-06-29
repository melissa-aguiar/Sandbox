library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.array_pkg.all;

--library ieee_proposed;

entity mult_tb is
end mult_tb;

architecture behave of mult_tb is

  constant clk_period : time := 10 ns;

  signal clk_s    : std_logic := '0';
  signal rst_s    : std_logic := '0';
  signal wr_s     : std_logic := '0';
  signal v_i_s    : std_logic := '0';
  signal a_s      : t_array; -- vetor contendo o valor da entrada a[k] e seu indice k
  signal d_i_s    : t_array := (0, 0);
  signal c_s      : integer;
  signal v_o_s    : std_logic := '0';

begin

  matmul_INST : matmul
  port map (
    clk_i   => clk_s,
    rst_i   => rst_s,
    wr_i    => wr_s,
    v_i     => v_i_s,
    a_i     => a_s,
    d_i     => d_i_s,
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

  a_s <= (1, 2); -- simulando o vetor de entrada e seu respectivo indice k (se nao inicializasse a_s antes do clk dava erro)

  wait for clk_period;

  a_s <= (2, 1);

  wait for clk_period;

  v_i_s <= '0';

  wait for clk_period;

  v_i_s <= '1';

  a_s <= (3, 0);

  wait for clk_period;

  --segundo produto interno (resultado deve ser 14 no primeiro e 10 no segundo)

  a_s <= (3, 2);

  wait for clk_period;

  a_s <= (2, 1);

  wait for clk_period;

  a_s <= (1, 0);

  wait for clk_period;
  wait for clk_period;

  if c_s = 14 then
      report "SUCESS";

    elsif c_s = 10 then
      report "SUCESS";

    else
      report "FAILURE";
  end if;

  end process;

end behave;

library ieee;
use ieee.std_logic_1164.all;

entity test_case is
	port (
          clk : in  std_logic;
          ia, ib : std_logic;
          a, b : out std_logic
	);
end entity;

architecture arch of test_case is
begin
	process (clk)
	begin
		if rising_edge(clk) then
			a <= ia;
		elsif falling_edge(clk) then
			b <= '0';
		end if;
	end process;
end architecture;

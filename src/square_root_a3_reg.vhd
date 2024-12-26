LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY square_root_reg IS
generic (
		n           : integer := 32
		);
port (
        clk                 :   in      std_logic;
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);
        result              :   out 	std_logic_vector(n-1 downto 0)
		);
END square_root_reg;

architecture add_reg_arc of square_root_reg is
    signal result_D     : std_logic_vector(n-1 downto 0);
    signal A_Q          : std_logic_vector(2*n-1 downto 0);
begin

    UUT :   entity work.square_root(combination_arc)
            generic map (
                n => n
            )
            port map (
                A           =>  A_Q,
                result      =>  result_D);

    AddReg: process(clk)
    begin
        if(rising_edge(clk)) then
            A_Q <= A;
            result <= result_D;
        end if;
    end process;
end architecture add_reg_arc;
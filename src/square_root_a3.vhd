library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity square_root is
generic (n           : integer := 32);
port (
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);
        result              :   out 	std_logic_vector(n-1 downto 0));
end square_root;

architecture combination_arc of square_root is
    begin
        process(A)        
        variable Z      : unsigned (n-1 downto 0);
        variable R      : unsigned (n+1 downto 0);
        variable D      : unsigned (2*n-1 downto 0);   
        
        begin
            -- Initial
            D   := unsigned(A);
            R   := (others => '0');
            Z   := (others => '0');

            -- loop
            CombGenLoop: for i in 1 to n loop
                if (R(R'high) = '0') then
                    R := resize(R*4,R'length) + resize(D(2*n-1 downto 2*n-2),R'length) - resize((4*Z+1),R'length);
                else
                    R := resize(R*4,R'length) + resize(D(2*n-1 downto 2*n-2),R'length) + resize((4*Z+3),R'length);
                end if;
                Z := Z(Z'high-1 downto 0) & not(R(R'high));
                D := resize(D*4, D'length);
            end loop;
            result <= std_logic_vector(Z(n-1 downto 0));
        end process;
end architecture combination_arc;
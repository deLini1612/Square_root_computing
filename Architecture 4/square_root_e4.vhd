LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY square_root4 IS
generic (
		n           : integer := 32
		);
port (
		clk, reset          : 	in  	std_logic 			            ;
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);

        result              :   out 	std_logic_vector(n-1 downto 0);
		finished		    :	out		std_logic
		);
END square_root4;

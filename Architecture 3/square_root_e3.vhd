LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY square_root3 IS
generic (
		n           : integer := 32
		);
port (
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);
        result              :   out 	std_logic_vector(n-1 downto 0)
		);
END square_root3;

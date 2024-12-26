LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY square_root IS
generic (
		n           : integer := 32
		);
port (
		clk, reset, start    : 	in  	std_logic 			            ;
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);

        result              :   out 	std_logic_vector(n-1 downto 0);
		finished		    :	out		std_logic
		);
END square_root;

architecture sequence_arc of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;

    begin
        process(clk,reset)        
        variable x              : unsigned (n downto 0);
        variable next_x         : unsigned (n downto 0);

        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;
                finished <= '0';

            elsif(clk'event and clk='1') then
                case state is
                    
                    when IDLE =>
                        if(start = '1') then
                            state <= INIT;
                        end if;

                    when INIT =>
                        x := (n-1 => '1', others => '0');
                        next_x := to_unsigned(0,next_x'length);
                        state <= COMP;
                    
                    when COMP =>
                            next_x := (x + resize(unsigned(A)/x,x'length))/2;
                            if (x = next_x or next_x = 0) then
                                state <= DONE;
                            end if;                        
                            x := next_x;
                    
                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(x(n-1 downto 0));
                        if(start = '0') then
                            finished <= '0';
                            state <= IDLE;
                        end if;
                end case;
            end if;
        end process;
end architecture sequence_arc;
    
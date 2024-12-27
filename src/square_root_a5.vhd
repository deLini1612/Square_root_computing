library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity square_root is
generic (
		n           : integer := 32
		);
port (
		clk, reset, start    : 	in  	std_logic 			            ;
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);

        result              :   out 	std_logic_vector(n-1 downto 0);
		finished		    :	out		std_logic
		);
end square_root;

architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;
    signal Z     : unsigned (n-1 downto 0);
    signal D     : unsigned (2*n-1 downto 0); 
    signal cnt   : integer;
    signal finish_flag: std_logic;

    begin
        state_machine: process(clk,reset)        
        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;
                finish_flag <= '0';
            elsif(clk'event and clk='1') then
                case state is
                    
                    when IDLE =>
                        if(start = '1') then
                            state <= INIT;
                        end if;

                    when INIT =>
                        cnt <= n;    
                        state <= COMP;
                    
                    when COMP =>
                            if (cnt = 1) then
                                state <= DONE;
                            else 
                                cnt <= cnt - 1;
                            end if;

                    when DONE =>
                        if(start = '0') then
                            state <= IDLE;
                            finish_flag <= '0';
                        else
                            finish_flag <= '1';
                            if(finish_flag = '1') then
                                finish_flag <= '0';
                                state <= IDLE;
                            end if;
                        end if;
                    end case;
                end if;
        end process;

        calculation: process (clk, reset)
        variable R     : unsigned (n+1 downto 0);  
        begin
            if(clk'event and clk='1') then
                if(cnt = n) then
                    D <= unsigned(A);
                    R := (others => '0');
                    Z <= (others => '0');
                else
                    if (R(n+1) = '0') then
                        R := (R(n-1 downto 0) & D(2*n-1 downto 2*n-2)) - (Z(n-1 downto 0) & R(n+1) & '1');
                    else
                        R := (R(n-1 downto 0) & D(2*n-1 downto 2*n-2)) + (Z(n-1 downto 0) & R(n+1) & '1');
                    end if;
                        Z <= Z(n-2 downto 0) & not R(n+1);
                        D <= D(2*n-3 downto 0) & '0' & '0';
                end if;
            end if;
        end process;

        output: process(clk, reset)
        begin
            if(clk'event and clk='1') then
                if(finish_flag = '1') then
                    result <= std_logic_vector(Z);
                    finished <= '1';
                else
                    finished <= '0';
                end if;
            end if;

        end process;
end architecture a1;
    
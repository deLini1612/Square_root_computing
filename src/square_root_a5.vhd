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

architecture sequence_arc of square_root is
    type statetype is (IDLE, COMP, DONE);
    signal state : statetype;
    signal Z     : unsigned (n-1 downto 0);
    signal D     : unsigned (2*n-1 downto 0); 
    signal cnt   : unsigned (n-1 downto 0);
    signal finish_flag: std_logic;

    begin
        state_machine: process(clk,reset)        
        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;
                finish_flag <= '0';
                cnt <= (others => '0');
            elsif(clk'event and clk='1') then
                case state is
                    
                    when IDLE =>
                        if(start = '1') then
                            state <= COMP;
                            cnt <= to_unsigned(1, cnt'length); 
                        end if;
                    
                    when COMP =>
                            if (cnt = 0) then
                                state <= DONE;
                            else 
                                cnt <= cnt sll 1;
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
                if(cnt = 2) then
                    D <= unsigned(A);
                    R := (others => '0');
                    Z <= (others => '0');
                else
                    if (R(R'high) = '0') then
                        R := (R(R'high-2 downto 0) & D(D'high downto D'high-1)) - (Z(Z'high downto 0) & R(R'high) & '1');
                    else
                        R := (R(R'high-2 downto 0) & D(D'high downto D'high-1)) + (Z(Z'high downto 0) & R(R'high) & '1');
                    end if;
                        Z <= Z(Z'high-1 downto 0) & not R(R'high);
                        D <= D(D'high-2 downto 0) & '0' & '0';
                end if;
            end if;
        end process;

        output: process(clk, reset)
        begin
            if(reset = '0') then
                finished <= '0';
                result <= (others => '0');
            elsif(clk'event and clk='1') then
                if(finish_flag = '1') then
                    result <= std_logic_vector(Z);
                    finished <= '1';
                else
                    finished <= '0';
                end if;
            end if;

        end process;
end architecture sequence_arc;
    
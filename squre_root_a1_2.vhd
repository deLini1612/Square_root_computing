architecture a1_2 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;
    signal over     : std_logic;

    begin
        process(clk,reset)        
        variable x              : unsigned (n-1 downto 0);
        variable next_x         : unsigned (n-1 downto 0);

        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;
                finished <= '0';
                over <= '0';

            elsif(clk'event and clk='1') then
                case state is
                    
                    when IDLE =>
                        finished <= '0';
                        over <= '0';
                        if(start = '1') then
                            state <= INIT;
                        end if;

                    when INIT =>
                        x := to_unsigned(((2**(n)) - 1),n);
                        next_x := to_unsigned(0,n);
                        state <= COMP;
                    
                    when COMP =>
                        if(over = '1') then
                            state <= DONE;
                        else
                            next_x := (3*x-unsigned(A)*(x**3))/2;
                            if (x = next_x) then
                                over <= '1';
                            end if;                        
                            x := next_x;
                        end if;                        
                    
                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(x*unsigned(A));
                        if(start = '0') then
                            state <= IDLE;
                        end if;
                    end case;
                end if;
        end process;
end architecture a1_2 ;
    
architecture a1 of square_root is
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
                        over <= '0';
                        if(start = '1') then
                            state <= INIT;
                        end if;

                    when INIT =>
                        x := (n-1 => '1', others => '0');
                        next_x := to_unsigned(0,n);
                        state <= COMP;
                    
                    when COMP =>
                            --next_x := x/2 + unsigned(A)/(2*x);
                            next_x := (x + resize(unsigned(A)/x,n))/2;
                            if (x = next_x or next_x = 0) then
                                over <= '1';
                                state <= DONE;
                            end if;                        
                            x := next_x;
                    
                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(x);
                        if(start = '0') then
                            finished <= '0';
                            state <= IDLE;
                        end if;
                    end case;
                end if;
        end process;
end architecture a1;
    
architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;
    signal R     : unsigned (n+1 downto 0);
    signal Z     : unsigned (n-1 downto 0);
    signal D                 : unsigned (2*n-1 downto 0);   

    begin
        process(clk,reset)        
        variable cnt               : integer;    


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
                        cnt := n;    
                        D <= unsigned(A);
                        R <= (others => '0');
                        Z <= (others => '0');
                        state <= COMP;
                    
                    when COMP =>
                            if (cnt = 0) then
                                state <= DONE;
                            else 
                                if (R(n+1) = '0') then
                                    R <= (R(n+1 downto 2) & D(2*n-1 downto 2*n-2)) - (Z(n-1 downto 0) & R(n+1) & '0');
                                else
                                    R <= (R(n+1 downto 2) & D(2*n-1 downto 2*n-2)) + (Z(n-1 downto 0) & R(n+1) & '0');
                                end if;
                                Z <= Z(n-2 downto 0) & not R(n+1);
                                D <= D(n-1 downto 2) & '0' & '0';
                                cnt := cnt -1;
                            end if;

                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(Z);
                        if(start = '0') then
                            state <= IDLE;
                            finished <= '0';
                        end if;
                    end case;
                end if;
        end process;
end architecture a1;
    
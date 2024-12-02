architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;

    begin
        process(clk,reset)        
        variable R,Z,cnt              : integer;
        variable D                 : unsigned (2*n-1 downto 0);   

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
                        D := unsigned(A);
                        R := 0;
                        Z := 0;
                        state <= COMP;
                    
                    when COMP =>
                            if (cnt = 0) then
                                state <= DONE;
                            else 
                                if (R >= 0) then
                                    R := R*4 + to_integer(D(2*n-1 downto 2*n-2)) - (4*Z+1);
                                else
                                    R := R*4 + to_integer(D(2*n-1 downto 2*n-2)) + (4*Z+3);
                                end if;
                                if (R >= 0) then
                                    Z := 2*Z + 1;
                                else
                                    Z := 2*Z;
                                end if;
                                D := resize(D*4, D'length);
                                cnt := cnt -1;
                            end if;

                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(to_unsigned(Z,result'length));
                        if(start = '0') then
                            state <= IDLE;
                            finished <= '0';
                        end if;
                    end case;
                end if;
        end process;
end architecture a1;
    
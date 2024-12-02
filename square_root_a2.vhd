architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;
    signal cnt : integer := n;

    begin
        process(clk,reset)        
        variable D              : unsigned (2*n-1 downto 0);
        variable R              : unsigned (2*n-1 downto 0);
        variable Z              : unsigned (2*n-1 downto 0);
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
                        D := unsigned(A);
                        R := (others => '0');
                        Z := (others => '0');
                        state <= COMP;
                    
                    when COMP =>
                            if (cnt = 0) then
                                state <= DONE;
                            else 
                                if (R >= 0) then
                                    R := resize(R*4,R'length) + D/to_unsigned(2**(2*n-2),D'length)-resize(4*Z+1,Z'length);
                                else
                                    R := R*4 + D/to_unsigned(2**(2*n-2),D'length)+(4*Z+3);
                                end if;
                                if (R >= 0) then
                                    Z := resize(2*Z + 1,Z'length);
                                else
                                    Z := resize(2*Z ,Z'length);
                                end if;
                                D := resize(D*4,D'length);
                                cnt <= cnt -1;
                            end if;

                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(resize(Z,result'length));
                        if(start = '0') then
                            state <= IDLE;
                            finished <= '0';
                        end if;
                    end case;
                end if;
        end process;
end architecture a1;
    
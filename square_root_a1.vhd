architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;

    begin
        process(clk,reset)        
        variable x      : unsigned (n/2-1 downto 0);
        variable next_x : unsigned (n/2-1 downto 0);
    
        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;

            elsif(clk'event and clk='1') then
                case state is
                    when IDLE =>
                        if(start = '1') then
                            state <= INIT;
                            x <= (2**(n/2)) - 1;
                            next_x <= 0;
                        end if;
                    when COMP =>
                        if(x)



        end process;
end architecture a1 ;
    
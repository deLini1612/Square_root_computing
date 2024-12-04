architecture a3 of square_root3 is
    begin
        process(A)        
        variable R,Z                  : integer;
        variable D                    : unsigned (2*n-1 downto 0);   
        
        begin
            -- Initial
            D   := unsigned(A);
            R   := 0;
            Z   := 0;

            -- loop
            for i in 1 to N loop
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
            end loop;
            result <= std_logic_vector(to_unsigned(Z,result'length));
        end process;
end architecture a3;
    
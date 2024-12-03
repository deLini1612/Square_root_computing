architecture a1 of square_root is
    type R is array(0 to n) of integer; -- Pipeline registers for R
    type Z is array (0 to n) of integer; -- Pipeline registers for Z
    signal stage_Z : Z;

    type D is array (0 to n) of unsigned(2*n-1 downto 0); -- Pipeline registers for D
    signal stage_D : D := (others => (others => '0'));

begin
    process(clk, reset)
    variable stage_R : R;
    begin
        if reset = '1' then
            -- Reset all pipeline registers
            for i in 0 to N loop
                stage_R(i) := 0;
                stage_Z(i) <= 0;
                stage_D(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            -- Stage 0: Initialize
            stage_R(0) := 0;
            stage_Z(0) <= 0;
            stage_D(0) <= unsigned(A);

            -- Stages 1 to N: Pipelined loop
            for i in 1 to n loop
                -- Compute R
                if stage_R(i-1) >= 0 then
                    stage_R(i) := stage_R(i-1)*4 + to_integer(stage_D(i-1)(2*n-1 downto 2*n-2)) - (4*stage_Z(i-1) + 1);
                else
                    stage_R(i) := stage_R(i-1)*4 + to_integer(stage_D(i-1)(2*n-1 downto 2*n-2)) + (4*stage_Z(i-1) + 3);
                end if;

                -- Compute Z
                if stage_R(i) >= 0 then
                    stage_Z(i) <= 2*stage_Z(i-1) + 1;
                else
                    stage_Z(i) <= 2*stage_Z(i-1);
                end if;

                -- Shift D
            stage_D(i) <= resize(stage_D(i-1)*4, stage_D(i-1)'length);
            end loop;
        end if;
    end process;

    -- Final output after N stages
    result <= std_logic_vector(to_unsigned(stage_Z(N), result'length)); -- Output result after the pipeline
end architecture a1;

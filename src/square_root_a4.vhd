library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity square_root is
generic (n           : integer := 32);
port (
	clk, reset, start	: 	in  std_logic;
    A    			    : 	in 	std_logic_vector(2*n-1 downto 0);
	result          	:   out std_logic_vector(n-1 downto 0);
	finished		    :	out	std_logic);
end square_root;

architecture pipeline_arc of square_root is

    -- Type definitions for pipeline registers
    type Z is array(0 to n) of unsigned(n-1 downto 0);
    type R is array(0 to n) of unsigned(n+1 downto 0);
    type D is array (0 to n) of unsigned(2*n-1 downto 0); 
    
    signal stage_R 		        : R;
    signal stage_Z 		        : Z;
    signal stage_D 		        : D;
    signal shift_reg_start	    : unsigned(n downto 0);

-- Pipeline registers
begin
    process(clk, reset)
    variable stage_R_var        : R;
    begin
        if (reset = '0') then
            -- Reset all pipeline registers
            stage_R <= (others => (others => '0'));
            stage_R_var := (others => (others => '0'));
            stage_Z <= (others => (others => '0'));
            stage_D <= (others => (others => '0'));
            shift_reg_start <= (others => '0');
            finished <= '0';
            result <= (others => '0');

        elsif (rising_edge(clk)) then
            -- Stage 0: Initialize
            shift_reg_start(0) <= start;
            if (shift_reg_start(0) = '1') then
                stage_R_var(0) := (others => '0');
                stage_R(0) <= (others => '0');
                stage_Z(0) <= (others => '0');
                stage_D(0) <= unsigned(A);
            end if;
	        

            -- Stages 1 to n: Pipelined loop
            PipelineGen: for i in 1 to n loop
                -- Shift start signal so it act as a enable
                shift_reg_start(i) <= shift_reg_start(i-1);
                if (shift_reg_start(i) = '1') then
                    -- Compute R
                    if (stage_R(i-1)(n+1) = '0') then
                        stage_R_var(i) := resize(stage_R(i-1)*4,stage_R_var(i)'length) + resize(stage_D(i-1)(2*n-1 downto 2*n-2), stage_R_var(i)'length) - resize(4*stage_Z(i-1) + 1, stage_R_var(i)'length);
                    else
                        stage_R_var(i) := resize(stage_R(i-1)*4,stage_R_var(i)'length) + resize(stage_D(i-1)(2*n-1 downto 2*n-2), stage_R_var(i)'length) + resize(4*stage_Z(i-1) + 3, stage_R_var(i)'length);
                    end if;
                    stage_R(i) <= stage_R_var(i);

                    -- Compute Z
                    stage_Z(i) <= stage_Z(i-1)(stage_Z(i-1)'high-1 downto 0) & not(stage_R_var(i)(stage_R_var(i)'high));

                    -- Shift D
                    stage_D(i) <= resize(stage_D(i-1)*4, stage_D(i-1)'length);
                end if;
            end loop;

            finished <= shift_reg_start(n);
            if (shift_reg_start(n) = '1') then
                    result <= std_logic_vector(stage_Z(n)(n-1 downto 0)); -- Output result after the pipeline
	    end if;        
	end if;
    end process;

end architecture pipeline_arc;

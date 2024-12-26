library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity tb_square_root is
end tb_square_root;

architecture pipeline_tb of tb_square_root is

    constant PERIOD     : TIME      := 10 NS;
    constant n          : integer   := 32;
    constant NUM_TEST   : integer   := 50;
    signal StopSim      : BOOLEAN   := False;


    signal clk          : std_logic                         := '1';
    signal reset        : std_logic                         := '0';
    signal start        : std_logic                         := '0';
    signal finished     : std_logic;
    signal A            : std_logic_vector(2*n-1 downto 0);
    signal result       : std_logic_vector(n-1 downto 0);

    file input_file       : text open read_mode is "input.txt";
    file golden_file      : text open read_mode is "golden_output.txt";


    function to_stdlogicvector(
        str : in string;  -- binary string input
        vector_length : in integer -- the desired length of std_logic_vector
    ) return std_logic_vector is
        variable result : std_logic_vector(vector_length-1 downto 0);
        variable i : integer;
    begin
        -- Initialize the result vector with '0's
        result := (others => '0');
        
        -- Loop through the string, starting from the most significant bit
        for i in 0 to vector_length-1 loop
            if str(i+1) = '1' then
                result(vector_length-1-i) := '1';
            else
                result(vector_length-1-i) := '0';
            end if;
        end loop;
        
        return result;
    end function;

begin

    UUT :   entity work.square_root(pipeline_arc)
            port map (
                clk         =>  clk,
                reset       =>  reset,
                start       =>  start,
                A           =>  A,
                result      =>  result,
                finished    =>  finished);

    -- Clock generation
    ClkGen: process
        begin 
            while not StopSim loop
                clk <= '1';
                wait for PERIOD/2;
                clk <= '0';
                wait for PERIOD/2;
            end loop;
            wait;
        end process ClkGen;


    ResetGen: process
        begin
            reset <= '0';
            wait for PERIOD;
            reset <= '1';
            wait;
        end process ResetGen;

    FeedInput: process
            variable input_count    : integer := 5; -- Because of 5 direct test
            variable input_line     : line;
            variable input_data     : std_logic_vector(2*n-1 downto 0);
            variable temp_in_str    : string(1 to 2*n); -- String with length 2*n
        begin

            -- Start testing
            wait until reset = '1' and rising_edge(clk);

            -- Direct test: required test 0, 1, 512, 5499030, 1194877489
            start <= '1';
            A <= std_logic_vector(to_unsigned(0,A'length));
            wait until rising_edge(clk);
            A <= std_logic_vector(to_unsigned(1,A'length));
            wait until rising_edge(clk);
            A <= std_logic_vector(to_unsigned(512,A'length));
            wait until rising_edge(clk);
            A <= std_logic_vector(to_unsigned(5499030,A'length));
            wait until rising_edge(clk);
            A <= std_logic_vector(to_unsigned(1194877489,A'length));

            -- Random test
            while (input_count < NUM_TEST and not endfile(input_file)) loop
                -- Read input
                readline(input_file, input_line);
                read(input_line, temp_in_str);
                input_data := to_stdlogicvector(temp_in_str, 2*n);

                wait until rising_edge(clk);
                A <= input_data;
                input_count := input_count + 1;
            end loop;

            wait until rising_edge(clk);
            start <= '0';
            report "Feed all input patterns to DUT. Number of testcases = " & integer'image(input_count);
            
            wait until rising_edge(clk);
            wait;
        end process FeedInput;

    GetOutput: process
            variable output_count   : integer := 5; -- Because of 5 direct test
            variable error_count    : integer := 0; -- Count the errror
            variable golden_line    : line;
            variable golden_data    : std_logic_vector(n-1 downto 0);
            variable temp_out_str   : string(1 to n); -- String with length n
        begin

            -- Direct test: golden_output is 0, 1, 22, 2345, 34567
	    wait until finished = '1' and rising_edge(clk);
		golden_data := std_logic_vector(to_unsigned(0,result'length));
                if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;
	    wait until finished = '1' and rising_edge(clk);
		golden_data := std_logic_vector(to_unsigned(1,result'length));
                if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;
	    wait until finished = '1' and rising_edge(clk);
		golden_data := std_logic_vector(to_unsigned(22,result'length));
                if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;
	    wait until finished = '1' and rising_edge(clk);
		golden_data := std_logic_vector(to_unsigned(2345,result'length));
                if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;
	    wait until finished = '1' and rising_edge(clk);
		golden_data := std_logic_vector(to_unsigned(34567,result'length));
                if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;

            -- Random test
            while (output_count < NUM_TEST and not endfile(golden_file)) loop
                -- Read golden output
                readline(golden_file, golden_line);
                read(golden_line, temp_out_str);
                golden_data := to_stdlogicvector(temp_out_str, n);

                wait until finished = '1' and rising_edge(clk);
                -- Compare output
                 if (result /= golden_data)  then
                    report "Mismatch: DUT output = " & to_hstring(result) &
                        ", golden output = " & to_hstring(golden_data)
                        severity error;
                    error_count := error_count + 1;
                end if;

                output_count := output_count + 1;
            end loop;
        
            report "Simulation completed: Accuracy = " & integer'image(output_count-error_count) & "/" & integer'image(output_count);

            -- End Sim
            StopSim <= True;
            wait;
        end process GetOutput;
    
end architecture pipeline_tb;
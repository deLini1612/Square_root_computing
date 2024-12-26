library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity tb_square_root is
end entity tb_square_root;

architecture behavior_tb of tb_square_root is

    constant n     : integer   := 32;

    constant NUM_TEST   : integer   := 50;
    signal result       : std_logic_vector(n-1 downto 0);
    signal A            : std_logic_vector(2*n-1 downto 0);

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

    UUT :   entity work.square_root(combination_arc)
            port map (
                A           =>  A,
                result      =>  result);

    -- Stimulus 
    Sim: process
            variable test_count     : integer := 5; -- Because of 5 direct test
            variable error_count    : integer := 0; -- Count the errror
            variable input_line     : line;
            variable golden_line    : line;
            variable input_data     : std_logic_vector(2*n-1 downto 0);
            variable golden_data    : std_logic_vector(n-1 downto 0);
            variable temp_in_str    : string(1 to 2*n); -- String with length 2*n
            variable temp_out_str   : string(1 to n); -- String with length n
    begin
        -- Direct test: required test 0, 1, 512, 5499030, 1194877489
        A <= std_logic_vector(to_unsigned(0, A'length));
        wait for 10 ns;
        
        A <= std_logic_vector(to_unsigned(1, A'length));
        wait for 10 ns;
        
        A <= std_logic_vector(to_unsigned(512, A'length));
        wait for 10 ns;
        
        A <= std_logic_vector(to_unsigned(5499030, A'length));
        wait for 10 ns;

        A <= std_logic_vector(to_unsigned(1194877489, A'length));
        wait for 10 ns;

        -- Random test
        while (test_count < NUM_TEST and not endfile(input_file)) loop
            -- Read input and golden output
            readline(input_file, input_line);
            readline(golden_file, golden_line);
            read(input_line, temp_in_str);
            input_data := to_stdlogicvector(temp_in_str, 2*n);
            read(golden_line, temp_out_str);
            golden_data := to_stdlogicvector(temp_out_str, n);

            A <= input_data;
            wait for 10 ns;

            -- Compare output
            if result /= golden_data then
                report "Mismatch: Input = " & to_hstring(A) & 
                    ", DUT output = " & to_hstring(result) &
                    ", golden output = " & to_hstring(golden_data)
                    severity error;
                error_count := error_count + 1;
            end if;

            test_count := test_count + 1;
        end loop;
        
        report "Simulation completed: Accuracy = " & integer'image(test_count-error_count) & "/" & integer'image(test_count);
        
        wait;

    end process;

end architecture behavior_tb;

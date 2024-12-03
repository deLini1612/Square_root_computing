library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.ALL;


entity tb_square_root is
end entity tb_square_root;

architecture sequence of tb_square_root is

    constant PERIOD     : TIME      := 10 NS;
    constant n          : integer   := 32;
    constant NUM_TEST   : integer   := 1000;
    signal StopSim      : BOOLEAN   := False;


    signal clk          : std_logic                         := '1';
    signal reset        : std_logic                         := '0';
    signal start        : std_logic                         := '0';
    signal finished     : std_logic;
    signal A            : std_logic_vector(2*n-1 downto 0);
    signal result       : std_logic_vector(n-1 downto 0);

begin

    UUT :   entity work.square_root(a1)
            port map (
                clk         =>  clk,
                reset       =>  reset,
                start       =>  start,
                A           =>  A,
                result      =>  result,
                finished    =>  finished);

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

    Sim: process
            variable rand_seed : integer := 1612; -- Seed for random number generator
            variable rand_val  : unsigned(2*n-1 downto 0);
            variable test_count : integer := 5; -- Because of 5 direct test
        begin
            wait until reset = '1' and clk = '1' and clk'event;

            -- Direct test: required test 0, 1, 512, 5499030, 1194877489
            start <= '1';
            A <= std_logic_vector(to_unsigned(0,A'length));

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(to_unsigned(1,A'length));

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(to_unsigned(512,A'length));

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(to_unsigned(5499030,A'length));

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(to_unsigned(1194877489,A'length));

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';

            -- Random test
            while test_count < NUM_TEST loop
                rand_val := uniform(rand_seed, rand_seed) mod (2**(2*n));
                wait until clk = '1' and clk'event;
                start <= '1';
                A <= std_logic_vector(rand_val);
                wait until finished = '1' and clk = '1' and clk'event;
                start <= '0';
                test_count := test_count + 1;
            end loop;

            -- End Sim
            StopSim <= True;
            wait;
        end process Sim;

end architecture sequence;
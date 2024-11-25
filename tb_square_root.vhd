library ieee;
use ieee.std_logic_1164.all;

entity tb_square_root is
end entity tb_square_root;

architecture sequence of tb_square_root is

    signal clk          : std_logic                         := '1';
    signal reset        : std_logic                         := '0';
    signal start        : std_logic                         := '0';
    signal finished     : std_logic;
    signal A            : std_logic_vector(2*n-1 downto 0);
    signal result       : std_logic_vector(n-1 downto 0);

    constant PERIOD : TIME      := 10 NS;
    signal StopSim  : BOOLEAN   := False;

begin

    UUT :   entity work.square_root(a1)
            port map (
                clk         =>  clk,
                reset       =>  reset,
                start       =>  c,
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
        begin
            wait until reset = '0' and clk = '1' and clk'event;

            -- Direct test: required test 0, 1, 512, 5499030, 1194877489
            start <= '1';
            A <= std_logic_vector(0);

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(1);

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(512);

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(5499030);

            wait until finished = '1' and clk = '1' and clk'event;
            start <= '0';
            wait until clk = '1' and clk'event;
            start <= '1';
            A <= std_logic_vector(1194877489);

            StopSim <= True;
            wait;
        end process Sim;

end architecture sequence;
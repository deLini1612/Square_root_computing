LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_square_root4 IS
END tb_square_root4;

ARCHITECTURE behavior OF tb_square_root4 IS

    COMPONENT square_root4
    GENERIC (
        n : integer := 32
    );
    PORT(
        clk     : IN  std_logic;
        reset   : IN  std_logic;
        A       : IN  std_logic_vector(2*n-1 downto 0);
        result  : OUT std_logic_vector(n-1 downto 0)
    );
    END COMPONENT;

    constant PERIOD     : TIME     := 10 ns;
    constant n          : integer := 32;
    signal StopSim    : BOOLEAN := False;

    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal A            : std_logic_vector(2*n-1 downto 0) := (others => '0');
    signal result       : std_logic_vector(n-1 downto 0);

    -- Test input
    type INT is array(0 to 4) of integer;
    constant TEST_INPUT : INT := (0, 1, 512, 5499030, 1194877489);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: square_root4
    GENERIC MAP(
        n => 32
    )
    PORT MAP (
        clk     => clk,
        reset   => reset,
        A       => A,
        result  => result
    );

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

    -- Stimulus process
    stim_proc: process
    begin
        wait until reset = '1' and clk = '1' and clk'event;

        -- Apply inputs sequentially
        for i in 0 to TEST_INPUT'length - 1 loop
            A <= std_logic_vector(to_unsigned(TEST_INPUT(i), A'length));
            wait for PERIOD;
        end loop;

        -- Wait for the pipeline to process all inputs
        wait for (TEST_INPUT'length + n + 1) * PERIOD;

        -- End Sim
        StopSim <= True;
        wait;
    end process;

    
END;

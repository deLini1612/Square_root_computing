LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_square_root_a3 IS
END tb_square_root_a3;

ARCHITECTURE behavior OF tb_square_root_a3 IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT square_root3
    GENERIC (
        n : integer := 32
    );
    PORT(
        A       : IN  std_logic_vector(2*n-1 downto 0);
        result  : OUT std_logic_vector(n-1 downto 0)
    );
    END COMPONENT;

    constant n     : integer   := 32;

    -- Signals for UUT
    signal A       : std_logic_vector(2*n-1 downto 0) := (others => '0');
    signal result  : std_logic_vector(n-1 downto 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: square_root3
    GENERIC MAP(
        n => 32
    )
    PORT MAP (
        A       => A,
        result  => result
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test A = 0
        A <= std_logic_vector(to_unsigned(0, A'length));
        wait for 10 ns;
        
        -- Test A = 1
        A <= std_logic_vector(to_unsigned(1, A'length));
        wait for 10 ns;
        
        -- Test A = 512
        A <= std_logic_vector(to_unsigned(512, A'length));
        wait for 10 ns;
        
        -- Test A = 5499030
        A <= std_logic_vector(to_unsigned(5499030, A'length));
        wait for 10 ns;

        -- Test A = 1194877489
        A <= std_logic_vector(to_unsigned(1194877489, A'length));
        wait for 10 ns;

        -- Wait for final simulation end
        wait;

    end process;

END;

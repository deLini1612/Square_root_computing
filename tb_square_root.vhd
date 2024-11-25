library ieee;
use ieee.std_logic_1164.all;

entity tb_square_root is
end entity tb_square_root;

architecture sequence of tb_square_root is

    signal clk          : std_logic                         := '0';
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
                start       =>  c,
                A           =>  A,
                result      =>  result,
                finished    =>  finished);

    
end architecture sequence;
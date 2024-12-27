library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- My reg with synchronous load flag and pre-set
entity my_reg is
	generic (
		N	: integer := 32
		);
	port (
        clk         :   in  std_logic;
        load        :   in  std_logic;
        preset      :   in  std_logic;
        init_val    :   in  unsigned (N-1 downto 0);
		D		    :	in 	unsigned (N-1 downto 0);
		Q   	    :	out	unsigned (N-1 downto 0)
		);
end entity my_reg;

architecture a1 of my_reg is
    
begin
    
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(preset = '1') then
                Q <= init_val;
            elsif(load = '1') then
                Q <= D;
            end if;
        end if;
    end process;
    
end architecture a1;
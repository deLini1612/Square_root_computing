library ieee;
use ieee.std_logic_1164.all;

library lpm;
use lpm.lpm_components.all;
 
entity my_addsub is
  generic (
    N : integer := 32  -- Số bit (chiều rộng) của bộ cộng/trừ
  );
  port (
    dataa       : in  std_logic_vector(N-1 downto 0); -- Operand A
    datab       : in  std_logic_vector(N-1 downto 0); -- Operand B
    result      : out std_logic_vector(N-1 downto 0); -- Kết quả
    cin         : in  std_logic;                      -- Carry-in (hoặc chọn trừ)
    cout        : out std_logic                       -- Carry-out
  );
end my_addsub;

architecture a1 of my_addsub is

begin

  -- lpm_add_sub IP (from Altera): A+B or A-B operations (Note: treat carry-in as negative when sub)
  lpm_add_sub_inst: lpm_add_sub
    generic map (
      LPM_WIDTH        => N,
      LPM_DIRECTION    => "UNUSED",  -- Both sub and add
      LPM_TYPE         => "LPM_ADD_SUB",
      LPM_HINT         => "UNUSED"
    )
    port map (
      dataa   => dataa,
      datab   => datab,
      cin     => cin,
      result  => result,
      cout    => cout
    );

end architecture a1;

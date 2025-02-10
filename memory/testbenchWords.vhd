LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY tb_ram_rv IS
END ENTITY tb_ram_rv;

ARCHITECTURE behavior OF tb_ram_rv IS

  SIGNAL clk : std_logic := '0';
  SIGNAL we : std_logic := '0';
  SIGNAL byte_en : std_logic := '0';
  SIGNAL sgn_en : std_logic := '0';
  SIGNAL address : std_logic_vector(12 downto 0) := (OTHERS => '0');
  SIGNAL datain : std_logic_vector(31 downto 0) := (OTHERS => '0');
  SIGNAL dataout : std_logic_vector(31 downto 0);

  COMPONENT ram_rv
    PORT (
      clk : IN std_logic;
      we : IN std_logic;
      byte_en : IN std_logic;
      sgn_en : IN std_logic;
      address : IN std_logic_vector(12 downto 0);
      datain : IN std_logic_vector(31 downto 0);
      dataout : OUT std_logic_vector(31 downto 0)
    );
  END COMPONENT;

BEGIN

  uut: ram_rv
    PORT MAP (
      clk => clk,
      we => we,
      byte_en => byte_en,
      sgn_en => sgn_en,
      address => address,
      datain => datain,
      dataout => dataout
    );

  clk_gen: PROCESS
    VARIABLE i : INTEGER := 0;
    CONSTANT clk_period : TIME := 10 ns;
  BEGIN
    FOR i IN 0 TO 512 LOOP
      clk <= '0';
      WAIT FOR clk_period / 2;
      clk <= '1';
      WAIT FOR clk_period / 2;
    END LOOP;
    WAIT;
  END PROCESS;

  test_process: PROCESS
    VARIABLE i : INTEGER;
  BEGIN
    FOR i IN 0 TO 255 LOOP
      we <= '1';
      byte_en <= '0';    -- Pra indicar que tô escrevendo words
      address <= std_logic_vector(to_unsigned(i, 11)) & "00"; -- 13-bit com os 2 ultimos em 0
      datain <= std_logic_vector(to_unsigned(i+1, 32)); 
      WAIT FOR 10 ns;
      
      we <= '0';       
            
		wait for 10 ns;
    assert dataout = std_logic_vector(to_unsigned(i+1, 32)) report "falhou" severity error;
     
      
      
      

    END LOOP;
    
    WAIT;
  END PROCESS;

END ARCHITECTURE behavior;

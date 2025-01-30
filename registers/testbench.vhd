library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is

component XREGS is
	generic (WSIZE : natural := 32);
	port(clk, wren: in std_logic;
    	rs1, rs2, rd: in std_logic_vector(4 downto 0);
      data: in std_logic_vector(WSIZE-1 downto 0);
      ro1, ro2: out std_logic_vector(WSIZE-1 downto 0));
end component;

	  signal clk_tb : std_logic 					             := '0';
    signal wren_tb : std_logic 					           := '0';
    signal rs1_tb : std_logic_vector(4 downto 0)   := (others  => '0');
    signal rs2_tb : std_logic_vector(4 downto 0)   := (others  => '0');
    signal rd_tb : std_logic_vector(4 downto 0)    := (others  => '0');
    signal ro1_tb : std_logic_vector(31 downto 0)  := (others  => '0');
    signal ro2_tb : std_logic_vector(31 downto 0)  := (others  => '0');
    signal data_tb : std_logic_vector(31 downto 0) := (others  => '0');    

begin
	
    uut: XREGS port map(clk => clk_tb, 
    wren => wren_tb,
    rs1  => rs1_tb,
    rs2  => rs2_tb,
    rd   => rd_tb,
    data => data_tb,
    ro1  => ro1_tb,
    ro2  => ro2_tb );
    
    process
      begin       
      data_tb <= X"AAAAAAAA";	-- dado para escrever
      rd_tb 	<= "00101"; 	  -- no registrador 5
      wren_tb <= '1'; 			  -- habilita o sinal de escrita
      wait for 1 ns;

      clk_tb <= '1';			-- subida do clock
      wait for 1 ns;

      clk_tb <= '0';			-- descida do clock
      wait for 1 ns;    

      data_tb <= X"BBBBBBBB";
      rd_tb 	<= "00111";		-- escreve no reg 7
      -- sinal de escrita continua ativo

      wait for 1 ns;

      clk_tb <= '1';			-- clock sobe para escrever de novo

      wait for 1 ns;
      wren_tb <= '0';			-- desativa sinal de escrita
      rs1_tb 	<= "00101";	
      rs2_tb 	<= "00111";		-- para ler os registradores 5 e 7	

      wait for 1 ns;

      clk_tb <= '1';

      assert ro1_tb = X"AAAAAAAA" report "ro1 falhou" severity error;
      assert ro2_tb = X"BBBBBBBB" report "ro2 falhou" severity error;

      wait for 1 ns;

      clk_tb 	<= '0';
      wren_tb <= '1';

      wait for 1 ns;

      data_tb 	<= X"FFFFFFFF"; -- tentativa de escrever no registrador 0
      rd_tb 	<= "00000";

      wait for 1 ns;

      clk_tb <= '1';

      wait for 1 ns;

      clk_tb 	<= '0';
      wren_tb <= '0';

      wait for 1 ns;

      rs1_tb 	<= "00000";
      rs2_tb 	<= "00000"; -- verificação do que está guardado no reg 0

      wait for 1 ns;

      clk_tb <= '1';

      assert ro1_tb = X"00000000" report "ro1 zero falhou" severity error;
      assert ro2_tb = X"00000000" report "ro2 zero falhou" severity error;

      wait;
    end process;
end tb;

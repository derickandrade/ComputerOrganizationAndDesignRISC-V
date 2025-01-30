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

signal clk_tb : std_logic 		       := '0';
signal wren_tb : std_logic 		       := '0';
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
      wren_tb <= '1';
      for I in 0 to 31 loop
      	clk_tb <= '0';
      	data_tb <= std_logic_vector(to_unsigned((I + 1), 32)); -- I + 1 para colocar algo diferente de 0 no reg zero
        rd_tb <= std_logic_vector(to_unsigned(I, 5));
        wait for 1 ns;
        clk_tb <= '1';
        wait for 1 ns;
      end loop;
      
      wren_tb <= '0';
      for I in 0 to 31 loop
      	clk_tb <= '0';
        rs1_tb <= std_logic_vector(to_unsigned(I, 5));
        rs2_tb <= std_logic_vector(to_unsigned(I, 5));
        wait for 1 ns;
        clk_tb <= '1';
        if I /= 0 then
        	assert ro1_tb = std_logic_vector(to_unsigned((I + 1), 32)) report "falhou" severity error; -- se o I for diferente de 0, testa se o valor no reg é I + 1
        	assert ro2_tb = std_logic_vector(to_unsigned((I + 1), 32)) report "falhou" severity error;
        else
        	assert ro1_tb = X"00000000" report "falhou" severity error; -- senão, testa se o valor do reg zero é 0
        	assert ro2_tb = X"00000000" report "falhou" severity error;
        end if;
        wait for 1 ns;
      end loop;            
	  
      wait;
    end process;
end tb;

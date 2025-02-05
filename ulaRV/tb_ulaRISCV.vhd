library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ulaRISCV is
end tb_ulaRISCV;

architecture arquitetura of tb_ulaRISCV is

  component ulaRV
    generic (WSIZE : natural := 32);
    port (
      opcode : in std_logic_vector(3 downto 0);
      A, B : in std_logic_vector(31 downto 0);
      Z : out std_logic_vector(31 downto 0);
      cond : out std_logic;
      zero : out std_logic
    );
  end component;

  signal opcode_tb : std_logic_vector(3 downto 0) := (others => '0');
  signal A_tb, B_tb : std_logic_vector(31 downto 0) := (others => '0');
  signal Z_tb : std_logic_vector(31 downto 0);
  signal cond_tb, zero_tb : std_logic;

begin
  uut: ulaRV
    port map (
      opcode => opcode_tb,
      A => A_tb,
      B => B_tb,
      Z => Z_tb,
      cond => cond_tb,
      zero => zero_tb
    );

  stim_proc: process
  begin
    -- Teste 5 + 3	 
    A_tb <= X"00000005"; B_tb <= X"00000003"; opcode_tb <= "0000";
    wait for 10 ns;
    assert Z_tb = X"00000008" report "ADD 5 + 3 falhou" severity error;
	 assert zero_tb = '0' report "ADD 5 + 3 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste 3 + (-3)
	 A_tb <= X"00000003"; B_tb <= std_logic_vector(to_signed(-3, 32)); opcode_tb <= "0000";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "ADD 3 + (-3) operation failed" severity error;
	 assert zero_tb = '1' report "ADD 3 + (-3) zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste 3 + (-5)
	 A_tb <= std_logic_vector(to_signed(3, 32)) ; B_tb <= std_logic_vector(to_signed(-5, 32)); opcode_tb <= "0000"; --teste 3 + (-5) = -2
    wait for 10 ns;
    assert Z_tb = std_logic_vector(to_signed(-2, 32))report "ADD 3 + (-5) operation failed" severity error;
	 assert zero_tb = '0' report "ADD 3 + (-5) zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

	 -- Teste 5 - 3
    A_tb <= X"00000005"; B_tb <= X"00000003"; opcode_tb <= "0001"; 
    wait for 10 ns;
    assert Z_tb = X"00000002" report "SUB 5 - 3 operation failed" severity error;
	 assert zero_tb = '0' report "SUB 5 - 3 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste 5 - 5
	 A_tb <= X"00000005"; B_tb <= X"00000005"; opcode_tb <= "0001"; 
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SUB 5 - 5 operation failed" severity error;
	 assert zero_tb = '1' report "SUB 5 - 5 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste 5 - (-9)
	 A_tb <= X"00000005"; B_tb <= std_logic_vector(to_signed(-9, 32)); opcode_tb <= "0001"; 
    wait for 10 ns;
    assert Z_tb = X"0000000E" report "SUB 5 - (-9)) operation failed" severity error;
	 assert zero_tb = '0' report "SUB 5 - (-9)) zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

	 -- Teste 5 - 10
	 A_tb <= X"00000005"; B_tb <= X"0000000A"; opcode_tb <= "0001"; 
    wait for 10 ns;
    assert Z_tb = std_logic_vector(to_signed(-5, 32)) report "SUB 5 - 10 operation failed" severity error;
	 assert zero_tb = '0' report "SUB 5 - 10 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
    -- Teste AND
    A_tb <= X"FFFFFFFF"; B_tb <= X"0F0F0F0F"; opcode_tb <= "0010";
    wait for 10 ns;
    assert Z_tb = X"0F0F0F0F" report "AND operation failed" severity error;
	 assert zero_tb = '0' report "AND zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste OR
    A_tb <= X"0000FFFF"; B_tb <= X"FFFF0000"; opcode_tb <= "0011";
    wait for 10 ns;
    assert Z_tb = X"FFFFFFFF" report "OR operation failed" severity error;
	 assert zero_tb = '0' report "OR zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste XOR
    A_tb <= X"AAAAAAAA"; B_tb <= X"55555555"; opcode_tb <= "0100";
    wait for 10 ns;
    assert Z_tb = X"FFFFFFFF" report "XOR operation failed" severity error;
	 assert zero_tb = '0' report "XOR zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste shift left logical
    A_tb <= X"00000001"; B_tb <= X"00000004"; opcode_tb <= "0101";
    wait for 10 ns;
    assert Z_tb = X"00000010" report "SLL operation failed" severity error;
	 assert zero_tb = '0' report "SLL zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste shift right logical
	 A_tb <= X"00000005"; B_tb <= X"00000001"; opcode_tb <= "0110";
    wait for 10 ns;
    assert Z_tb = X"00000002" report "SRL operation failed" severity error;
	 assert zero_tb = '0' report "SRL zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste shift right arithmetic
	 A_tb <= X"80000005"; B_tb <= X"00000001"; opcode_tb <= "0111";
    wait for 10 ns;
    assert Z_tb = X"C0000002" report "SRA operation failed" severity error;
	 assert zero_tb = '0' report "SRA zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste set less than 3 < 4
    A_tb <= X"00000003"; B_tb <= X"00000004"; opcode_tb <= "1000";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SLT 3 < 4 operation failed" severity error;
	 assert zero_tb = '0' report "SLT 3 < 4 zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set less than 4 < 3
    A_tb <= X"00000004"; B_tb <= X"00000003"; opcode_tb <= "1000";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SLT 4 < 3 operation failed" severity error;
	 assert zero_tb = '1' report "SLT 4 < 3 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste set less than 4 < 4
    A_tb <= X"00000004"; B_tb <= X"00000004"; opcode_tb <= "1000";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SLT 4 < 4 operation failed for equal inputs" severity error;
	 assert zero_tb = '1' report "SLT 4 < 4 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste set less than unsigned FE < FF
	 A_tb <= X"FFFFFFFE"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1001";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SLTU FE < FF operation failed" severity error;
	 assert zero_tb = '0' report "SLTU FE < FF zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set less than unsigned FF < FE
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFE"; opcode_tb <= "1001";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SLTU FF < FE operation failed" severity error;
	 assert zero_tb = '1' report "SLTU FF < FE zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste set less than unsigned FF < FF
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1001";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SLTU FF < FF operation failed" severity error;
	 assert zero_tb = '1' report "SLTU FF < FF zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
		
	 -- Teste set greater or equal 4 >= 3
    A_tb <= X"00000004"; B_tb <= X"00000003"; opcode_tb <= "1010";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SGE 4 >= 3 operation failed" severity error;
	 assert zero_tb = '0' report "SGE 4 >= 3 zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set greater or equal 4 >= -4
    A_tb <= X"00000004"; B_tb <= std_logic_vector(to_signed(-4, 32)); opcode_tb <= "1010";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SGE 4 >= 3 operation failed" severity error;
	 assert zero_tb = '0' report "SGE 4 >= 3 zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set greater or equal 3 >= 4
    A_tb <= X"00000003"; B_tb <= X"00000004"; opcode_tb <= "1010";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SGE 3 <= 4 operation failed" severity error;
	 assert zero_tb = '1' report "SGE 3 <= 4 zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;

    -- Teste set greater or equal 4 >= 4
    A_tb <= X"00000004"; B_tb <= X"00000004"; opcode_tb <= "1010";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SGE 4 <= 4 operation failed for equal inputs" severity error;
	 assert zero_tb = '0' report "SGE 4 <= 4 zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set greater or equal unsigned FF >= FE
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFE"; opcode_tb <= "1011";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SGEU FF >= FE operation failed" severity error;
	 assert zero_tb = '0' report "SGEU FF >= FE zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set greater or equal unsigned FF >= FE
	 A_tb <= X"FFFFFFFE"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1011";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SGEU FF >= FE operation failed" severity error;
	 assert zero_tb = '1' report "SGEU FF >= FE zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste set greater or equal unsigned FF >= FF
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1011";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SGEU FF >= FF operation failed" severity error;
	 assert zero_tb = '0' report "SGEU FF >= FF zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set equal FF == FF
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1100";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SEQ FF == FF operation failed" severity error;
	 assert zero_tb = '0' report "SEQ FF == FF zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;	 
	 
	 -- Teste set equal FF == FE
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFE"; opcode_tb <= "1100";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SEQ FF == FE operation failed" severity error;
	 assert zero_tb = '1' report "SEQ FF == FE zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	 
	 -- Teste set not equal FF != FE
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFE"; opcode_tb <= "1101";
    wait for 10 ns;
    assert Z_tb = X"00000001" report "SNE FF != FE operation failed" severity error;
	 assert zero_tb = '0' report "SNE FF != FE zero falhou" severity error;
	 assert cond_tb = '1' report "falhou" severity error;
	 
	 -- Teste set not equal FF != FF
	 A_tb <= X"FFFFFFFF"; B_tb <= X"FFFFFFFF"; opcode_tb <= "1101";
    wait for 10 ns;
    assert Z_tb = X"00000000" report "SNE FF != FF operation failed" severity error;
	 assert zero_tb = '1' report "SNE FF != FF zero falhou" severity error;
	 assert cond_tb = '0' report "falhou" severity error;
	
    wait;
  end process;

end arquitetura;
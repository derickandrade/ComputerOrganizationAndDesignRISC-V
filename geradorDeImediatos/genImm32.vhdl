library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32 is
	port (
		instr : in std_logic_vector(31 downto 0);
		imm32 : out signed(31 downto 0)
	);
end genImm32;

architecture arquiteturaGerador of genImm32 is

	signal a: std_logic_vector(31 downto 0);

	begin
	process(instr)
		begin
		case instr(6 downto 0) is
			when "0000011" | "0010011" | "1100111" => -- Tipo I opcodes 0x03, 0x13 e 0x67; "or" não funciona aqui
				if ((instr(14 downto 12) = "101") or (instr(14 downto 12) = "001")) then -- Se o funct3 for 1 ou 5 então é Tipo I*; "|" não funciona aqui
					a(4 downto 0) <= instr(24 downto 20);
					a(31 downto 5) <= (others => '0');
				
				else -- Todos os outros casos de tipo I
					a(11 downto 0) <= instr(31 downto 20);
					a(31 downto 12) <= (others => instr(31));
					a(31) <= instr(31);
				end if;

			when "0110111" => -- Tipo U
				a(31 downto 12) <= instr(31 downto 12);
				a(11 downto 0) <= (others => '0');

			when "0100011" => -- Tipo S
				a(11 downto 5) <= instr(31 downto 25);
				a(4 downto 0) <= instr(11 downto 7);
				a(31 downto 12) <= (others => instr(31));
				
			when "1101111" => -- Tipo UJ
				a(20) <= instr(31);
				a(19 downto 12) <= instr(19 downto 12);
				a(11) <= instr(20);
				a(10 downto 1) <= instr(30 downto 21);
				a(0) <= '0';
				a(31 downto 21) <= (others => instr(31));

			when "1100011" => -- Tipo SB
			a(12) <= instr(31);
			a(11) <= instr(7);
			a(10 downto 5) <= instr(30 downto 25);
			a(4 downto 1) <= instr(11 downto 8);
			a(31 downto 13) <= (others => instr(31));

			when others => 
				a <= (others => '0');
		end case;
	imm32 <= to_signed(to_integer(signed(a)), 32);
	end process;
end arquiteturaGerador;
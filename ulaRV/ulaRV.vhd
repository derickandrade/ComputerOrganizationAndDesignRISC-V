library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaRV is
  generic (WSIZE : natural := 32);
  port (
    opcode : in std_logic_vector(3 downto 0);
    A, B : in std_logic_vector(31 downto 0);
    Z : out std_logic_vector(31 downto 0);
    cond : out std_logic;
	 zero : out std_logic);
end ulaRV;

architecture arquiteturaULA of ulaRV is
  
  signal a32 : std_logic_vector(31 downto 0);
  signal cond1 : std_logic;

  begin
    Z <= a32;
	 cond <= cond1;
    proc_ula: process(A, B, opcode, a32) begin
      if (a32 = X"00000000") then zero <= '1'; else zero <= '0'; end if;
	   case opcode is
		 when "0000" 	=> a32 <= std_logic_vector(signed(A) + signed(B)); cond1 <= '0'; /*SUM*/
		 when "0001" 	=> a32 <= std_logic_vector(signed(A) - signed(B));	cond1 <= '0'; /*SUB*/
		 when "0010" 	=> a32 <= A and B; cond1 <= '0'; 	/*AND*/
		 when "0011"  	=> a32 <= A or B; 	cond1 <= '0';/*OR*/
		 when "0100" 	=> a32 <= A xor B; cond1 <= '0';  /*XOR*/
		 when "0101" 	=> a32 <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))); cond1 <= '0'; /*SLL*/
		 when "0110" 	=> a32 <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))); cond1 <= '0';/*SRL*/
		 when "0111" 	=> a32 <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B)))) ;cond1 <= '0';	/*SRA*/
		 when "1000" 	=> /*SLT*/
			if (A < B) then 
				a32 <= X"00000001";
				cond1 <= '1';
			else
				a32 <= X"00000000"; 
				cond1 <= '0';
			end if;
			 
		 when "1001" => /*SLTU*/
			if (A < B) then
				a32 <= X"00000001";
				cond1 <= '1';
			else 
				a32 <= X"00000000";
				cond1 <= '0';
			end if;
			
		 when "1010" => /*SGE*/
			if ((signed(A) > signed(B)) or ((signed(A) = signed(B)))) then 
				a32 <= X"00000001"; 			
				cond1 <= '1';
			else 
				a32 <= X"00000000";
				cond1 <= '0';
			end if;
			
		 when "1011" => /*SGEU*/
			if ((unsigned(A) > unsigned(B)) or ((unsigned(A) = unsigned(B)))) then 
				a32 <= X"00000001"; 
				cond1 <= '1';
			else 
				a32 <= X"00000000";
				cond1 <= '0';
			end if;
			
		 when "1100" => /*SEQ*/
			if (A = B) then 
				a32 <= X"00000001";
				cond1 <= '1';
			else 
				a32 <= X"00000000";
				cond1 <= '0';
			end if;
			
		 when "1101" => /*SNE*/
			if (not(A = B)) then 
				a32 <= X"00000001";
				cond1 <= '1';
			else 
				a32 <= X"00000000";
				cond1 <= '0';
			end if;
		 when others =>
			a32 <= (others => '0');
			cond1 <= '0';
		end case;
  end process;
end arquiteturaULA;

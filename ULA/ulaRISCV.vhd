library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaRISCV is
  generic (WSIZE : natural := 32);
  port (
    opcode : in std_logic_vector(3 downto 0);
    A, B : in std_logic_vector(31 downto 0);
    Z : out std_logic_vector(31 downto 0);
    cond : out std_logic;
	 zero : out std_logic);
end ulaRISCV;

architecture arquiteturaULA of ulaRISCV is
  
  signal a32 : std_logic_vector(31 downto 0);

  begin
    Z <= a32;
    proc_ula: process(A, B, opcode, a32) begin
      if (a32 = X"00000000") then zero <= '1'; else zero <= '0'; end if;
        case opcode is
          when "0000" 	=> a32 <= std_logic_vector(signed(A) + signed(B));
          when "0001" 	=> a32 <= std_logic_vector(signed(A) - signed(B));
          when "0010" 	=> a32 <= A and B;
          when "0011"  	=> a32 <= A or B;
          when "0100" 	=> a32 <= A xor B;
          when "0101" 	=> a32 <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
          when "0110" 	=> a32 <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
          when "0111" 	=> a32 <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
          when "1000" 	=> 
				if (A < B) then 
					a32 <= X"00000001"; 
				else
					a32 <= X"00000000"; 
				end if;
				
          when "1001" =>
				if (A < B) then
					a32 <= X"00000001";
				else 
					a32 <= X"00000000";
				end if;
				
          when "1010" =>
				if (A > B) then 
					a32 <= X"00000001"; 
				else 
					a32 <= X"00000000"; 
				end if;
				
          when "1011" =>
				if (A > B) then 
					a32 <= X"00000001"; 
				else 
					a32 <= X"00000000"; 
				end if;
				
          when "1100" =>
				if (A = B) then 
					a32 <= X"00000001"; 
				else 
					a32 <= X"00000000"; 
				end if;
				
          when "1101" =>
				if (not(A = B)) then 
					a32 <= X"00000001"; 
				else 
					a32 <= X"00000000"; 
				end if;
			 when others =>
				a32 <= (others => '0');				
      end case;
  end process;
end arquiteturaULA;

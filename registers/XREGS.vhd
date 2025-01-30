LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity XREGS is
generic (WSIZE : natural := 32);
port (
clk, wren : in std_logic;
rs1, rs2, rd : in std_logic_vector(4 downto 0);
data : in std_logic_vector(WSIZE-1 downto 0);
ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0));
end XREGS;

ARCHITECTURE arch OF XREGS IS
TYPE reg is array (31 downto 0) of std_logic_vector(31 downto 0);

signal registrador : reg := (others => (others => '0'));
signal address1 : integer range 0 to 31;
signal address2 : integer range 0 to 31;
signal addressd : integer range 0 to 31;

begin
  process(clk, wren, rs1, rs2, rd, data)

  begin    	      
    addressd <= to_integer(unsigned(rd));
    if (rising_edge(clk) and addressd /= 0 and wren = '1') then        	            	                            
     	registrador(addressd) <= data;                                                    
    end if;
        
  end process;
   	address1 <= to_integer(unsigned(rs1));
    address2 <= to_integer(unsigned(rs2));
		ro1 	   <= registrador(address1);
    ro2 	   <= registrador(address2);    
end arch;

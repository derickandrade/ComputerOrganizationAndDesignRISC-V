LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ram_rv is
 port (
 clk : in std_logic;
 we : in std_logic;
 byte_en : in std_logic;
 sgn_en : in std_logic;
 address : in std_logic_vector(12 downto 0);
 datain : in std_logic_vector(31 downto 0);
 dataout : out std_logic_vector(31 downto 0)
 );
end entity ram_rv;


architecture RTL of ram_rv is
  Type mem_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
  signal mem : mem_type := (others => (others => '0'));
  signal addrss : integer range 0 to 8191;

begin
--addrss <= to_integer(unsigned(address)); -- Atualiza o endereço para leitura
  process(clk) -- Somente para escrita no RAM
  begin
    if (rising_edge(clk)) then      
      if (we = '1') then
        if ((byte_en = '0') and (addrss mod 4 = 0)) then
          mem(addrss) <= datain;
        elsif (byte_en = '1') then
          mem(addrss)(7 downto 0) <= datain(7 downto 0);        
        end if;
      end if;
    end if;
  end process;

  -- Processo independente do clock para leitura de dados
  process(we) -- Leitura
  begin
    addrss <= to_integer(unsigned(address)); -- Atualiza o endereço para leitura
    if (we = '0') then
      if ((byte_en = '0') and (addrss mod 4 = 0)) then
        dataout <= mem(addrss); -- Leitura de 32 bits
      elsif ((byte_en = '1') and (sgn_en = '0')) then
        dataout(7 downto 0) <= mem(addrss)(7 downto 0); -- Leitura de 8 bits com zero padding
        dataout(31 downto 8) <= (others => '0');
      elsif ((byte_en = '1') and (sgn_en = '1')) then
        dataout(7 downto 0) <= mem(addrss)(7 downto 0); -- Leitura de 8 bits com sinal
        dataout(31 downto 8) <= (others => mem(addrss)(7));
      else
        dataout(31 downto 0) <= (others => 'Z'); -- Caso indeterminado (alta impedância)
      end if;
    else
      dataout(31 downto 0) <= (others => 'Z'); -- Caso indeterminado (alta impedância)
    end if;
  end process;

end RTL;


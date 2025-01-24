library verilog;
use verilog.vl_types.all;
entity ulaRV is
    port(
        opcode          : in     vl_logic_vector(3 downto 0);
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Z               : out    vl_logic_vector(31 downto 0);
        cond            : out    vl_logic;
        zero            : out    vl_logic
    );
end ulaRV;

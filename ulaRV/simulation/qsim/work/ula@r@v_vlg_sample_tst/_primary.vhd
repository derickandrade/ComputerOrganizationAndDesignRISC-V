library verilog;
use verilog.vl_types.all;
entity ulaRV_vlg_sample_tst is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        opcode          : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end ulaRV_vlg_sample_tst;

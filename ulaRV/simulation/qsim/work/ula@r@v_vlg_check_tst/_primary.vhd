library verilog;
use verilog.vl_types.all;
entity ulaRV_vlg_check_tst is
    port(
        cond            : in     vl_logic;
        Z               : in     vl_logic_vector(31 downto 0);
        zero            : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ulaRV_vlg_check_tst;

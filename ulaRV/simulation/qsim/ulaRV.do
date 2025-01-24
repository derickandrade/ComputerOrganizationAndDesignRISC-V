onerror {quit -f}
vlib work
vlog -work work ulaRV.vo
vlog -work work ulaRV.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ulaRV_vlg_vec_tst
vcd file -direction ulaRV.msim.vcd
vcd add -internal ulaRV_vlg_vec_tst/*
vcd add -internal ulaRV_vlg_vec_tst/i1/*
add wave /*
run -all

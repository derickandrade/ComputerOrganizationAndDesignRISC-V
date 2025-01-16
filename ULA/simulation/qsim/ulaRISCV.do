onerror {quit -f}
vlib work
vlog -work work ulaRISCV.vo
vlog -work work ulaRISCV.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.ulaRISCV_vlg_vec_tst
vcd file -direction ulaRISCV.msim.vcd
vcd add -internal ulaRISCV_vlg_vec_tst/*
vcd add -internal ulaRISCV_vlg_vec_tst/i1/*
add wave /*
run -all

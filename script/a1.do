onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_square_root/clk
add wave -noupdate /tb_square_root/reset
add wave -noupdate /tb_square_root/StopSim
add wave -noupdate /tb_square_root/start
add wave -noupdate /tb_square_root/finished
add wave -noupdate -radix unsigned /tb_square_root/A
add wave -noupdate -radix unsigned /tb_square_root/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {530 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {7088 ns}

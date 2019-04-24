onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/uut/Banco_IF_ID/IR_in
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/CLK
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/ADDR
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/Din
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/WE
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/RE
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/Dout
add wave -noupdate -expand -group Mem -expand /testbench/uut/Mem_D/RAM
add wave -noupdate -expand -group Mem /testbench/uut/Mem_D/dir_7
add wave -noupdate /testbench/uut/saltar
add wave -noupdate /testbench/uut/Z
add wave -noupdate /testbench/uut/cmp_eq
add wave -noupdate /testbench/uut/cmp_ne
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/DIn0
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/DIn1
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/DIn2
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/DIn3
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/ctrl
add wave -noupdate -expand -group muxPC /testbench/uut/muxPC/Dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {401 ns} {611 ns}

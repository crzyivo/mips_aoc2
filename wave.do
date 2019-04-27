onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/uut/Banco_IF_ID/IR_ID
add wave -noupdate /testbench/uut/prediction
add wave -noupdate /testbench/uut/predictor_error
add wave -noupdate /testbench/uut/address_error
add wave -noupdate /testbench/uut/decission_error
add wave -noupdate /testbench/uut/prediction_ID
add wave -noupdate /testbench/uut/saltar
add wave -noupdate /testbench/uut/Z
add wave -noupdate /testbench/uut/Branch
add wave -noupdate /testbench/uut/avanzar_ID
add wave -noupdate /testbench/uut/PC4_ID
add wave -noupdate /testbench/uut/DirSalto_ID
add wave -noupdate /testbench/uut/address_predicted_ID
add wave -noupdate -group predictor /testbench/uut/b_predictor/PC4
add wave -noupdate -group predictor /testbench/uut/b_predictor/branch_address_out
add wave -noupdate -group predictor /testbench/uut/b_predictor/prediction_out
add wave -noupdate -group predictor /testbench/uut/b_predictor/PC4_ID
add wave -noupdate -group predictor /testbench/uut/b_predictor/prediction_in
add wave -noupdate -group predictor /testbench/uut/b_predictor/branch_address_in
add wave -noupdate -group predictor /testbench/uut/b_predictor/update
add wave -noupdate -group predictor /testbench/uut/b_predictor/valid
add wave -noupdate -group predictor /testbench/uut/b_predictor/prediction
add wave -noupdate -group predictor /testbench/uut/b_predictor/tag
add wave -noupdate -group predictor /testbench/uut/b_predictor/address
add wave -noupdate -group Mem /testbench/uut/Mem_D/CLK
add wave -noupdate -group Mem /testbench/uut/Mem_D/ADDR
add wave -noupdate -group Mem /testbench/uut/Mem_D/Din
add wave -noupdate -group Mem /testbench/uut/Mem_D/WE
add wave -noupdate -group Mem /testbench/uut/Mem_D/RE
add wave -noupdate -group Mem /testbench/uut/Mem_D/Dout
add wave -noupdate -group Mem -expand /testbench/uut/Mem_D/RAM
add wave -noupdate -group Mem /testbench/uut/Mem_D/dir_7
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/DIn0
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/DIn1
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/DIn2
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/DIn3
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/ctrl
add wave -noupdate -expand -group muxpc /testbench/uut/muxPC/Dout
add wave -noupdate -group BR /testbench/uut/Register_bank/clk
add wave -noupdate -group BR /testbench/uut/Register_bank/reset
add wave -noupdate -group BR /testbench/uut/Register_bank/RA
add wave -noupdate -group BR /testbench/uut/Register_bank/RB
add wave -noupdate -group BR /testbench/uut/Register_bank/RW
add wave -noupdate -group BR /testbench/uut/Register_bank/BusW
add wave -noupdate -group BR /testbench/uut/Register_bank/RegWrite
add wave -noupdate -group BR /testbench/uut/Register_bank/BusA
add wave -noupdate -group BR /testbench/uut/Register_bank/BusB
add wave -noupdate -group BR -expand /testbench/uut/Register_bank/reg_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
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
WaveRestoreZoom {0 ns} {193 ns}

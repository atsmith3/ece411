onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mp2_tb/clk
add wave -noupdate -radix hexadecimal /mp2_tb/mem_resp
add wave -noupdate -radix hexadecimal /mp2_tb/mem_read
add wave -noupdate -radix hexadecimal /mp2_tb/mem_write
add wave -noupdate -radix hexadecimal /mp2_tb/mem_byte_enable
add wave -noupdate -radix hexadecimal /mp2_tb/mem_address
add wave -noupdate -radix hexadecimal /mp2_tb/mem_rdata
add wave -noupdate -radix hexadecimal /mp2_tb/mem_wdata
add wave -noupdate -radix hexadecimal -childformat {{{/mp2_tb/dut/_datapath/_regfile/data[7]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[6]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[5]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[4]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[3]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[2]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[1]} -radix hexadecimal} {{/mp2_tb/dut/_datapath/_regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/_datapath/_regfile/data[7]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[6]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[5]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[4]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[3]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[2]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[1]} {-height 17 -radix hexadecimal} {/mp2_tb/dut/_datapath/_regfile/data[0]} {-height 17 -radix hexadecimal}} /mp2_tb/dut/_datapath/_regfile/data
add wave -noupdate /mp2_tb/dut/_control/state
add wave -noupdate /mp2_tb/dut/_control/next_state
add wave -noupdate -label PC -radix hexadecimal /mp2_tb/dut/_datapath/pc/data
add wave -noupdate -label IR -radix hexadecimal /mp2_tb/dut/_datapath/_ir/data
add wave -noupdate -label MAR -radix hexadecimal /mp2_tb/dut/_datapath/mar/data
add wave -noupdate -label MDR -radix hexadecimal /mp2_tb/dut/_datapath/mdr/data
add wave -noupdate /mp2_tb/dut/_control/jsr_bit
add wave -noupdate -radix symbolic /mp2_tb/dut/_datapath/pcmux/sel
add wave -noupdate -radix hexadecimal /mp2_tb/dut/_datapath/pcmux/a
add wave -noupdate -radix hexadecimal /mp2_tb/dut/_datapath/pcmux/b
add wave -noupdate -radix hexadecimal /mp2_tb/dut/_datapath/pcmux/c
add wave -noupdate -radix hexadecimal /mp2_tb/dut/_datapath/pcmux/d
add wave -noupdate -radix hexadecimal /mp2_tb/dut/_datapath/pcmux/f
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {539858 ps} 0}
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
WaveRestoreZoom {0 ps} {2100 ns}

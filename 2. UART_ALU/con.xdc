set_property PACKAGE_PIN K17 [get_ports clk]
set_property PACKAGE_PIN Y16 [get_ports rst]
set_property PACKAGE_PIN W8 [get_ports rx]
set_property PACKAGE_PIN V8 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
create_clock -add -name clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];


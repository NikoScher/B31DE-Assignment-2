# Clock signal
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports CLK]							
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
	
#Active high RESET - BTNR on Basys 3 board
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports RESET]

#LEDs
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports LED[0]]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports LED[1]]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports LED[2]]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports LED[3]]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports LED[4]]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports LED[5]]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports LED[6]]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports LED[7]]

##VGA Connector
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports vgaRed[0]]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports vgaRed[1]]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports vgaRed[2]]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports vgaBlue[0]]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports vgaBlue[1]]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports vgaGreen[0]]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports vgaGreen[1]]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports vgaGreen[2]]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports Hsync]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports Vsync]

#USB-RS232 Interface
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports RsRx]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports RsTx]
	
#Switches
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports sw[0]]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports sw[1]]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports sw[2]]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports sw[3]]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports sw[4]]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports sw[5]]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports sw[6]]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports sw[7]]

#7 segment display
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports seg[0]]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports seg[1]]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports seg[2]]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports seg[3]]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports seg[4]]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports seg[5]]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports seg[6]]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports dp]							
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports an[0]]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports an[1]]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports an[2]]
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports an[3]]


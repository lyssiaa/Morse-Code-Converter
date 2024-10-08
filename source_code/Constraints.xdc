## This file is a general .xdc for the Basys3 rev B board for ENGS31/CoSc56
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project
## - these names should match the external ports (_ext_port) in the entity declaration of your shell/top level

##====================================================================
## External_Clock_Port
##====================================================================
## This is a 100 MHz external clock
set_property PACKAGE_PIN W5 [get_ports clk_ext]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_ext]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_ext]

 
##====================================================================
## LED_ports
##====================================================================
#LED 0 (RIGHT MOST LED)
set_property PACKAGE_PIN U16 [get_ports {light}]					
set_property IOSTANDARD LVCMOS33 [get_ports {light}]

 
##====================================================================
## Pmod Header JB
##====================================================================
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {wave}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {wave}]


##====================================================================
## USB-RS232 Interface
##====================================================================
set_property PACKAGE_PIN B18 [get_ports Rx_ext]						
	set_property IOSTANDARD LVCMOS33 [get_ports Rx_ext]



##====================================================================
## Implementation Assist
##====================================================================	
## These additional constraints are recommended by Digilent, DO NOT REMOVE!
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]   
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

#    _   _                     
#   | \ | |                    
#   |  \| | _____  ___   _ ___ 
#   | . ` |/ _ \ \/ / | | / __|
#   | |\  |  __/>  <| |_| \__ \
#   |_| \_|\___/_/\_\\__, |___/
#                     __/ |    
#                    |___/     


### Constraint File for the Nexys 4 DDR and Nexys A7-100T/A7-50T boards


#######################################
#  _______ _           _              #
# |__   __(_)         (_)             #
#    | |   _ _ __ ___  _ _ __   __ _  #
#    | |  | | '_ ` _ \| | '_ \ / _` | #
#    | |  | | | | | | | | | | | (_| | #
#    |_|  |_|_| |_| |_|_|_| |_|\__, | #
#                               __/ | #
#                              |___/  #
#######################################


#Create constraint for the clock input of the nexys board
create_clock -period 10.000 -name ref_clk [get_ports sys_clk]

#I2S and CAM interface are not used in this FPGA port. Set constraints to
#disable the clock
#set_input_jitter tck 1.000

## JTAG
create_clock -period 100.000 -name tck -waveform {0.000 50.000} [get_ports pad_jtag_tck]
set_input_jitter tck 1.000
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_int]


# minimize routing delay
set_input_delay -clock tck -clock_fall 5.000 [get_ports pad_jtag_tdi]
set_input_delay -clock tck -clock_fall 5.000 [get_ports pad_jtag_tms]
set_output_delay -clock tck 5.000 [get_ports pad_jtag_tdo]


set_max_delay -to [get_ports pad_jtag_tdo] 20.000
set_max_delay -from [get_ports pad_jtag_tms] 20.000
set_max_delay -from [get_ports pad_jtag_tdi] 20.000


set_max_delay -datapath_only -from [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_src/data_src_q_reg*/C] -to [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_dst/data_dst_q_reg*/D] 20.000
set_max_delay -datapath_only -from [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_src/req_src_q_reg/C] -to [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_dst/req_dst_q_reg/D] 20.000
set_max_delay -datapath_only -from [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_req/i_dst/ack_dst_q_reg/C] -to [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_dmi_jtag/i_dmi_cdc/i_cdc_req/i_src/ack_src_q_reg/D] 20.000


# reset signal
set_false_path -from [get_ports pad_reset_n]

# Set ASYNC_REG attribute for ff synchronizers to place them closer together and
# increase MTBF
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/apb_adv_timer_i/u_tim0/u_in_stage/r_ls_clk_sync_reg*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/apb_adv_timer_i/u_tim1/u_in_stage/r_ls_clk_sync_reg*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/apb_adv_timer_i/u_tim2/u_in_stage/r_ls_clk_sync_reg*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/apb_adv_timer_i/u_tim3/u_in_stage/r_ls_clk_sync_reg*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/i_apb_timer_unit/s_ref_clk*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/i_ref_clk_sync/i_pulp_sync/r_reg_reg*]
set_property ASYNC_REG true [get_cells i_pulpissimo/soc_domain_i/pulp_soc_i/soc_peripherals_i/u_evnt_gen/r_ls_sync_reg*]

# Create asynchronous clock group between slow-clk and SoC clock. Those clocks
# are considered asynchronously and proper synchronization regs are in place
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins i_pulpissimo/safe_domain_i/i_slow_clk_gen/i_slow_clk_mngr/inst/mmcm_adv_inst/CLKOUT0]] -group [get_clocks -of_objects [get_pins i_pulpissimo/soc_domain_i/pulp_soc_i/i_clk_rst_gen/i_fpga_clk_gen/i_clk_manager/inst/mmcm_adv_inst/CLKOUT0]]


#############################################################
#  _____ ____         _____      _   _   _                  #
# |_   _/ __ \       / ____|    | | | | (_)                 #
#   | || |  | |_____| (___   ___| |_| |_ _ _ __   __ _ ___  #
#   | || |  | |______\___ \ / _ \ __| __| | '_ \ / _` / __| #
#  _| || |__| |      ____) |  __/ |_| |_| | | | | (_| \__ \ #
# |_____\____/      |_____/ \___|\__|\__|_|_| |_|\__, |___/ #
#                                                 __/ |     #
#                                                |___/      #
#############################################################

## Sys clock
set_property -dict {PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports sys_clk]

## Buttons
set_property -dict {PACKAGE_PIN C12  IOSTANDARD LVCMOS33} [get_ports pad_reset_n]
#set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports btnc_i]
#set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports btnd_i]
#set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports btnl_i]
#set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports btnr_i]
#set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports btnu_i]

## PMOD A as JTAG 
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports pad_jtag_tms]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports pad_jtag_tdi]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports pad_jtag_tdo]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports pad_jtag_tck]

##PMOD B for I2C and I2S
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports pad_i2c0_sda] 
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports pad_i2c0_scl]
## debug UART
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports dbg_uart_tx] 

## UART
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports pad_uart_rx]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports pad_uart_tx]
#set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports pad_uart_cts]
#set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports pad_uart_rts]

## LEDs
#set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports led0_o]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports led1_o]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports led2_o]
#set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports led3_o]
## use for some GPIO Outputs
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports gpio2[29]]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports gpio2[30]]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports gpio2[31]]

## Switches
## used for some GPIO Inputs
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports gpio1[17]]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports gpio1[18]]

##Buttons
##use for some GPIO Inputs
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports gpio1[19]]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports gpio2[28]]

## QSPI Flash
## disabled. Have a look at the Readme
#set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports pad_spim_csn0]
#set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio0]
#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio1]
#set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio2]
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio3]
# not working for now

#Use PMOD C for SPIM0 and SPIM1
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports pad_spim_csn0] 
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio0] 
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio1] 
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio2] 
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS33} [get_ports pad_spim_sdio3] 
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports pad_spim_sck] 
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports pad_spim_csn1] 

#USE PMOD D for Advanced Timer PWM Output
#JD1 = 0 / GPIO 9 / Timer 1 Channel 0
set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports gpio1[9]  ] 	
#JD2 = 0 / GPIO 10 / Timer 1 Channel 1
set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports gpio1[10] ]
#JD3 = 0 / GPIO 11 / Timer 1 Channel 2
set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports gpio1[11] ]
#JD4 = 0 / GPIO 12 / Timer 1 Channel 3
set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports gpio1[12] ]
#JD7 = 0 / GPIO 13 / Timer 2 Channel 0
set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports gpio1[13] ]
#JD8 = 0 / GPIO 14 / Timer 2 Channel 1
set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports gpio1[14] ]
#JD9 = 0 / GPIO 15 / Timer 2 Channel 2
set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports gpio1[15] ]
#JD10 = 0 / GPIO 16 / Timer 2 Channel 3
set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports gpio1[16] ]


## SD Card
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports pad_sdio_clk]
#set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports { sd_cd }]; 
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports pad_sdio_cmd]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports pad_sdio_data0]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports pad_sdio_data1]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports pad_sdio_data2]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports pad_sdio_data3]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports sdio_reset_o]




# Nexys 4 has a quad SPI flash
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

# Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

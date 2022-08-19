create_clock -name board_clk -period 20.000 [get_ports {board_clk}]
derive_pll_clocks
derive_clock_uncertainty

set_false_path -from [get_ports {sw_sig[*] btn_sig[*]}]
set_false_path -to [get_ports {b_out[*] blank_n g_out[*] h_synch r_out[*] sync_n v_synch vga_clk}]
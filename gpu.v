`include "define.v"
module gpu(clk, enb, rst_n, h_synch, v_synch, blank_n, sync_n, vga_clk, pixel, line, pixel_0_line_0,
r_out, g_out, b_out, rden_out, sprite_data);
	
	input clk;
	input enb;
	input rst_n;
	input [`NBR_SPRITES-1:0] rden_out;
	input [`NBR_SPRITES*8-1:0] sprite_data;
	
	output h_synch;
	output v_synch;
	output blank_n;
	output sync_n;
	output vga_clk;
	output signed [`CORDW-1:0] pixel;
	output signed [`CORDW-1:0] line;
	output pixel_0_line_0;
	output [7:0] r_out;
	output [7:0] g_out;
	output [7:0] b_out;
	
	wire [23:0] colors_q;
	wire [7:0] out_color;
	wire [$clog2(`NBR_SPRITES)-1:0] binary;
	
	assign r_out = colors_q [23:16];
	assign g_out = colors_q [15:8];
	assign b_out = colors_q [7:0];
	
	VGA_controller u1(
		.enb(enb),
		.rst_n(rst_n),
		.clk(clk),
		.h_synch(h_synch),
		.v_synch(v_synch),
		.blank_n(blank_n),
		.sync_n(sync_n),
		.vga_clk(vga_clk),
		.pixel(pixel),
		.line(line),
		.pixel_0_line_0(pixel_0_line_0)
	);
		
	colors	u8 (
		.address ( out_color ),
		.clock ( clk ),
		.q ( colors_q )
		);
		
		parity_encoder #(.OHW(`NBR_SPRITES)) u9(
			.oht(rden_out),
			.bin(binary)
		);
		
		muxu u10 (
			.data(sprite_data),
			.sel(binary),
			.result(out_color)
		);
endmodule
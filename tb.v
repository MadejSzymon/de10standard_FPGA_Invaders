`timescale 1ns/100ps
`include "define.v"
module tb();
	
	reg board_clk;
	wire h_synch;
	wire v_synch;
	wire blank_n;
	wire sync_n;
	wire [7:0] r_out;
	wire [7:0] g_out;
	wire [7:0] b_out;
	wire vga_clk;
	reg enb;
	reg rst_n;
	wire signed [`CORDW-1:0] pixel;
	wire signed [`CORDW-1:0] line;
	wire [5:0] addr;
	wire rden;
	
	initial begin
		board_clk <= 0;
		enb <= 0;
		rst_n <= 0;
	end
	
	always begin
		#10;
		board_clk <= !board_clk;
	end
	
	
	top DUT 
	(.enb(enb),
	.rst_n(rst_n),
	.board_clk(board_clk),
	.h_synch(h_synch),
	.v_synch(v_synch),
	.blank_n(blank_n),
	.sync_n(sync_n), 
	.vga_clk(vga_clk),
	.r_out(r_out), 
	.g_out(g_out),
	.b_out(b_out),
	.pixel(pixel),
	.line(line),
	.addr(addr),
	.rden(rden)
	);
	
	initial begin
		repeat (3) @(posedge board_clk);
		enb <= 1;
		repeat (3) @(posedge board_clk);
		rst_n <= 1;
	end
	
endmodule 

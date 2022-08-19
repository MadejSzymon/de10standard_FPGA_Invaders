`include "define.v"
module VGA_controller(enb, clk, rst_n, h_synch, v_synch, blank_n, sync_n, vga_clk, pixel, line, pixel_0_line_0);


	input clk;
	input enb;
	input rst_n;
	
	output reg signed [`CORDW-1:0] pixel;
	output reg signed [`CORDW-1:0] line;
	output h_synch;
	output v_synch;
	output blank_n;
	output sync_n;
	output vga_clk;
	output pixel_0_line_0;
	
	reg enb_del;

	
	initial begin
		pixel <= `H_STA;
		enb_del <= 0;
		line <= `V_STA;
	end
	
	assign pixel_0_line_0 = (pixel == 1'b0 && line == 1'b0) ? 1'b1 : 1'b0;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			pixel <= `H_STA;
			enb_del <= `H_STA;
			line <= `V_STA;
		end
		else begin
			enb_del <= enb;
			if (enb_del == 1) begin
				pixel <= pixel + 1;
			end
			if (pixel == `HA_END) begin
				pixel <= `H_STA;
				line <= line + 1;
			end
			if (line == `VA_END && pixel == `HA_END) begin
				line <= `V_STA;
			end
		end
	end
	
	assign h_synch = (pixel > `HS_STA && pixel <= `HS_END ) ? 1'b0 : 1'b1;
	assign v_synch = (line > `VS_STA && line <= `VS_END) ? 1'b0 : 1'b1;
	assign blank_n = 1'b1;
	assign sync_n = 1'b1;
	assign vga_clk = clk;
	
endmodule 
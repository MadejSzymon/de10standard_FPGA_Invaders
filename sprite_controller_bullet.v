`include "define.v"
module sprite_controller_bullet 
(clk, rst_n, pixel, line, addr, rden, bullet_x, bullet_y);
	
	input clk;
	input rst_n;
	input [9:0] bullet_x;
	input [9:0] bullet_y;
	input [`CORDW-1:0] pixel;
	input [`CORDW-1:0] line;
	
	output reg [7:0] addr;
	output rden;
	
	initial begin
		addr <= 1'b0;
	end
	
	assign rden = (pixel >= bullet_x-2 && pixel <= bullet_x + `BULLET_W-3 && line >= bullet_y && line < bullet_y + `BULLET_H) ? 1'b1: 1'b0;
	
	always @(posedge clk) begin
		if(line == 1)
			addr <= 0;
		if(rst_n == 1'b0) begin
			addr <= 1'b0;
		end
		else if(rden == 1'b1) begin
			addr <= addr + 1'b1;
		end
		
	end
	
	
endmodule 
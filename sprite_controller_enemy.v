`include "define.v"
module sprite_controller_enemy #(parameter SPR_X) 
(clk, rst_n, pixel, line, addr, rden, enemy_y);

	
	input clk;
	input rst_n;
	input [`CORDW-1:0] pixel;
	input [`CORDW-1:0] line;
	input [9:0] enemy_y;
	
	output reg [11:0] addr;
	output rden;
	
	initial begin
		addr <= 1'b0;
	end
	
	assign rden = (pixel >= SPR_X-2 && pixel <= SPR_X + `ENEMY_W-3 && line >= enemy_y && line < enemy_y + `ENEMY_H) ? 1'b1: 1'b0;
	
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
`include "define.v"
module sprite_controller_player 
(clk, rst_n, pixel, line, addr, rden, player_x);
	
	input clk;
	input rst_n;
	input [9:0] player_x;
	input [`CORDW-1:0] pixel;
	input [`CORDW-1:0] line;
	
	output reg [11:0] addr;
	output rden;
	
	initial begin
		addr <= 1'b0;
	end
	
	assign rden = (pixel >= player_x-2 && pixel <= player_x + `PLAYER_W-3 && line >= `PLAYER_Y && line < `PLAYER_Y + `PLAYER_H) ? 1'b1: 1'b0;
	
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
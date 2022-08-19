`include "define.v"
module sprite_controller_game_over 
(clk, rst_n, pixel, line, addr, rden, game_over_x);

	input clk;
	input rst_n;
	input [`CORDW-1:0] pixel;
	input [`CORDW-1:0] line;
	input [9:0] game_over_x;
	
	output reg [15:0] addr;
	output rden;
	
	initial begin
		addr <= 1'b0;
	end
	
	assign rden = (pixel >= game_over_x-2 && pixel <= game_over_x + `GAME_OVER_W-3 && line >= `GAME_OVER_Y && line < `GAME_OVER_Y + `GAME_OVER_H) ? 1'b1: 1'b0;
	
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
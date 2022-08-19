`include "define.v"
module sprite_controller_scoreboard #(parameter SPR_X) 
(clk, rst_n, pixel, line, addr, rden);
	
	input clk;
	input rst_n;
	input [`CORDW-1:0] pixel;
	input [`CORDW-1:0] line;
	
	output reg [9:0] addr;
	output rden;
	
	reg [6:0] counter_p;
	reg [6:0] counter_l;
	
	initial begin
		addr <= 1'b0;
	end
	
	assign rden = (pixel >= SPR_X-2 && pixel <= SPR_X + `SCORE_W-3 && line >= `SCORE_Y && line < `SCORE_Y + `SCORE_H) ? 1'b1: 1'b0;
	
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
`include "define.v"
module enb_game_controller(clk,enb,pixel,line);
	input clk;
	input signed [`CORDW-1:0] pixel;
	input signed [`CORDW-1:0] line;
	
	output reg enb;
	
	initial begin
		enb <= 0;
	end
	
	always@(posedge clk) begin
		if (pixel == 650 && line == 490)
			enb <= 1;
		else
			enb <= 0;
	end
endmodule 
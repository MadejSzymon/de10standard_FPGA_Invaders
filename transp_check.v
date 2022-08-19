`include "define.v"
module transp_check(rden, sprite_data, rden_out);
	input rden;
	input [7:0] sprite_data;
	
	output rden_out;
	
	assign rden_out = (sprite_data != 8'h0D) ? rden : 1'b0;
	
endmodule
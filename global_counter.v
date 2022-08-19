`include "define.v"
module global_counter(clk,global_tick, enb, rst, pixel_0_line_0);
	input clk;
	input enb;
	input rst;
	input pixel_0_line_0;
	
	output reg global_tick;
	
	reg [`GLOBAL_COUNTER_SIZE-1:0] counter;
	
	initial begin
		global_tick <= 0;
		counter <= 0;
	end
	
	always@(posedge clk) begin
		if(rst) begin
			global_tick <= 0;
			counter <= 0;
		end
		else begin
			global_tick <= 0;
			if(enb && pixel_0_line_0) begin
				counter <= counter + 1'b1;
				if(counter == 0) 
					global_tick <= 1'b1;
			end
		end
	end
endmodule 
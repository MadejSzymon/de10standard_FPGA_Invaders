`include "define.v"
module enemy_spawn_counter(clk,tick,enb,rst,prbs_val,global_tick, pixel_0_line_0, state);

	input clk;
	input enb;
	input rst;
	input global_tick;
	input [`SPAWN_COUNTER_SIZE-1:0] prbs_val;
	input pixel_0_line_0;
	input [2:0] state;
	
	parameter [2:0] TITLE = 3'b100;
	
	output reg tick;
	
	reg [`SPAWN_COUNTER_SIZE-1:0] p;
	reg [`SPAWN_COUNTER_SIZE-1:0] counter;
	
	initial begin
		counter <= 0;
		tick <= 0;
		p <= {`SPAWN_COUNTER_SIZE{1'b1}};
	end
	
	always@(posedge clk) begin
		if(global_tick || state == TITLE)
			p <= prbs_val;
	end
	
	
	always@(posedge clk) begin
		if(rst) begin
			counter <= 0;
			tick <= 0;
		end
		else begin
			if(enb && pixel_0_line_0) begin
				counter <= counter + 1'b1;
				if(counter == p) 
					tick <= 1'b1;
				else
					tick <= 0;
			end
		end
	end
	
endmodule 
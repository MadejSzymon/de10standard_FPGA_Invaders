`include "define.v"
module enemy_spawn_controller(clk, enb, rst, tick,pixel_0_line_0, state);
	input clk;
	input enb;
	input rst;
	input pixel_0_line_0;
	input [2:0] state;
	output [7:0] tick;
	
	wire global_tick;
	wire [`SPAWN_COUNTER_SIZE-1+`NBR_ENEMIES:0] prbs_val;
	genvar i;
	
	generate 
		for(i=0;i<8;i=i+1) begin:spawn_for
			enemy_spawn_counter enemy_spawn_counter_inst
		(
			.clk(clk) ,	// input  clk_sig
			.tick(tick[i]) ,	// output  tick_sig
			.enb(enb) ,	// input  enb_sig
			.pixel_0_line_0(pixel_0_line_0),
			.rst(rst) ,	// input  rst_sig
			.prbs_val(prbs_val[i+`SPAWN_COUNTER_SIZE-1:i]) ,
			.global_tick(global_tick),
			.state(state)
		);
		end
	endgenerate
	
	global_counter global_counter_inst
(
	.clk(clk) ,	// input  clk_sig
	.global_tick(global_tick) ,	// output  global_tick_sig
	.enb(enb) ,	// input  enb_sig
	.pixel_0_line_0(pixel_0_line_0),
	.rst(rst) 	// input  rst_sig
);

prbs prbs_inst
(
	.clk(clk) ,	// input  clk_sig
	.prbs_val(prbs_val),
	.pixel_0_line_0(pixel_0_line_0)
);
	
endmodule 
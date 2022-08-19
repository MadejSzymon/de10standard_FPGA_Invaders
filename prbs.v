`include "define.v"
module prbs(clk,prbs_val, pixel_0_line_0);
	
	input pixel_0_line_0;

	localparam integer SPAWN_COUNTER_SIZE_1 = `SPAWN_COUNTER_SIZE-1+`NBR_ENEMIES;
	input clk;
	output reg [`SPAWN_COUNTER_SIZE-1+`NBR_ENEMIES:0] prbs_val;
	
	genvar i;
	
	initial begin
		prbs_val <= {{SPAWN_COUNTER_SIZE_1{1'b0}},1'b1};
	end
	
	generate
		for(i=0;i<`SPAWN_COUNTER_SIZE-1+`NBR_ENEMIES;i=i+1) begin:prbs_for
			always@(posedge clk) begin
					if (pixel_0_line_0)
						prbs_val[i] <= prbs_val[i+1];
				end
			end
		endgenerate
	
	always@(posedge clk) begin
		if (pixel_0_line_0)
			prbs_val[`SPAWN_COUNTER_SIZE-1+`NBR_ENEMIES] <= prbs_val[0] ^ prbs_val[1];
	end
		
endmodule 
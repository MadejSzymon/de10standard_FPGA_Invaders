`include "define.v"
module fire_trigger(clk,btn,fire,rst,enb, pixel_0_line_0);
	input clk;
	input btn;
	input rst;
	input enb;
	input pixel_0_line_0;
	
	output reg fire;
	reg [`COOLDOWN_SIZE-1:0] counter;
	reg state;
	reg next;
	
	parameter WAIT = 1'b0;
	parameter COUNT = 1'b1;
	
	initial begin
		state <= 0;
		counter <= 0;
		fire <= 0;
	end
	
	always@(*) begin
		case(state)
		WAIT: begin
			if(btn && enb) 
				next = COUNT;
			else 
				next = WAIT;
		end
		COUNT: begin
			if(counter == {`COOLDOWN_SIZE{1'b1}} && enb) 
				next = WAIT;
			else 
				next = COUNT;
		end
	  endcase
	 end
	 
	always@(posedge clk) begin
		if(rst) begin
			state <= 0;
			counter <= 0;
		end
		else if(enb && pixel_0_line_0)
			state <= next;
	
		if(state == COUNT && enb && pixel_0_line_0) begin
			fire <= 0;
			counter <= counter + 1'b1;
			if(counter == 0)
				fire <= 1'b1;
		end
	end
	
endmodule 
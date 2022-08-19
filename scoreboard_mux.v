module scoreboard_mux(clk,addr_in, rden, addr_out, onehot_ones, onehot_tens, onehot_out);

	input clk;
	input [19:0] addr_in;
	input [9:0] onehot_ones;
	input [9:0] onehot_tens;

	output reg [9:0] addr_out;
	output reg [9:0] onehot_out;
	input [1:0] rden;
	
	initial begin
		addr_out <= 0;
		onehot_out <= 0;
	end
	
	always@(posedge clk) begin
		case(rden)
			2'b01:begin 
				addr_out <= addr_in[9:0];
				onehot_out <= onehot_tens;
				end
			2'b10:begin 
				addr_out <= addr_in[19:10];
				onehot_out <= onehot_ones;
				end
		endcase
	end
endmodule
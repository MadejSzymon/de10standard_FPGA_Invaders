module enemy_mux(clk,addr_in,addr_out, rden);

	input clk;
   input [95:0] addr_in;
	output reg [11:0] addr_out;
	input [7:0] rden;
	
	initial begin
		addr_out <= 0;
	end
	
	always@(posedge clk) begin
		case(rden)
			8'b00000001:addr_out <= addr_in[11:0];
			8'b00000010:addr_out <= addr_in[23:12];
			8'b00000100:addr_out <= addr_in[35:24];
			8'b00001000:addr_out <= addr_in[47:36];
			8'b00010000:addr_out <= addr_in[59:48];
			8'b00100000:addr_out <= addr_in[71:60];
			8'b01000000:addr_out <= addr_in[83:72];
			8'b10000000:addr_out <= addr_in[95:84];
		endcase
	end
endmodule
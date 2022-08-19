module BCD_to_onehot(clk,BCD,onehot);

input clk;
input [3:0] BCD;
output reg [9:0] onehot = 0;

always@(posedge clk) begin
	case(BCD) 
	4'b0000:onehot <= 10'b0000000001;
	4'b0001:onehot <= 10'b0000000010;
	4'b0010:onehot <= 10'b0000000100;
	4'b0011:onehot <= 10'b0000001000;
	4'b0100:onehot <= 10'b0000010000;
	4'b0101:onehot <= 10'b0000100000;
	4'b0110:onehot <= 10'b0001000000;
	4'b0111:onehot <= 10'b0010000000;
	4'b1000:onehot <= 10'b0100000000;
	4'b1001:onehot <= 10'b1000000000;
	default:onehot <= 10'b0000000000;
	endcase
end

	
endmodule 
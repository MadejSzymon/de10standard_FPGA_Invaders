module scoreboard(clk, addr, rden, onehot, scoreboard_data);
	input clk;
	input rden;
	input [9:0] addr;
	input [9:0] onehot;
	
	output reg [7:0] scoreboard_data = 0;
	
	wire [7:0] sprite_data [9:0];
	
	rom_0_digit rom_0_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[0])
	);
	
	rom_1_digit rom_1_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[1])
	);
	
	rom_2_digit rom_2_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[2])
	);
	
	rom_3_digit rom_3_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[3])
	);
	
	rom_4_digit rom_4_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[4])
	);
	
	rom_5_digit rom_5_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[5])
	);
	
	rom_6_digit rom_6_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[6])
	);

	rom_7_digit rom_7_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[7])
	);
	
	rom_8_digit rom_8_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[8])
	);
	
	rom_9_digit rom_9_digit(
	.address(addr),
	.clock(clk),
	.rden(rden),
	.q(sprite_data[9])
	);
	
	always@(posedge clk) begin
		case(onehot) 
		10'b0000000001:scoreboard_data <= sprite_data[0];
		10'b0000000010:scoreboard_data <= sprite_data[1];
		10'b0000000100:scoreboard_data <= sprite_data[2];
		10'b0000001000:scoreboard_data <= sprite_data[3];
		10'b0000010000:scoreboard_data <= sprite_data[4];
		10'b0000100000:scoreboard_data <= sprite_data[5];
		10'b0001000000:scoreboard_data <= sprite_data[6];
		10'b0010000000:scoreboard_data <= sprite_data[7];
		10'b0100000000:scoreboard_data <= sprite_data[8];
		10'b1000000000:scoreboard_data <= sprite_data[9];
		endcase
	end
	
	
endmodule 
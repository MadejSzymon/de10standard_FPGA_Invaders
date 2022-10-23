`include "define.v"
module top(board_clk,h_synch, v_synch, blank_n, sync_n, vga_clk, r_out, g_out, b_out, btn_sig, sw_sig);
		
	input board_clk;
	input [3:0] btn_sig;
	input [9:0] sw_sig;

	output h_synch;
	output v_synch;
	output blank_n;
	output sync_n;
	output [7:0] r_out;
	output [7:0] g_out;
	output [7:0] b_out;
	output vga_clk;
	
	wire [9:0] onehot_tens;
	wire [9:0] onehot_ones;
	wire [9:0] onehot;
	wire [3:0] ones;
	wire [3:0] tens;
	wire clk;
	wire signed [`CORDW-1:0] pixel;
	wire signed [`CORDW-1:0] line;
	wire [23:0] colors_q;
	wire [7:0] out_color;
	wire [6:0] score;
	wire [7:0] spawn_tick;
	wire fire;
	wire [2:0] state;
	wire pixel_0_line_0;
	
	wire [15:0] addr_title;
	wire [14:0] addr_pause;
	wire [11:0] addr_enemy;
	wire [95:0] addr_sprite_enemy;
	wire [9:0] addr_scoreboard;
	wire [9:0] addr_scoreboard_ones;
	wire [9:0] addr_scoreboard_tens;
	wire [15:0] addr_game_over;
	wire [11:0] addr_player;
	wire [7:0] addr_bullet;
	wire [15:0] addr_background;
	
	wire [7:0] sprite_title_data;
	wire [7:0] sprite_pause_data;
	wire [7:0] sprite_enemy_data;
	wire [7:0] sprite_player_data;
	wire [7:0] sprite_game_over_data;
	wire [7:0] sprite_bullet_data;
	wire [7:0] sprite_scoreboard_data;
	wire [7:0] sprite_background_data;
	wire [`NBR_SPRITES-1:0] rden_out_gpu;
	wire [`NBR_SPRITES*8-1:0] sprite_data_gpu;
	
	wire rden_title;
	wire rden_pause;
	wire rden_scoreboard_tens;
	wire rden_scoreboard_ones;
	wire rden_game_over;
	wire [7:0] rden_enemy;
	wire rden_player;
	wire rden_bullet;
	wire rden_background;
	wire rden_title_out;
	wire rden_pause_out;
	wire rden_game_over_out;
	wire rden_enemy_out;
	wire rden_player_out;
	wire rden_bullet_out;
	wire rden_scoreboard_out;
	wire rden_background_out;
	
	wire [$clog2(`NBR_SPRITES)-1:0] binary;
	wire [9:0] player_x;
	wire [9:0] bullet_x;
	wire [9:0] bullet_y;
	wire [79:0] enemy_y;
	wire [9:0] game_over_x;
	wire [9:0] pause_x;
	wire [9:0] title_x;
	wire rden_enemy_or;
	wire rden_scoreboard;
	
	localparam [32*(`NBR_ROM-1)-1:0] spr_x = {32'd483,32'd418,32'd353,32'd288,32'd223,32'd158,32'd93,32'd28}; 
	genvar i;	
			
	 transp_check transp_check_enemy(
	.rden(rden_enemy_or),
	.sprite_data(sprite_enemy_data),
	.rden_out(rden_enemy_out)
	);

	
	transp_check transp_check_player(
	.rden(rden_player),
	.sprite_data(sprite_player_data),
	.rden_out(rden_player_out)
	);
	
	transp_check transp_check_bullet(
	.rden(rden_bullet),
	.sprite_data(sprite_bullet_data),
	.rden_out(rden_bullet_out)
	);
	
	assign rden_title_out = rden_title;
	assign rden_pause_out = rden_pause; 	
	assign rden_scoreboard_out = rden_scoreboard;
	assign rden_game_over_out = rden_game_over;
	assign rden_background_out = rden_background;


//TITLE_SCREEN//////////////////////////////////////////////////////////////////////////////////
sprite_controller_title controller_title
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.game_over_x(title_x),
	.line(line),
	.addr(addr_title),
	.rden(rden_title)
	);
	
	title_rom title_rom(
	.address(addr_title),
	.clock (clk),
	.rden ( rden_title ),
	.q (sprite_title_data)
	);
	
//PAUSE_SCREEN//////////////////////////////////////////////////////////////////////////////////
sprite_controller_pause controller_pause
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.pause_x(pause_x),
	.line(line),
	.addr(addr_pause),
	.rden(rden_pause)
	);
	
	pause_rom pause_rom(
	.address(addr_pause),
	.clock (clk),
	.rden ( rden_pause ),
	.q (sprite_pause_data)
	);
//SCOREBOARD////////////////////////////////////////////////////////////////////////////////////
	
	sprite_controller_scoreboard #(
	.SPR_X(`SCORE_TENS_X)
	) controller_scoreboard_tens
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.line(line),
	.addr(addr_scoreboard_tens),
	.rden(rden_scoreboard_tens)
	);
	
	sprite_controller_scoreboard #(
	.SPR_X(`SCORE_ONES_X)
	) controller_scoreboard_ones
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.line(line),
	.addr(addr_scoreboard_ones),
	.rden(rden_scoreboard_ones)
	);
	
	scoreboard scoreboard
(
	.clk(clk) ,	// input  clk_sig
	.addr(addr_scoreboard) ,	// input [15:0] addr_sig
	.rden(rden_scoreboard) ,	// input  rden_sig
	.onehot(onehot) ,	// input [9:0] onehot_sig
	.scoreboard_data(sprite_scoreboard_data)
);

scoreboard_mux scoreboard_mux_inst
(
	.clk(clk) ,	// input  clk_sig
	.addr_in({addr_scoreboard_ones,addr_scoreboard_tens}),
	.rden({rden_scoreboard_ones,rden_scoreboard_tens}) ,	// input [1:0] rden_sig
	.addr_out(addr_scoreboard), 	// output [9:0] addr_out_sig
	.onehot_ones(onehot_ones),
	.onehot_tens(onehot_tens),
	.onehot_out(onehot)
);
 assign rden_scoreboard = |{rden_scoreboard_ones,rden_scoreboard_tens};
	
//GAME_OVER_SCREEN////////////////////////////////////////////////////////////////////////////////////

	sprite_controller_game_over controller_game_over
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.game_over_x(game_over_x),
	.line(line),
	.addr(addr_game_over),
	.rden(rden_game_over)
	);
	
	game_over_rom game_over_rom(
	.address(addr_game_over),
	.clock (clk),
	.rden ( rden_game_over),
	.q (sprite_game_over_data)
	);
	
//ENEMY_SHIPS//////////////////////////////////////////////////////////////////////////	
	generate
	for(i=0;i<8;i=i+1) begin:sprite_enemy

	
		sprite_controller_enemy #(
	.SPR_X(spr_x[32*(i+1)-1:32*i])
	) controller_enemy
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.enemy_y(enemy_y[10*(i+1)-1:10*i]),
	.line(line),
	.addr(addr_sprite_enemy[12*(i+1)-1:12*i]),
	.rden(rden_enemy[i])
	);
	end
	endgenerate
	
	enemy_mux enemy_mux_inst
(
	.clk(clk) ,	// input  clk_sig
	.addr_in(addr_sprite_enemy) ,
	.addr_out(addr_enemy) ,	// output  addr_out_sig
	.rden(rden_enemy) 	// input [7:0] rden_sig
);
assign rden_enemy_or = |rden_enemy; 

	enemy_rom enemy_rom(
	.address ( addr_enemy ),
	.clock (clk),
	.rden ( rden_enemy_or ),
	.q(sprite_enemy_data)
	);
	
//PLAYER_SHIP//////////////////////////////////////////////////////////////////////////////

	sprite_controller_player controller_player
	(
	.player_x(player_x),
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.line(line),
	.addr(addr_player),
	.rden(rden_player)
	);
	
	player_rom player_rom(
	.address(addr_player),
	.clock (clk),
	.rden ( rden_player ),
	.q(sprite_player_data)
	);
//BULLET////////////////////////////////////////////////////////////////	
	sprite_controller_bullet controller_bullet
	(
	.bullet_x(bullet_x),
	.bullet_y(bullet_y),
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.line(line),
	.addr(addr_bullet),
	.rden(rden_bullet)
	);
	
	bullet_rom bullet_rom(
	.address(addr_bullet),
	.clock (clk),
	.rden ( rden_bullet ),
	.q(sprite_bullet_data)
	);
	
//BACKGROUND////////////////////////////////////////////////////////////////////////////////////
	
		sprite_controller_background controller_background
	(
	.clk(clk),
	.rst_n(sw_sig[0]),
	.pixel(pixel),
	.line(line),
	.addr(addr_background),
	.rden(rden_background)
	);
	
	background_rom background_rom(
	.address(addr_background),
	.clock (clk),
	.rden ( rden_background ),
	.q(sprite_background_data)
	);
//////////////////////////////////////////////////////////////////////////////////////////////

score_encoding score_encoding_inst
(
	.clk(clk) ,	// input  clk_sig
	.score(score) ,	// input [6:0] score_sig
	.onehot_ones(onehot_ones) ,	// output [9:0] onehot_ones_sig
	.onehot_tens(onehot_tens) 	// output [9:0] onehot_tens_sig
);

game_controller game_controller_inst
(
	.clk(clk) ,	// input  clk_sig
	.rst(!btn_sig[0]) ,	// input  rst_sig
	.score(score) ,	// output [6:0] score_sig
	.player_x(player_x) ,	// output [9:0] player_x_sig
	.enemy_y(enemy_y) ,	// output [79:0] enemy_y_sig
	.game_over_x(game_over_x),
	.sw_right(!btn_sig[2]) ,	// input  sw_right_sig
	.sw_left(!btn_sig[3]) ,	// input  sw_left_sig
	.pause_sw(sw_sig[4]) ,	// input  pause_sw_sig
	.spawn_tick(spawn_tick),
	.fire(fire),
	.bullet_x(bullet_x),
	.bullet_y(bullet_y),
	.rden_background_out(rden_background_out),
	.rden_player_out(rden_player_out),
	.rden_enemy_out(rden_enemy_out),
	.rden_bullet_out(rden_bullet_out),
	.rden_enemy(rden_enemy),
	.pause_x(pause_x),
	.title_x(title_x),
	.start_btn(sw_sig[9]),
	.state(state),
	.pixel_0_line_0(pixel_0_line_0)
);

enemy_spawn_controller enemy_spawn_controller_inst
(
	.clk(clk) ,	// input  clk_sig
	.enb(sw_sig[1]) ,	// input  enb_sig
	.rst(!btn_sig[0]) ,	// input  rst_sig
	.tick(spawn_tick),	// output [7:0] tick_sig
	.pixel_0_line_0(pixel_0_line_0),
	.state(state)
);

fire_trigger fire_trigger_inst
(
	.clk(clk) ,	// input  clk_sig
	.btn(!btn_sig[1]) ,	// input  btn_sig
	.fire(fire) ,	// output  fire_sig
	.rst(!btn_sig[0]) ,	// input  rst_sig
	.enb(sw_sig[1]), 	// input  enb_sig
	.pixel_0_line_0(pixel_0_line_0)
);
	

pll pll_inst (
		.refclk   (board_clk),   //  refclk.clk
		.rst      (1'b0),      //   reset.reset
		.outclk_0 (clk), // outclk0.clk
		.locked   ()          // (terminated)
	);
	
	
	gpu gpu_inst
(
	.clk(clk) ,	// input  clk_sig
	.enb(sw_sig[1]) ,	// input  enb_sig
	.rst_n(sw_sig[0]) ,	// input  rst_n_sig
	.h_synch(h_synch) ,	// output  h_synch_sig
	.v_synch(v_synch) ,	// output  v_synch_sig
	.blank_n(blank_n) ,	// output  blank_n_sig
	.sync_n(sync_n) ,	// output  sync_n_sig
	.vga_clk(vga_clk) ,	// output  vga_clk_sig
	.pixel(pixel) ,	// output [15:0] pixel_sig
	.line(line) ,	// output [15:0] line_sig
	.pixel_0_line_0(pixel_0_line_0) ,	// output  pixel_0_line_0_sig
	.r_out(r_out) ,	// output [7:0] r_out_sig
	.g_out(g_out) ,	// output [7:0] g_out_sig
	.b_out(b_out) ,	// output [7:0] b_out_sig
	.rden_out(rden_out_gpu) ,	// input [15:0] rden_out_sig
	.sprite_data(sprite_data_gpu) 	// input [63:0] sprite_data_sig
);

assign rden_out_gpu = {1'b1,rden_background_out,rden_bullet_out,rden_player_out,rden_enemy_out,rden_game_over_out,rden_scoreboard_out,rden_pause_out,rden_title_out};
assign sprite_data_gpu = {8'b00000000,sprite_background_data,sprite_bullet_data,sprite_player_data,sprite_enemy_data,sprite_game_over_data,sprite_scoreboard_data,sprite_pause_data,sprite_title_data};

endmodule 
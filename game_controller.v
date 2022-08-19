`include "define.v"
module game_controller(clk, rst, score, player_x, 
enemy_y, game_over_x, sw_right, sw_left, pause_sw, pixel_0_line_0, spawn_tick, bullet_x, bullet_y, fire,
rden_background_out, rden_player_out, rden_enemy_out, rden_bullet_out,
 rden_enemy, pause_x, start_btn, title_x, state);

	input clk;
	input rst;
	input pause_sw;
	input sw_right;
	input sw_left;
	input [7:0] rden_enemy;
	input pixel_0_line_0;
	input [7:0] spawn_tick;
	input fire; 
	input rden_background_out;
	input rden_player_out;
	input rden_enemy_out;
	input rden_bullet_out;
	input start_btn;
	
	output reg [9:0] player_x;
	output reg [9:0] title_x;
	output reg [79:0] enemy_y;
	output reg [9:0] game_over_x;
	output reg [9:0] pause_x;
	output reg [6:0] score;
	output reg [9:0] bullet_x;
	output reg [9:0] bullet_y;
	reg title_flag;
	
	
	parameter [2:0] IDLE = 3'b000,
						 UPDATE = 3'b001,
						 GAME_OVER = 3'b010,
						 PAUSE = 3'b011,
						 TITLE = 3'b100;
	integer i,j,k;
	output reg [2:0] state;
	reg [2:0] next;
	reg crash_flag;
	reg [7:0] score_flag;

	reg bullet_edge;
	
	initial begin
		crash_flag <= 0;
		score_flag <= 0;
		bullet_edge <= 0;
		game_over_x <= `DEF_GAME_OVER_X;
		pause_x <= `DEF_PAUSE_X;
		title_x <= `DEF_TITLE_X;
		player_x <= `DEF_PLAYER_X;
		enemy_y[9:0] <= `DEF_ENEMY_Y;
		enemy_y[19:10] <= `DEF_ENEMY_Y;
		enemy_y[29:20] <= `DEF_ENEMY_Y;
		enemy_y[39:30] <= `DEF_ENEMY_Y;
		enemy_y[49:40] <= `DEF_ENEMY_Y;
		enemy_y[59:50] <= `DEF_ENEMY_Y;
		enemy_y[69:60] <= `DEF_ENEMY_Y;
		enemy_y[79:70] <= `DEF_ENEMY_Y;
		bullet_x <= 0;
		bullet_y <= `DEF_BULLET_Y;
		score <= 0;
		title_flag <= 1'b1;
		state <= IDLE;
	end
						 
	
	always@(posedge clk) begin
	if((rden_player_out == 1'b1 && rden_enemy_out == 1'b1 ) || (rden_background_out == 1'b0 && rden_enemy_out == 1'b1))
		crash_flag <= 1;	

	
	
	if(rst) begin
		state <= IDLE;
		crash_flag <= 0;
	end
	else
		state <= next;
	end
	
	always@(*) begin
	case(state)
		TITLE: begin
			if(!title_flag)
				next = IDLE;
			else
				next = TITLE;
		end
		IDLE:begin
			if (!pause_sw && pixel_0_line_0)
				next = UPDATE;
			else if(pause_sw)
				next = PAUSE;
			else if(title_flag)
				next = TITLE;
			else
				next = IDLE;
		end
		UPDATE:begin
			  if(crash_flag)
				next = GAME_OVER;
			else
				next = IDLE;
		end
		PAUSE:begin
			if(!pause_sw)
				next = IDLE;
			else
				next = PAUSE;
		end
		GAME_OVER:begin
			next = GAME_OVER;
		end
		default: begin
			next = IDLE;
		end
	endcase
	end
	
	always@(posedge clk) begin
		if(rden_bullet_out == 1'b1 && rden_background_out == 1'b0) begin
			bullet_edge <= 1'b1;
		end
		pause_x <= `DEF_PAUSE_X;
		title_x <= `DEF_TITLE_X;
		case({rden_enemy,rden_bullet_out})
		9'b000000011: score_flag[0] <= 1'b1;
		9'b000000101: score_flag[1] <= 1'b1;
		9'b000001001: score_flag[2] <= 1'b1;
		9'b000010001: score_flag[3] <= 1'b1;
		9'b000100001: score_flag[4] <= 1'b1;
		9'b001000001: score_flag[5] <= 1'b1;
		9'b010000001: score_flag[6] <= 1'b1;
		9'b100000001: score_flag[7] <= 1'b1;
	endcase
		if(rst) begin
			game_over_x <= `DEF_GAME_OVER_X;
			player_x <= `DEF_PLAYER_X;
			enemy_y[9:0] <= `DEF_ENEMY_Y;
			enemy_y[19:10] <= `DEF_ENEMY_Y;
			enemy_y[29:20] <= `DEF_ENEMY_Y;
			enemy_y[39:30] <= `DEF_ENEMY_Y;
			enemy_y[49:40] <= `DEF_ENEMY_Y;
			enemy_y[59:50] <= `DEF_ENEMY_Y;
			enemy_y[69:60] <= `DEF_ENEMY_Y;
			enemy_y[79:70] <= `DEF_ENEMY_Y;
			score <= 0;
			bullet_x <= 0;
			bullet_y <= `DEF_BULLET_Y;
		end
		else begin
			case(state) 
			TITLE: begin
				title_x <= `TITLE_X;
				if (start_btn)
					title_flag <= 1'b0;
			end
			UPDATE: begin
				title_flag <= 1'b0;
				if (!sw_right && sw_left) begin
					if (player_x >= `BACKGROUND_X + `PLAYER_SPEED && player_x <= `H_RES-`BACKGROUND_X-`PLAYER_W) begin
						player_x <= player_x - `PLAYER_SPEED;
					end
				end
				else if (sw_right && !sw_left) begin
					if (player_x >= `BACKGROUND_X && player_x <= `H_RES-`BACKGROUND_X-`PLAYER_W - `PLAYER_SPEED) begin
						player_x <= player_x + `PLAYER_SPEED;
					end
				end
				
					if (bullet_y == `DEF_BULLET_Y && fire) begin
						bullet_y <= 377;
						bullet_x <= player_x + (`PLAYER_W-`BULLET_W)/2;
					end
				
					
					if (bullet_y <= (`V_RES- `BACKGROUND_Y - `PLAYER_H - `BULLET_H -4) && bullet_y >= 0)
						bullet_y <= bullet_y - `BULLET_SPEED;
					
				
					for(i=0;i<8;i=i+1) begin
						if (enemy_y[10*(i+1)-1 -:10] == `DEF_ENEMY_Y && spawn_tick[i])
							enemy_y[10*(i+1)-1 -:10] <= `BACKGROUND_Y;
					end
				
					
					if(|score_flag) begin
						score_flag <= 0;
						bullet_x <= 0;
						bullet_y <= `DEF_BULLET_Y;
						if(score < `MAX_SCORE)
							score <= score + 1;
						else if (score == `MAX_SCORE)
							score <= 0;
					end
					
					for(j=0;j<8;j=j+1) begin
						if (enemy_y[10*(j+1)-1 -:10] >= `BACKGROUND_Y && enemy_y[10*(j+1)-1 -:10] <= 500)
							enemy_y[10*(j+1)-1 -:10] <= enemy_y[10*(j+1)-1 -:10] + `ENEMY_SPEED;
					end
					
					for(k=0;k<8;k=k+1) begin
						if (score_flag[k])
							enemy_y[10*(k+1)-1 -:10] <= `DEF_ENEMY_Y;
					end
						
						
					if (bullet_edge) begin
						bullet_x <= 0;
						bullet_y <= `DEF_BULLET_Y;
						bullet_edge <= 1'b0;
					end
					
				end
			GAME_OVER: begin
				game_over_x <= `GAME_OVER_X;
			end
			PAUSE: begin
				pause_x <= `PAUSE_X;
			end
			endcase
		end
	end
endmodule
/////////////////////////GPU//////////////////////////////////////////////
`define NBR_ROM 17
`define NBR_SPRITES 9
// screen parameters
`define  CORDW  16      // signed coordinate width (bits)
`define  H_RES  640     // horizontal resolution (pixels)
`define  V_RES  480     // vertical resolution (lines)
`define  H_FP   16      // horizontal front porch
`define  H_SYNC 96      // horizontal sync
`define  H_BP   48      // horizontal back porch
`define  V_FP   10      // vertical front porch
`define  V_SYNC  2      // vertical sync
`define  V_BP   33      // vertical back porch
`define  H_POL   0      // horizontal sync polarity (0:neg, 1:pos)
`define  V_POL   0      // vertical sync polarity (0:neg, 1:pos)

// horizontal timings
`define  H_STA   0 - `H_FP - `H_SYNC - `H_BP    // horizontal start
`define  HS_STA  `H_STA + `H_FP                 // sync start
`define  HS_END  `HS_STA + `H_SYNC              // sync end
`define  HA_STA  0                              // active start
`define  HA_END  `H_RES - 1                     // active end

// vertical timings
`define  V_STA   0 - `V_FP - `V_SYNC - `V_BP    // vertical start
`define  VS_STA  `V_STA + `V_FP                 // sync start
`define  VS_END  `VS_STA + `V_SYNC              // sync end
`define  VA_STA  0                              // active start
`define  VA_END  `V_RES - 1                     // active end

//////////////////GAME CONTROLLER/////////////////////////////////////////////

//game parameters
`define PLAYER_SPEED 3
`define ENEMY_SPEED 1
`define BULLET_SPEED 10
`define MAX_SCORE 99
`define COOLDOWN_SIZE 5
`define NBR_ENEMIES 8

//enemy spawn parameters:
`define GLOBAL_COUNTER_SIZE 11
`define SPAWN_COUNTER_SIZE 10

//coordinates:
//player_ship:
`define PLAYER_Y 393
`define DEF_PLAYER_X 288
//enemy_ship
`define DEF_ENEMY_Y 700
//game_over_screen:
`define GAME_OVER_Y 112
`define GAME_OVER_X 192
`define DEF_GAME_OVER_X 700
//pause_screen:
`define PAUSE_Y 176
`define PAUSE_X 192
`define DEF_PAUSE_X 700
//scoreboard:
`define SCORE_ONES_X 581
`define SCORE_TENS_X 548
`define SCORE_Y 19
//bullet:
`define DEF_BULLET_Y 700
//title_screen:
`define TITLE_Y 112
`define TITLE_X 192
`define DEF_TITLE_X 700
//background:
`define BACKGROUND_X 24
`define BACKGROUND_Y 19


//sprite parameters:
//player_ship
`define PLAYER_W 64
`define PLAYER_H 64
//enemy_ship
`define ENEMY_W 64
`define ENEMY_H 64
//game_over_screen:
`define GAME_OVER_W 256
`define GAME_OVER_H 256
//pause_screen:
`define PAUSE_W 256
`define PAUSE_H 128
//scoreboard_ones & scoreboard_tens
`define SCORE_W 32
`define SCORE_H 32
//bullet:
`define BULLET_W 16
`define BULLET_H 16
//title_screen:
`define TITLE_W 256
`define TITLE_H 256
//background
`define BACKGROUND_W 296
`define BACKGROUND_H 221
`define BACKGROUND_SCA 2
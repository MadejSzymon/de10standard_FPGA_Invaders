module score_encoding (clk, score, onehot_ones, onehot_tens);
	
	input clk;
	input [6:0] score;
	output [9:0] onehot_ones;
	output [9:0] onehot_tens;
	
	wire [3:0] ones;
	wire [3:0] tens;

	binary_to_BCD binary_to_BCD
	(
		.clk(clk) ,	// input  clk_sig
		.score(score) ,	// input [6:0] score_sig
		.ones(ones) ,	// output [3:0] ones_sig
		.tens(tens) 	// output [3:0] tens_sig
	);

		BCD_to_onehot BCD_to_onehot_ones
	(
		.clk(clk) ,	// input  clk_sig
		.BCD(ones) ,	// input [3:0] BCD_sig
		.onehot(onehot_ones) 	// output [9:0] onehot_sig
	);
		
		BCD_to_onehot BCD_to_onehot_tens
	(
		.clk(clk) ,	// input  clk_sig
		.BCD(tens) ,	// input [3:0] BCD_sig
		.onehot(onehot_tens) 	// output [9:0] onehot_sig
	);

endmodule
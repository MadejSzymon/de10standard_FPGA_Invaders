module binary_to_BCD(clk,score,ones,tens);

//INPUTS:
input clk;
input [6:0] score;
//clk - WIRE FROM (PLL) 
//score - BUS OF WIRES FROM  

//OUTPUTS:
output reg [3:0] ones;
output reg [3:0] tens;
//ones - REGISTER THAT LATCHES THE BCD VALUE OF ONES 
//tens - REGISTER THAT LATCHES THE BCD VALUE OF TENS

//OTHER NETS AND REGISTERS:
reg [3:0] shift_counter;
reg [14:0] shift_register;
reg [3:0] temp_ones;
reg [3:0] temp_tens;

reg [6:0] old_bit_value;
reg [6:0] bit_value;
//shift_counter - REGISTER THAT COUNTS THE NUMBER OF SHIFTS WHILE DECODING FROM BINARY TO BCD (OPERATION
//						REQUIRES 7 SHIFTS)
//shift_register - REGISTER THAT STORES BOTH THE BINARY VALUE AND THE BCD VALUE DURING DECODING 
//temp_ones - REGISTER THAT STORES THE VALUES [10:7] OF SHIFT REGISTER DURNIG DECODING
//temp_tens - REGISTER THAT STORES THE VALUES [14:11] OF SHIFT REGISTER DURNIG DECODING
//old_bit_value - REGISTER THAT STORES THE BINARY VALUE, USED TO DETECT WHEN ADC MADE NEXT MEASURMENT
//bit_value - REGISTER THAT STORES THE BINARY VALUE, USED IN DECODING 

//////////////////////////////BINARY_TO_BCD/////////////////////////////////////////////////////////////////////////////
initial 
	begin
		bit_value = {7{1'b0}};
		ones = {4{1'b0}};
		tens = {4{1'b0}};
		shift_counter = {4{1'b0}};
		shift_register = {15{1'b0}};
		temp_ones = {4{1'b0}};
		temp_tens = {4{1'b0}};
		old_bit_value = {7{1'b0}};
	end
	
always @(posedge clk) 
	begin
		bit_value = score;
		if (shift_counter == 0 & (old_bit_value != bit_value))
			begin
				shift_register = 15'd0;
				old_bit_value = bit_value;
				shift_register [6:0] = bit_value;
				temp_ones = shift_register [10:7];
				temp_tens = shift_register [14:11];
				shift_counter = shift_counter + 1'b1;
		end
		if (shift_counter < 8 & shift_counter > 0) 
			begin
				if(temp_ones >= 5)
					temp_ones = temp_ones + 2'b11;
				if(temp_tens >= 5)
					temp_tens = temp_tens + 2'b11;
				shift_register [14:7] = {temp_tens,temp_ones};
				shift_register = shift_register << 1;
				temp_ones = shift_register [10:7];
				temp_tens = shift_register [14:11];
				shift_counter = shift_counter + 1'b1;
		end
		if (shift_counter == 8) 
			begin
				shift_counter = 0;
				ones = temp_ones;
				tens = temp_tens;
		end
		if (shift_counter > 8)
			shift_counter = 0;

	end
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
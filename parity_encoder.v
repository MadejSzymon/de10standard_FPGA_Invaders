
module parity_encoder
 #( parameter                   OHW = 3 ) // encoder one-hot input width
  ( 													 // clock for pipelined priority encoder
															// registers reset for pipelined priority encoder
    input      [      OHW -1:0] oht       ,  // one-hot input  / [      OHW -1:0]
    output reg [$clog2(OHW)-1:0] bin         // first '1' index/ [`log2(OHW)-1:0]
  );
    
	 reg vld;
  // use while loop for non fixed loop length
  // synthesizable well with Intel's QuartusII
  always @(*) begin
    bin = {$clog2(OHW){1'b0}};
    vld = oht[bin]         ;
    while ((!vld) && (bin!=(OHW-1))) begin
      bin = bin + 1 ;
      vld = oht[bin];
    end
  end

endmodule
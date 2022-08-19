
`include "define.v"

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module muxu (
	data,
	sel,
	result);

	input	[`NBR_SPRITES*8-1:0]  data;
	input	[$clog2(`NBR_SPRITES)-1:0]  sel;
	output [7:0]  result;

	lpm_mux	LPM_MUX_component (
				.data (data),
				.sel (sel),
				.result (result)
				// synopsys translate_off
				,
				.aclr (),
				.clken (),
				.clock ()
				// synopsys translate_on
				);
	defparam
		LPM_MUX_component.lpm_size = `NBR_SPRITES,
		LPM_MUX_component.lpm_type = "LPM_MUX",
		LPM_MUX_component.lpm_width = 8,
		LPM_MUX_component.lpm_widths = $clog2(`NBR_SPRITES);


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "3"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "8"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "2"
// Retrieval info: USED_PORT: data0x 0 0 8 0 INPUT NODEFVAL "data0x[7..0]"
// Retrieval info: USED_PORT: data1x 0 0 8 0 INPUT NODEFVAL "data1x[7..0]"
// Retrieval info: USED_PORT: data2x 0 0 8 0 INPUT NODEFVAL "data2x[7..0]"
// Retrieval info: USED_PORT: result 0 0 8 0 OUTPUT NODEFVAL "result[7..0]"
// Retrieval info: USED_PORT: sel 0 0 2 0 INPUT NODEFVAL "sel[1..0]"
// Retrieval info: CONNECT: @data 0 0 8 0 data0x 0 0 8 0
// Retrieval info: CONNECT: @data 0 0 8 8 data1x 0 0 8 0
// Retrieval info: CONNECT: @data 0 0 8 16 data2x 0 0 8 0
// Retrieval info: CONNECT: @sel 0 0 2 0 sel 0 0 2 0
// Retrieval info: CONNECT: result 0 0 8 0 @result 0 0 8 0
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL muxu_bb.v TRUE
// Retrieval info: LIB_FILE: lpm

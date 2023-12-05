//
// Generated by Bluespec Compiler, version 2023.07-15-g10e1952c (build 10e1952c)
//
// On Sat Nov 11 11:30:12 PST 2023
//
//
// Ports:
// Name                         I/O  size props
// mav_psumout                    O    32
// RDY_mav_psumout                O     1 const
// CLK                            I     1 unused
// RST_N                          I     1 unused
// mav_psumout_weight             I    32
// mav_psumout_input_data         I    32
// mav_psumout_psum               I    32
// EN_mav_psumout                 I     1 unused
//
// Combinational paths from inputs to outputs:
//   (mav_psumout_weight,
//    mav_psumout_input_data,
//    mav_psumout_psum) -> mav_psumout
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkmac(CLK,
	     RST_N,

	     mav_psumout_weight,
	     mav_psumout_input_data,
	     mav_psumout_psum,
	     EN_mav_psumout,
	     mav_psumout,
	     RDY_mav_psumout);
  input  CLK;
  input  RST_N;

  // actionvalue method mav_psumout
  input  [31 : 0] mav_psumout_weight;
  input  [31 : 0] mav_psumout_input_data;
  input  [31 : 0] mav_psumout_psum;
  input  EN_mav_psumout;
  output [31 : 0] mav_psumout;
  output RDY_mav_psumout;

  // signals for module outputs
  wire [31 : 0] mav_psumout;
  wire RDY_mav_psumout;

  // remaining internal signals
  wire [63 : 0] mav_psumout_weight_MUL_mav_psumout_input_data___d1;

  // actionvalue method mav_psumout
  assign mav_psumout =
	     mav_psumout_weight_MUL_mav_psumout_input_data___d1[31:0] +
	     mav_psumout_psum ;
  assign RDY_mav_psumout = 1'd1 ;

  // remaining internal signals
  assign mav_psumout_weight_MUL_mav_psumout_input_data___d1 =
	     mav_psumout_weight * mav_psumout_input_data ;
endmodule  // mkmac


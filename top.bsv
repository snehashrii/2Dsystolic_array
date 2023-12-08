import Vector ::*;
import mac_array ::*;
import pooling ::*;
import im2col_gemm ::*;
import BRAM::*;
import StmtFSM::*;
import Clocks::*;
import FIFOF::*;
import FIFO::*;

function BRAMRequest#(Bit#(12), Bit#(8)) makeRequest(Bool write, Bit#(12) addr, Bit#(8) data); 
return BRAMRequest{ write: write,
responseOnWrite:True,
address: addr,
datain: data
};
endfunction

(*synthesize*)
module top(Empty);
    Ifc_conv systolic <- mkmac_array();
    Vector#(32, Reg#(Bit#(32))) ff <-replicateM( mkReg( 0 ) );
    Reg#(int) c2 <- mkReg(0);

    BRAM_Configure cfg = defaultValue;
    cfg.memorySize=3072;
    cfg.allowWriteResponseBypass = False;
    cfg.loadFormat = tagged Hex "image0.txt";
    BRAM2Port#(Bit#(12), Bit#(8)) dut1 <- mkBRAM2Server(cfg);
    Reg#(int) i  <-  mkReg(0);
    Reg#(int) j  <-  mkReg(0);
    Reg#(int) k  <-  mkReg(0);
    FIFOF#(Bit#(8))  inputdataFifo <-  mkSizedFIFOF(9);
    Reg#(Bool) load_done <- mkReg(False);
    Int#(32) input_data[3][3] = {{3,9,0},
                     {2,8,1},
                     {1,4,8}};
    Int#(32) input_data1[4][4] = {{31,7,44,33},
                     {65,35,40,46},
                     {46,29,32,30},
                     {24,49,8,64}};
    Int#(32) weight_kernel[2][2] = {{8,9},
                                    {4,4}};
Inps i1;
i1=im2col(input_data, weight_kernel);
Int#(32) bb[4];
bb=max_pooling(input_data1);
//rule pool;
  //$display("POOLING %0d %0d %0d %0d", bb[0], bb[1], bb[2], bb[3]);
  //endrule

rule datain (i<3072);
          Bit#(12) data_addr = truncate(pack(i));
          dut1.portA.request.put(makeRequest(False, data_addr, 0));
          i<=i+1;
       endrule

rule dataout  ;
         
          let data1 <- dut1.portA.response.get;
          $display("%0d dut1read[0] = %x : loading ... %0d",j, data1, load_done);
          inputdataFifo.enq(pack(data1));
          j<=j+1;
          if (j>=3071) load_done<=True;
       endrule

//rule jhjkh;
  //$display("loading... %0d", load_done);
//endrule

rule clearing_fifo ( !inputdataFifo.notFull);
   inputdataFifo.clear();
   endrule
(*fire_when_enabled*)
rule ghjgj (load_done==True);
  k<=k+1;
  //$display("SNEHA %0d %0d %0d %0d", i1.w[0], i1.x[0], i1.y[0], i1.z[0]);
  systolic.top_cnn_input(True, i1.w1,i1.w2,i1.w3,i1.w4,i1.w,i1.x,i1.y,i1.z);
  if (k>17) $finish(0);
endrule



endmodule
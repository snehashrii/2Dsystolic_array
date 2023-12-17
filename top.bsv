import Vector ::*;
import mac_array ::*;
import pooling ::*;
import im2col_gemm ::*;
import BRAM::*;
import StmtFSM::*;
import Clocks::*;
import FIFOF::*;
import FIFO::*;
import FloatingPoint::*;
import fpu_common::*;
import padding::*;
import RegFile::*;
import fpu_convert_pipelined::*;

`define a1 51
  `define a2 52
  `define a3 62
  `define a4 63


function BRAMRequest#(Bit#(12), Bit#(64)) makeRequest(Bool write, Bit#(12) addr, Bit#(64) data); 
return BRAMRequest{ write: write,
responseOnWrite:True,
address: addr,
datain: data
};
endfunction

function Array#(Bit#(64)) searchable( Vector#(2000, Reg#(Bit#(64))) final_output);
Bool flag=False;
Bit#(64) _final[1024];
int counter=0;

for (int u=0;u<2000;u=u+1) begin
   for(int z=0; z<counter;z=z+1) begin
       if (_final[z]==final_output[u]) begin
           flag=True;
           end
            end
            if(flag!=True) begin
               _final[counter]=final_output[u];
               counter=counter+1;
               end
               else
               flag=False;
           end
return _final;
endfunction

(*synthesize*)
module top(Empty);
    Ifc_conv systolic <- mkmac_array();
    Ifc_conv systolic1 <- mkmac_array();
    Vector#(32, Reg#(Bit#(32))) ff <-replicateM( mkReg( 0 ) );
    Reg#(int) c2 <- mkReg(0);
     RegFile#(Bit#(12) , FloatingPoint#(11,52)) stimulus <- mkRegFileLoad("weights.txt", 0, 1024);
     Reg#(Bit#(12)) read_index<-mkReg(0);

    Vector#(4, Reg#(FloatingPoint#(11,52))) _input <- replicateM( mkReg( 0 ) ) ;
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input2 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input3 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input4 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input5 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input6 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input7 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input8 <- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) _input9 <- replicateM( mkReg( 0 ) );

    Vector#(4, Reg#(FloatingPoint#(11,52))) w1<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w2<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w3<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w4<- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) w5<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w6<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w7<- replicateM( mkReg( 0 ) ); 
    Vector#(4, Reg#(FloatingPoint#(11,52))) w8<- replicateM( mkReg( 0 ) );
    Vector#(4, Reg#(FloatingPoint#(11,52))) w9<- replicateM( mkReg( 0 ) );
    BRAM_Configure cfg = defaultValue;
    cfg.memorySize=3073;
    cfg.allowWriteResponseBypass = False;
    cfg.loadFormat = tagged Hex "image0.txt";
    BRAM2Port#(Bit#(12), Bit#(64)) dut1 <- mkBRAM2Server(cfg);
    Reg#(int) i  <-  mkReg(0);
    Reg#(int) j  <-  mkReg(0);
    Reg#(int) k  <-  mkReg(0);
    Reg#(int) l_by_4 <- mkReg(0);
    FIFOF#(FloatingPoint#(11,52))  inputdataFifo <-  mkSizedFIFOF(36);
    FIFOF#(int) indexFifo <-mkSizedFIFOF(36);
    Reg#(Bool) load_done <- mkReg(False);
    FloatingPoint#(11,52) input_data[32][32] = {{59, 43, 50, 68, 98, 119, 139, 145, 149, 149, 131, 125, 142, 144, 137, 129, 137, 134, 124, 139, 139, 133, 136, 139, 152, 163, 168, 159, 158, 158, 152, 148},
                                 {16, 0, 18, 51, 88, 120, 128, 127, 126, 116, 106, 101, 105, 113, 109, 112, 119, 109, 105, 125, 127, 122, 131, 124, 121, 131, 132, 133, 133, 123, 119, 122}, 
                                 {25, 16, 49, 83, 110, 129, 130, 121, 113, 112, 112, 106, 105, 128, 124, 130, 127, 122, 115, 120, 130, 131, 139, 127, 126, 127, 130, 142, 130, 118, 120, 109}, 
                                 {33, 38, 87, 106, 115, 117, 114, 105, 107, 121, 125, 109, 113, 146, 133, 127, 118, 117, 127, 122, 132, 137, 136, 131, 124, 130, 132, 135, 130, 125, 121, 94}, 
                                 {50, 59, 102, 127, 124, 121, 120, 114, 107, 125, 129, 106, 108, 124, 121, 108, 98, 110, 117, 120, 134, 140, 131, 141, 135, 127, 121, 119, 103, 87, 75, 67}, 
                                 {71, 84, 110, 129, 136, 131, 129, 119, 108, 122, 123, 105, 107, 111, 108, 98, 94, 97, 83, 88, 102, 97, 88, 118, 140, 136, 120, 107, 88, 67, 35, 32},
                                  {97, 111, 123, 130, 136, 132, 122, 121, 127, 138, 124, 120, 107, 80, 68, 74, 101, 105, 65, 58, 63, 78, 136, 122, 139, 151, 129, 108, 95, 96, 89, 66}, 
                                  {115, 119, 130, 140, 133, 127, 138, 137, 131, 133, 134, 108, 72, 51, 41, 72, 181, 209, 125, 68, 64, 82, 123, 112, 135, 151, 137, 114, 105, 101, 126, 102}, 
                                  {137, 128, 132, 128, 119, 123, 128, 130, 121, 137, 131, 74, 54, 50, 44, 86, 203, 217, 162, 100, 77, 75, 74, 76, 107, 135, 135, 129, 127, 119, 125, 134},
                                  {154, 154, 156, 140, 123, 125, 126, 127, 133, 132, 90, 63, 62, 70, 79, 103, 152, 148, 141, 121, 101, 96, 86, 75, 101, 136, 136, 134, 133, 132, 128, 133}, 
                                  {154, 155, 156, 147, 133, 137, 139, 134, 141, 121, 80, 97, 90, 98, 137, 139, 148, 134, 138, 134, 140, 175, 142, 102, 108, 135, 131, 133, 138, 136, 130, 134},
                                   {145, 146, 146, 135, 127, 129, 117, 103, 130, 120, 111, 146, 136, 163, 169, 152, 161, 148, 177, 161, 195, 209, 189, 125, 108, 140, 137, 132, 136, 133, 132, 133}, 
                                   {142, 141, 140, 144, 147, 121, 84, 88, 109, 101, 138, 213, 178, 191, 211, 189, 205, 207, 213, 191, 199, 188, 161, 130, 124, 131, 130, 131, 134, 135, 136, 133}, 
                                   {158, 154, 142, 143, 132, 90, 72, 81, 84, 107, 165, 229, 183, 191, 239, 219, 228, 225, 214, 216, 210, 200, 189, 174, 161, 139, 134, 126, 131, 142, 136, 138}, 
                                   {145, 149, 147, 147, 136, 80, 89, 105, 96, 129, 192, 185, 145, 203, 223, 242, 244, 238, 241, 227, 225, 235, 219, 224, 215, 156, 128, 129, 131, 133, 128, 130}, 
                                   {148, 146, 145, 147, 133, 63, 66, 88, 113, 182, 220, 138, 162, 206, 196, 247, 255, 255, 245, 236, 230, 215, 231, 250, 241, 158, 125, 126, 124, 125, 126, 124}, 
                                   {149, 143, 144, 151, 132, 64, 84, 112, 163, 223, 206, 145, 196, 204, 220, 243, 245, 239, 234, 231, 195, 150, 208, 250, 227, 163, 145, 143, 140, 136, 121, 114}, 
                                   {147, 134, 140, 148, 135, 100, 108, 144, 210, 248, 175, 175, 220, 226, 230, 233, 224, 201, 184, 181, 190, 170, 179, 231, 223, 162, 146, 140, 139, 145, 142, 128}, 
                                   {152, 117, 114, 123, 126, 122, 93, 179, 238, 248, 170, 185, 241, 230, 187, 180, 166, 146, 149, 157, 184, 216, 212, 236, 236, 166, 136, 134, 130, 127, 137, 151}, 
                                   {145, 127, 128, 133, 132, 135, 171, 237, 252, 229, 173, 169, 220, 194, 123, 135, 127, 151, 165, 132, 151, 202, 240, 240, 222, 156, 119, 120, 112, 100, 99, 140}, 
                                   {143, 127, 129, 129, 130, 140, 219, 244, 210, 193, 166, 153, 191, 179, 128, 147, 149, 172, 147, 128, 141, 173, 202, 190, 198, 152, 100, 109, 119, 121, 108, 136}, 
                                   {143, 125, 131, 128, 123, 153, 148, 166, 188, 182, 171, 165, 195, 190, 152, 143, 152, 153, 142, 141, 135, 136, 148, 141, 141, 138, 111, 111, 121, 129, 138, 179}, 
                                   {141, 131, 139, 139, 138, 151, 128, 136, 175, 173, 189, 205, 201, 168, 151, 145, 146, 149, 153, 149, 144, 144, 145, 143, 129, 123, 124, 113, 108, 113, 148, 199}, 
                                   {143, 139, 138, 149, 160, 150, 147, 151, 169, 167, 179, 212, 203, 207, 149, 139, 144, 137, 151, 155, 152, 140, 107, 91, 84, 105, 132, 118, 96, 102, 159, 190}, 
                                   {149, 133, 136, 147, 150, 153, 157, 162, 175, 190, 166, 202, 224, 197, 192, 180, 146, 126, 141, 156, 153, 115, 77, 79, 93, 126, 133, 119, 113, 140, 187, 154}, 
                                   {172, 144, 135, 136, 135, 139, 153, 163, 166, 184, 166, 150, 184, 156, 158, 168, 149, 135, 130, 132, 128, 127, 135, 143, 139, 136, 127, 121, 135, 189, 211, 136},
                                   {202, 187, 151, 128, 122, 134, 142, 150, 153, 148, 135, 127, 153, 166, 143, 130, 128, 151, 152, 135, 139, 155, 161, 154, 154, 143, 130, 132, 171, 215, 186, 117}, 
                                   {216, 193, 168, 151, 131, 126, 138, 144, 142, 137, 120, 131, 145, 144, 137, 127, 126, 139, 153, 149, 140, 135, 147, 148, 149, 149, 137, 143, 203, 206, 124, 71}, 
                                   {220, 201, 186, 172, 156, 142, 142, 153, 150, 139, 126, 136, 148, 141, 131, 126, 127, 138, 150, 154, 149, 124, 126, 141, 145, 147, 127, 114, 186, 173, 56, 33}, 
                                   {208, 201, 198, 191, 183, 171, 159, 147, 135, 130, 139, 147, 144, 145, 137, 136, 137, 148, 152, 150, 155, 138, 120, 128, 142, 135, 90, 50, 137, 160, 56, 53}, 
                                   {180, 173, 186, 194, 198, 201, 189, 173, 156, 139, 142, 145, 141, 141, 139, 140, 143, 139, 138, 143, 146, 135, 117, 112, 122, 104, 58, 34, 131, 184, 97, 83}, 
                                   {177, 168, 179, 188, 202, 218, 218, 207, 191, 175, 166, 163, 163, 161, 153, 159, 162, 149, 140, 148, 161, 144, 112, 119, 130, 120, 92, 103, 170, 216, 151, 123}};
    Int#(32) input_data1[4][4] = {{31,7,44,33},
                     {65,35,40,46},
                     {46,29,32,30},
                     {24,49,8,64}};
    int input2[34][34];
    FloatingPoint#(11,52) weight_kernel[3][3] = {{0.0232,  0.0581,  0.0318},
                                      {-0.0473, -0.0891, -0.0865},
                                      { 0.0153,  0.0553,  0.0328}};
                                      Reg#(int) input_count <- mkReg(0);
Inps i1;
input2=zero_padding(input_data);
i1=im2col(input2, weight_kernel);
int temp[256][36];
for (int e=0;e<256;e=e+1) begin
for (int b=0;b<9;b=b+1) begin
for (int m=0;m<4;m=m+1) begin
  temp[e][b*4+m]=i1.windows[b][m+(4*e)];
  end
  end
  end
Reg#(int) _index <-mkReg(0);
rule index_fifo (_index<256);
   indexFifo.enq(temp[_index][i]);
   if (i==35) begin
      _index<=_index+1;
      i<=0;
    end
    else
      i<=i+1;
 // $display("INDEX %d %d %d", _index, i, temp[_index][i]);
  endrule
let fconv <- mk_fpu_int_to_dp();
Reg#(int) g<-mkReg(0);
//Int#(32) bb[4];
//bb=max_pooling(input_data1);
//rule pool;
  //$display("POOLING %0d %0d %0d %0d", bb[0], bb[1], bb[2], bb[3]);
  //endrule
rule datain (!indexFifo.notFull && g <36);
          Bit#(12) data_addr = truncate(pack(indexFifo.first));
        //  $display("data addr %d", data_addr);
          dut1.portA.request.put(makeRequest(False, data_addr, 0));
          if (g==35)
             g<=0;
          else
             g<=g+1;
          indexFifo.deq();
       endrule
rule weights (read_index<9);
    let _e = stimulus.sub(read_index);
   // $display("weights %0h", _e);
    case(read_index) matches
    0: w1[0]<=_e;
    1: w2[0]<=_e;
    2: w3[0]<=_e;
    3: w4[0]<=_e;
    4: w5[0]<=_e;
    5: w6[0]<=_e;
    6: w7[0]<=_e;
    7: w8[0]<=_e;
    8: w9[0]<=_e;
    endcase
    read_index<=read_index+1;
    endrule
rule dataout  ;
          let data1<- dut1.portA.response.get;
          
        //  $display("%0d dut1read[0] = %h : loading ... %0d",j, data1, load_done);
          fconv.start (data1, 1'b1, 1'b1, 3'b000);
          j<=j+1;
          if (j>=35) load_done<=True;
       endrule
Reg#(int) conv_cycle <-mkReg(0);
rule jhjg(j>0 && conv_cycle<2);
  let x =  fconv.receive();  
      let valid = x.valid;
      let out = x.value;
      let flags = x.ex;
  Bit#(64) _out = {pack(out.sign), out.exp, out.sfd}; 
  let data2=FloatingPoint{sign : unpack(_out[`a4]), exp: _out[`a3:`a2], sfd: _out[`a1:0]};  
  
  if (conv_cycle==1) begin
      inputdataFifo.enq(data2);
     // $display("%d tell me this works %0h", j, data2);
      conv_cycle<=0;
      end
  else 
    conv_cycle<=conv_cycle+1;
  endrule
  
rule clearing_fifo /*( !inputdataFifo.notFull)*/;
   //$display("data from bram %0h",inputdataFifo.first);
   if (input_count<4)
       _input[input_count]<=inputdataFifo.first;
   else if (input_count<8)
       _input2[input_count-4]<=inputdataFifo.first;
   else if (input_count<12)
       _input3[input_count-8]<=inputdataFifo.first;
   else if (input_count<16)
       _input4[input_count-12]<=inputdataFifo.first;
   else if (input_count<20)
       _input5[input_count-16]<=inputdataFifo.first;
   else if (input_count<24)
       _input6[input_count-20]<=inputdataFifo.first;
   else if (input_count<28)
       _input7[input_count-24]<=inputdataFifo.first;
   else if (input_count<32)
       _input8[input_count-28]<=inputdataFifo.first;
   else if (input_count<36)
       _input9[input_count-32]<=inputdataFifo.first;
   inputdataFifo.deq();
   // inputdataFifo.clear();
   if (input_count==35) begin
      input_count<=0;
      end
    else begin
       input_count<=input_count+1;
       end
     /*  if(input_count>33 )
           load_done<=True;
       else
           load_done<=False;*/
       systolic.load_input(load_done);
   endrule

//(*fire_when_enabled*)
rule computation_engine (load_done==True);
  k<=k+1;
  Bit#(64) _final[1024];
  //$display("SNEHA WEIGHT %0h %0h %0h %0h %0h %0h %0h %0h %0h", w1[0],w2[0],w3[0],w4[0],w5[0],w6[0],w7[0],w8[0],w9[0]);
  $display("%d SNEHA %0h %0h %0h %0h %0h %0h %0h %0h %0h",k, _input[0],_input2[0],_input3[0],_input4[0],_input5[0],_input6[0],_input7[0],_input8[0],_input9[0]);
  systolic.top_cnn_input(load_done, w1,w2,w3,w4,w5,w6,w7,w8,w9,_input,_input2,_input3,_input4,_input5,_input6,_input7,_input8,_input9);
  if (k>1000) $finish(0);
endrule
        

endmodule
package mac_row;
import mac::*;
import Vector :: * ;
import FIFO ::*;
import FloatingPoint::*;
import fpu_common::*;

interface Ifc_mac_row;
method Action take_input(Vector#(4, Reg#(FloatingPoint#(11,52))) weight1, Vector#(4, Reg#(FloatingPoint#(11,52))) psum_in1);
method Bit#(64) give(int index);
method Action load_input(  Vector#(4, Reg#(FloatingPoint#(11,52))) input1, Bool load);
method Bool valid_signal();
endinterface


module mkmac_row(Ifc_mac_row);
  Ifc_mac mac1 <- mkmac;
Ifc_mac mac2 <- mkmac;
Ifc_mac mac3 <- mkmac;
Ifc_mac mac4 <- mkmac;

Reg#(FloatingPoint#(11,52)) w11 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) w12 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) w13 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) w14 <- mkReg(0);

Reg#(FloatingPoint#(11,52)) a11 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) a12 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) a13 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) a14 <- mkReg(0);

Reg#(FloatingPoint#(11,52)) psum_in11 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) psum_in12 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) psum_in13 <- mkReg(0);
Reg#(FloatingPoint#(11,52)) psum_in14 <- mkReg(0);

Vector#(4, Reg#(Bit#(64))) psum_out <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(FloatingPoint#(11,52))) weight  <- replicateM( mkReg( 0 ) );// Initialize an 8-element array with specific values


Vector#(4, Reg#(FloatingPoint#(11,52))) _input<- replicateM( mkReg( 0 ) );
Reg#(UInt#(8))  n      <- mkReg(0);
FIFO#(FloatingPoint#(11,52))  inputFifo <-  mkSizedFIFO(32);
Reg#(Bit#(1)) rg_inputs_rx <- mkReg(0);
Reg#(Bit#(1)) rg_inputs_tx <- mkReg(0);
Reg#(Bool) input_load <- mkReg(False);
Reg#(int) rg_cycle <- mkReg(0);
Reg#(Bool) _ready <- mkReg(False);
Reg#(int) rg_cycle_psum <- mkReg(0);
FIFO#(Bit#(64)) output_fifo <- mkSizedFIFO(1);

    
   
   rule loop (n < 4 && input_load==True);
    $display("fifo %0h",_input[n]);
    inputFifo.enq(_input[n]);
    if (n==3)
     n<=0;
    else
    n<=n+1;
  endrule

   rule weight_stationary;
     w11<=weight[0];
     w12<=weight[1];
     w13<=weight[2];
     w14<=weight[3];
    // if (w11>0)
      // rg_inputs_tx<=1;
    $display("... weight %0h %0h %0h %0h %d", w11, w12, w13, w14, rg_inputs_tx);

    endrule

   rule input_flow (rg_inputs_rx==1);
     rg_inputs_tx<=1;
     a11 <= inputFifo.first;
     a12<=a11;
     a13<=a12;
     a14<=a13;
     $display(".... input %0h %0h %0h %0h", a11, a12, a13, a14);
     inputFifo.deq;
    endrule



   rule psum_display  ( rg_inputs_rx==1);
    let p <-mac1.mav_psumout(w11,a11,psum_in11);
    let q <-mac2.mav_psumout(w12,a12,psum_in12);
    let r <-mac3.mav_psumout(w13,a13,psum_in13);
    let s <-mac4.mav_psumout(w14,a14,psum_in14);
    $display(" psum out %0h %0h %0h %0h", p, w11,a11,psum_in11);
    psum_out[0]<= pack(p);
    psum_out[1]<= pack(q);
    psum_out[2]<= pack(r);
    psum_out[3] <= pack(s);
    //output_fifo.enq(p);
   endrule
   rule hihj (rg_inputs_tx==1);
     
     if (rg_cycle>12) begin
        _ready<=True;
       // $display("psum is it ? %d %d", rg_cycle, _ready);
        end
     else
       rg_cycle<=rg_cycle+1;
     
   //  output_fifo.deq();
     endrule
     
   method Action take_input(Vector#(4, Reg#(FloatingPoint#(11,52))) weight1, Vector#(4, Reg#(FloatingPoint#(11,52))) psum_in1);
      rg_inputs_rx<=1;
      //rg_inputs_tx<=0;
      for( int i=0;i<4;i=i+1) begin
       weight[i]<=weight1[i];
       
       end

       
      psum_in11 <= psum_in1[0];
      psum_in12 <= psum_in1[1];
      psum_in13 <= psum_in1[2];
      psum_in14 <= psum_in1[3];
    endmethod
   method Action load_input(Vector#(4, Reg#(FloatingPoint#(11,52))) input1, Bool load);
   input_load<=load;
   for( int i=0;i<4;i=i+1) begin
           
       _input[i]<=input1[i];
       end
    endmethod
   method  Bit#(64) give(int index) ;
      return psum_out[index];
   endmethod

   method Bool valid_signal();
     return _ready;
     endmethod
endmodule: mkmac_row
endpackage:mac_row

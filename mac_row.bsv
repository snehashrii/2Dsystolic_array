package mac_row;
import mac::*;
import Vector :: * ;
import FIFO ::*;

interface Ifc_mac_row;
method Action take_input(Vector#(4, Reg#(Bit#(32))) weight1, Vector#(4, Reg#(Bit#(32))) psum_in1);
method Bit#(32) give(int index);
method Action load_input(  Vector#(4, Reg#(Bit#(32))) input1);
endinterface


module mkmac_row(Ifc_mac_row);
  Ifc_mac mac1 <- mkmac;
Ifc_mac mac2 <- mkmac;
Ifc_mac mac3 <- mkmac;
Ifc_mac mac4 <- mkmac;
Reg#(int) cycle <- mkReg(0);

Reg#(Bit#(32)) w11 <- mkReg(0);
Reg#(Bit#(32)) w12 <- mkReg(0);
Reg#(Bit#(32)) w13 <- mkReg(0);
Reg#(Bit#(32)) w14 <- mkReg(0);

Reg#(Bit#(32)) a11 <- mkReg(0);
Reg#(Bit#(32)) a12 <- mkReg(0);
Reg#(Bit#(32)) a13 <- mkReg(0);
Reg#(Bit#(32)) a14 <- mkReg(0);

Reg#(Bit#(32)) psum_in11 <- mkReg(0);
Reg#(Bit#(32)) psum_in12 <- mkReg(0);
Reg#(Bit#(32)) psum_in13 <- mkReg(0);
Reg#(Bit#(32)) psum_in14 <- mkReg(0);

Vector#(4, Reg#(Bit#(32))) psum_out <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(Bit#(32))) weight  <- replicateM( mkReg( 0 ) );// Initialize an 8-element array with specific values


Vector#(4, Reg#(Bit#(32))) _input<- replicateM( mkReg( 0 ) );
Reg#(UInt#(8))  n      <- mkReg(0);
FIFO#(Bit#(32))  inputFifo <-  mkSizedFIFO(32);
Reg#(Bit#(1)) rg_inputs_rx <- mkReg(0);
  rule count_cycles;
      cycle <= cycle + 1;
      if (cycle > 17) $finish(0);
   endrule
   
   rule loop (n < 4  && cycle>1);
    //$display("%0d fifo",_input[n]);
    inputFifo.enq(_input[n]);
    n<=n+1;
  endrule

   rule weight_stationary;
     w11<=pack(weight[0]);
     w12<=pack(weight[1]);
     w13<=pack(weight[2]);
     w14<=pack(weight[3]);

    // $display("%0d ... weight %0d %0d %0d %0d",cycle, w11, w12, w13, w14);

    endrule

   rule input_flow (rg_inputs_rx==1);
     
     a11 <= inputFifo.first;
     a12<=a11;
     a13<=a12;
     a14<=a13;
     //$display("%0d .... input %0d %0d %0d %0d",cycle, a11, a12, a13, a14);
     inputFifo.deq;
    endrule



   rule psum_display ;
    let p <-mac1.mav_psumout(pack(w11),pack(a11),pack(psum_in11));
    let q <-mac2.mav_psumout(pack(w12),pack(a12),pack(psum_in12));
    let r <-mac3.mav_psumout(pack(w13),pack(a13),pack(psum_in13));
    let s <-mac4.mav_psumout(pack(w14),pack(a14),pack(psum_in14));
//   $display("%0d psum out %0d %0d %0d %0d",cycle, p, q, r, s);
    psum_out[0]<= pack(p);
    psum_out[1]<= pack(q);
    psum_out[2]<= pack(r);
    psum_out[3] <= pack(s);
   endrule

   method Action take_input(Vector#(4, Reg#(Bit#(32))) weight1, Vector#(4, Reg#(Bit#(32))) psum_in1);
      rg_inputs_rx<=1;
      for( int i=0;i<4;i=i+1) begin
       weight[i]<=weight1[i];
       
       end

       
      psum_in11 <= psum_in1[0];
      psum_in12 <= psum_in1[1];
      psum_in13 <= psum_in1[2];
      psum_in14 <= psum_in1[3];
    endmethod
   method Action load_input(Vector#(4, Reg#(Bit#(32))) input1);
   for( int i=0;i<4;i=i+1) begin
           
       _input[i]<=input1[i];
       end
    endmethod
   method  Bit#(32) give(int index) ;
      return psum_out[index];
   endmethod
endmodule: mkmac_row
endpackage:mac_row

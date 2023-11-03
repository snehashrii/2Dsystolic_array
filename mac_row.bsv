package mac_row;
import mac::*;
import Vector :: * ;

interface Ifc_mac_row;
method Action take_input(Vector#(3, Reg#(Bit#(32))) weight1,  Vector#(32, Reg#(Bit#(32))) input1, Vector#(3, Reg#(Bit#(32))) psum_in1);
method Bit#(32) give(int index);
endinterface


module mkmac_row(Ifc_mac_row);
  Ifc_mac mac1 <- mkmac;
Ifc_mac mac2 <- mkmac;
Ifc_mac mac3 <- mkmac;
Reg#(int) cycle <- mkReg(0);

Reg#(Bit#(32)) w11 <- mkReg(0);
Reg#(Bit#(32)) w12 <- mkReg(0);
Reg#(Bit#(32)) w13 <- mkReg(0);

Reg#(Bit#(32)) a11 <- mkReg(0);
Reg#(Bit#(32)) a12 <- mkReg(0);
Reg#(Bit#(32)) a13 <- mkReg(0);

Reg#(Bit#(32)) psum_in11 <- mkReg(0);
Reg#(Bit#(32)) psum_in12 <- mkReg(0);
Reg#(Bit#(32)) psum_in13 <- mkReg(0);


Vector#(3, Reg#(Bit#(32))) psum_out <- replicateM( mkReg( 0 ) );

Vector#(3, Reg#(Bit#(32))) weight  <- replicateM( mkReg( 0 ) );// Initialize an 8-element array with specific values


Vector#(32, Reg#(Bit#(32))) _input<- replicateM( mkReg( 0 ) );


  rule count_cycles;
      cycle <= cycle + 1;
      if (cycle > 20) $finish(0);
   endrule

   rule weight_stationary;
     w11<=pack(weight[0]);
     w12<=pack(weight[1]);
     w13<=pack(weight[2]);

  //   $display("%0d ... weight %0d %0d %0d",cycle, w11, w12, w13);

    endrule

   rule input_flow (cycle>0);
     a11 <= _input[cycle-1];
     a12<=a11;
     a13<=a12;
   //  $display("%0d .... input %0d %0d %0d",cycle, a11, a12, a13);
    endrule



   rule psum_display ;
    let p <-mac1.mav_psumout(pack(w11),pack(a11),pack(psum_in11));
    let q <-mac2.mav_psumout(pack(w12),pack(a12),pack(psum_in12));
    let r <-mac3.mav_psumout(pack(w13),pack(a13),pack(psum_in13));
  //  $display("%0d psum out %0d %0d %0d",cycle, p, q, r);
    psum_out[0]<= pack(p);
    psum_out[1]<= pack(q);
    psum_out[2]<= pack(r);

   endrule

   method Action take_input(Vector#(3, Reg#(Bit#(32))) weight1, Vector#(32, Reg#(Bit#(32))) input1, Vector#(3, Reg#(Bit#(32))) psum_in1);

      for( int i=0;i<3;i=i+1) begin
       weight[i]<=weight1[i];
       end

       for( int i=0;i<32;i=i+1) begin
       _input[i]<=input1[i];
       end
      psum_in11 <= psum_in1[0];
      psum_in12 <= psum_in1[1];
      psum_in13 <= psum_in1[2];
    endmethod

   method  Bit#(32) give(int index) ;
      return psum_out[index];
   endmethod
endmodule: mkmac_row
endpackage:mac_row

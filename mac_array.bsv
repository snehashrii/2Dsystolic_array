package mac_array;
import mac_row::*;
import Vector :: * ;
import fpu_common::*;
`define a1 51
  `define a2 52
  `define a3 62
  `define a4 63
import FIFO::*;
import FloatingPoint::*;
import FIFOF::*;
interface Ifc_conv;
method Action top_cnn_input(Reg#(int) _new_input, Bool load, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight1, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight2, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight3, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight4, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight5,  Vector#(4, Reg#(FloatingPoint#(11,52))) _weight6, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight7, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight8, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight9, Vector#(4, Reg#(FloatingPoint#(11, 52))) in1, Vector#(4, Reg#(FloatingPoint#(11, 52))) in2, Vector#(4, Reg#(FloatingPoint#(11, 52))) in3, Vector#(4, Reg#(FloatingPoint#(11, 52))) in4, Vector#(4, Reg#(FloatingPoint#(11, 52))) in5, Vector#(4, Reg#(FloatingPoint#(11, 52))) in6, Vector#(4, Reg#(FloatingPoint#(11, 52))) in7, Vector#(4, Reg#(FloatingPoint#(11, 52))) in8, Vector#(4, Reg#(FloatingPoint#(11, 52))) in9);
method Action load_input(Bool load);
method Bool output_status();
endinterface

module mkmac_array(Ifc_conv);
     Ifc_mac_row mac_r1 <- mkmac_row();
     Ifc_mac_row mac_r2 <- mkmac_row();
     Ifc_mac_row mac_r3 <- mkmac_row();
     Ifc_mac_row mac_r4 <- mkmac_row();
     Ifc_mac_row mac_r5 <- mkmac_row();
     Ifc_mac_row mac_r6 <- mkmac_row();
     Ifc_mac_row mac_r7 <- mkmac_row();
     Ifc_mac_row mac_r8 <- mkmac_row();
     Ifc_mac_row mac_r9 <- mkmac_row();

Vector#(4, Reg#(FloatingPoint#(11,52))) weight  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight2  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight3  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight4  <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(FloatingPoint#(11,52))) weight5  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight6  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight7  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight8  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) weight9  <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(FloatingPoint#(11,52))) _input <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input2 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input3 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input4 <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(FloatingPoint#(11,52))) _input5 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input6 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input7 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input8 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) _input9 <- replicateM( mkReg( 0 ) );

FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input2 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input3 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input4 <- mkSizedFIFO(500);

FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input5 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input6 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input7 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input8 <- mkSizedFIFO(500);
FIFO#(Vector#(4, FloatingPoint#(11, 52))) fifo_input9 <- mkSizedFIFO(500);

Vector#(4, Reg#(FloatingPoint#(11,52))) psum_in <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out1 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out2 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out3 <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(Bit#(64))) psum_out4 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out5 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out6 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out7 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(64))) psum_out8 <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum1  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum2  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum3  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum4  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum5  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum6  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(FloatingPoint#(11,52))) conv_psum7  <- replicateM( mkReg( 0 ) );

          Reg#(int) new_input <-mkReg(0);
          Reg#(int) next_stage<-mkReg(0);
          Reg#(int) previous_new_input<-mkReg(0);
Reg#(Bool) input_load <- mkReg(False);
Reg#(Bool) fifo_clear <- mkReg(False);
Reg#(Bit#(1)) rg_psum_received <- mkReg(0); 
FIFOF#(Bit#(64)) psum_fifo <- mkSizedFIFOF(4);
Vector#(2000, Reg#(Bit#(64))) final_output<-replicateM(mkReg(0)) ;
Reg#(Bool) multi_fifo_loaded<-mkReg(False);

     rule array_weight;
     mac_r1.take_input(weight,psum_in);
     endrule
     
     rule row1_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
       //$display("loading 1 %d %d %0h", next_stage, previous_new_input, fifo_input.first[0]);
        mac_r1.load_input(fifo_input.first, input_load,(next_stage==1));
        fifo_input.deq();
     endrule

     rule getoutput;
     
     psum_out[0] <= mac_r1.give(0);
     psum_out[1] <= mac_r1.give(1);
     psum_out[2] <= mac_r1.give(2);
     psum_out[3] <= mac_r1.give(3);
     conv_psum[0] <= FloatingPoint{sign : unpack(mac_r1.give(0)[`a4]), exp: mac_r1.give(0)[`a3:`a2], sfd: mac_r1.give(0)[`a1:0]};
     conv_psum[1] <= FloatingPoint{sign : unpack(mac_r1.give(1)[`a4]), exp: mac_r1.give(1)[`a3:`a2], sfd: mac_r1.give(1)[`a1:0]};
     conv_psum[2] <= FloatingPoint{sign : unpack(mac_r1.give(2)[`a4]), exp: mac_r1.give(2)[`a3:`a2], sfd: mac_r1.give(2)[`a1:0]};
     conv_psum[3] <= FloatingPoint{sign : unpack(mac_r1.give(3)[`a4]), exp: mac_r1.give(3)[`a3:`a2], sfd: mac_r1.give(3)[`a1:0]};
     //$display("tb output %0h %d", mac_r1.give(0), mac_r1.valid_signal());
     endrule
     (* fire_when_enabled *)
     rule array_weight_round2 (mac_r1.valid_signal());
      mac_r2.take_input(weight2,conv_psum);
     endrule

     rule row2_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
      //  $display("loading 2 %d", input_load);
        mac_r2.load_input(fifo_input2.first, input_load,(next_stage==1));
        fifo_input2.deq();
     endrule

      rule getoutput2;

     psum_out1[0] <= mac_r2.give(0);
     psum_out1[1] <= mac_r2.give(1);
     psum_out1[2] <= mac_r2.give(2);
     psum_out1[3] <= mac_r2.give(3);
     conv_psum1[0] <= FloatingPoint{sign : unpack(mac_r2.give(0)[`a4]), exp: mac_r2.give(0)[`a3:`a2], sfd: mac_r2.give(0)[`a1:0]};
     conv_psum1[1] <= FloatingPoint{sign : unpack(mac_r2.give(1)[`a4]), exp: mac_r2.give(0)[`a3:`a2], sfd: mac_r2.give(1)[`a1:0]};
     conv_psum1[2] <= FloatingPoint{sign : unpack(mac_r2.give(2)[`a4]), exp: mac_r2.give(0)[`a3:`a2], sfd: mac_r2.give(2)[`a1:0]};
     conv_psum1[3] <= FloatingPoint{sign : unpack(mac_r2.give(3)[`a4]), exp: mac_r2.give(0)[`a3:`a2], sfd: mac_r2.give(3)[`a1:0]};
     //$display("tb2 output %0d   %0d    %0d", psum_out1[0], psum_out1[1], psum_out1[2]);
     endrule

    (*fire_when_enabled*)
     rule row3_weight (mac_r2.valid_signal());
     mac_r3.take_input(weight3,conv_psum1);
     endrule
     
     rule row3_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
       // $display("rROW 3 FIFO");
        mac_r3.load_input(fifo_input3.first, input_load,(next_stage==1));
        fifo_input3.deq();
     endrule

     rule get_output3;
     psum_out2[0] <= mac_r3.give(0);
     psum_out2[1] <= mac_r3.give(1);
     psum_out2[2] <= mac_r3.give(2);
     psum_out2[3] <= mac_r3.give(3);
     
     conv_psum2[0] <= FloatingPoint{sign : unpack(mac_r3.give(0)[`a4]), exp: mac_r3.give(0)[`a3:`a2], sfd: mac_r3.give(0)[`a1:0]};
     conv_psum2[1] <= FloatingPoint{sign : unpack(mac_r3.give(1)[`a4]), exp: mac_r3.give(1)[`a3:`a2], sfd: mac_r3.give(1)[`a1:0]};
     conv_psum2[2] <= FloatingPoint{sign : unpack(mac_r3.give(2)[`a4]), exp: mac_r3.give(2)[`a3:`a2], sfd: mac_r3.give(2)[`a1:0]};
     conv_psum2[3] <= FloatingPoint{sign : unpack(mac_r3.give(3)[`a4]), exp: mac_r3.give(3)[`a3:`a2], sfd: mac_r3.give(3)[`a1:0]};
    // $display("TB3 output %0d   %0d    %0d", psum_out2[0], psum_out2[1], psum_out2[2]);
     endrule

     (*fire_when_enabled*)
     rule row4_weight (mac_r3.valid_signal());
     mac_r4.take_input(weight4,conv_psum2);
     endrule
     
     rule row4_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
       // $display("rROW 4 FIFO");

      // $display("loading 1 %d %d %0h", next_stage, multi_fifo_loaded, fifo_input4.first[0]);
        mac_r4.load_input(fifo_input4.first, input_load,(next_stage==1));
        fifo_input4.deq();
     endrule

     rule get_output4;
     psum_out3[0] <= mac_r4.give(0);
     psum_out3[1] <= mac_r4.give(1);
     psum_out3[2] <= mac_r4.give(2);
     psum_out3[3] <= mac_r4.give(3);

     conv_psum3[0] <= FloatingPoint{sign : unpack(mac_r4.give(0)[`a4]), exp: mac_r4.give(0)[`a3:`a2], sfd: mac_r4.give(0)[`a1:0]};
     conv_psum3[1] <= FloatingPoint{sign : unpack(mac_r4.give(1)[`a4]), exp: mac_r4.give(1)[`a3:`a2], sfd: mac_r4.give(1)[`a1:0]};
     conv_psum3[2] <= FloatingPoint{sign : unpack(mac_r4.give(2)[`a4]), exp: mac_r4.give(2)[`a3:`a2], sfd: mac_r4.give(2)[`a1:0]};
     conv_psum3[3] <= FloatingPoint{sign : unpack(mac_r4.give(3)[`a4]), exp: mac_r4.give(3)[`a3:`a2], sfd: mac_r4.give(3)[`a1:0]};
    // $display("TB4 output %0d   %0d    %0d", mac_r4.give(0), psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     rule row5_weight (mac_r4.valid_signal());
     mac_r5.take_input(weight5,conv_psum3);
     endrule
     
     rule row5_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
      //  $display("loading 1 %d %d %0h", next_stage, multi_fifo_loaded, fifo_input5.first[0]);
        mac_r5.load_input(fifo_input5.first, input_load,(next_stage==1));
        fifo_input5.deq();
     endrule

     rule get_output5;
     psum_out4[0] <= mac_r5.give(0);
     psum_out4[1] <= mac_r5.give(1);
     psum_out4[2] <= mac_r5.give(2);
     psum_out4[3] <= mac_r5.give(3);


     conv_psum4[0] <= FloatingPoint{sign : unpack(mac_r5.give(0)[`a4]), exp: mac_r5.give(0)[`a3:`a2], sfd: mac_r5.give(0)[`a1:0]};
     conv_psum4[1] <= FloatingPoint{sign : unpack(mac_r5.give(1)[`a4]), exp: mac_r5.give(1)[`a3:`a2], sfd: mac_r5.give(1)[`a1:0]};
     conv_psum4[2] <= FloatingPoint{sign : unpack(mac_r5.give(2)[`a4]), exp: mac_r5.give(2)[`a3:`a2], sfd: mac_r5.give(2)[`a1:0]};
     conv_psum4[3] <= FloatingPoint{sign : unpack(mac_r5.give(3)[`a4]), exp: mac_r5.give(3)[`a3:`a2], sfd: mac_r5.give(3)[`a1:0]};
    // $display("TB5 output %0d   %0d    %0d", psum_out3[0], psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     rule row6_weight (mac_r5.valid_signal());
     mac_r6.take_input(weight6,conv_psum4);
     endrule
     
     rule row6_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
        mac_r6.load_input(fifo_input6.first, input_load,(next_stage==1));
        fifo_input6.deq();
     endrule

     rule get_output6;
     psum_out5[0] <= mac_r6.give(0);
     psum_out5[1] <= mac_r6.give(1);
     psum_out5[2] <= mac_r6.give(2);
     psum_out5[3] <= mac_r6.give(3);


     conv_psum5[0] <= FloatingPoint{sign : unpack(mac_r6.give(0)[`a4]), exp: mac_r6.give(0)[`a3:`a2], sfd: mac_r6.give(0)[`a1:0]};
     conv_psum5[1] <= FloatingPoint{sign : unpack(mac_r6.give(1)[`a4]), exp: mac_r6.give(1)[`a3:`a2], sfd: mac_r6.give(1)[`a1:0]};
     conv_psum5[2] <= FloatingPoint{sign : unpack(mac_r6.give(2)[`a4]), exp: mac_r6.give(2)[`a3:`a2], sfd: mac_r6.give(2)[`a1:0]};
     conv_psum5[3] <= FloatingPoint{sign : unpack(mac_r6.give(3)[`a4]), exp: mac_r6.give(3)[`a3:`a2], sfd: mac_r6.give(3)[`a1:0]};
     //$display("TB6 output %0d   %0d    %0d", psum_out3[0], psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     rule row7_weight (mac_r6.valid_signal());
     mac_r7.take_input(weight7,conv_psum5);
     endrule
     
     rule row7_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
        mac_r7.load_input(fifo_input7.first, input_load,(next_stage==1));
        fifo_input7.deq();
     endrule

     rule get_output7;
     psum_out6[0] <= mac_r7.give(0);
     psum_out6[1] <= mac_r7.give(1);
     psum_out6[2] <= mac_r7.give(2);
     psum_out6[3] <= mac_r7.give(3);


     conv_psum6[0] <= FloatingPoint{sign : unpack(mac_r7.give(0)[`a4]), exp: mac_r7.give(0)[`a3:`a2], sfd: mac_r7.give(0)[`a1:0]};
     conv_psum6[1] <= FloatingPoint{sign : unpack(mac_r7.give(1)[`a4]), exp: mac_r7.give(1)[`a3:`a2], sfd: mac_r7.give(1)[`a1:0]};
     conv_psum6[2] <= FloatingPoint{sign : unpack(mac_r7.give(2)[`a4]), exp: mac_r7.give(2)[`a3:`a2], sfd: mac_r7.give(2)[`a1:0]};
     conv_psum6[3] <= FloatingPoint{sign : unpack(mac_r7.give(3)[`a4]), exp: mac_r7.give(3)[`a3:`a2], sfd: mac_r7.give(3)[`a1:0]};
     //$display("TB4 output %0d   %0d    %0d", psum_out3[0], psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     rule row8_weight (mac_r7.valid_signal());
     mac_r8.take_input(weight8,conv_psum6);
     endrule
     
     rule row8_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
        mac_r8.load_input(fifo_input8.first, input_load,(next_stage==1));
        fifo_input8.deq();
     endrule

     rule get_output8;
     psum_out7[0] <= mac_r8.give(0);
     psum_out7[1] <= mac_r8.give(1);
     psum_out7[2] <= mac_r8.give(2);
     psum_out7[3] <= mac_r8.give(3);


     conv_psum7[0] <= FloatingPoint{sign : unpack(mac_r8.give(0)[`a4]), exp: mac_r8.give(0)[`a3:`a2], sfd: mac_r8.give(0)[`a1:0]};
     conv_psum7[1] <= FloatingPoint{sign : unpack(mac_r8.give(0)[`a4]), exp: mac_r8.give(0)[`a3:`a2], sfd: mac_r8.give(0)[`a1:0]};
     conv_psum7[2] <= FloatingPoint{sign : unpack(mac_r8.give(2)[`a4]), exp: mac_r8.give(2)[`a3:`a2], sfd: mac_r8.give(2)[`a1:0]};
     conv_psum7[3] <= FloatingPoint{sign : unpack(mac_r8.give(3)[`a4]), exp: mac_r8.give(3)[`a3:`a2], sfd: mac_r8.give(3)[`a1:0]};
    // $display("TB4 output %0d   %0d    %0d", psum_out3[0], psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     rule row9_weight (mac_r8.valid_signal());
     mac_r9.take_input(weight9,conv_psum7);
     endrule
     
     rule row9_input ((next_stage==1||previous_new_input==1)&&(multi_fifo_loaded==True));
        mac_r9.load_input(fifo_input9.first, input_load,(next_stage==1));
        fifo_input9.deq();
     endrule
     Reg#(int) gg <-mkReg(0);
     
     Vector#(1024, Reg#(Bit#(64))) uniq<-replicateM(mkReg(0));

     rule get_output9   ;
     psum_out8[0] <= mac_r9.give(0);
     psum_out8[1] <= mac_r9.give(1);
     psum_out8[2] <= mac_r9.give(2);
     psum_out8[3] <= mac_r9.give(3);
     if (psum_out8[0]!=0) begin
               psum_fifo.enq(psum_out8[0]);
               $display(" TESTING %0h ", psum_out8[0]);
               end
       endrule

          rule aa;
            Vector::Vector#(4, FloatingPoint#(11, 52)) i1, i2,i3,i4,i5,i6,i7,i8,i9;
            for (int r=0;r<4;r=r+1) begin
             i1[r]=_input[r];
             i2[r]=_input2[r];
             i3[r]=_input3[r];
             i4[r]=_input4[r];
             i5[r]=_input5[r];
             i6[r]=_input6[r];
             i7[r]=_input7[r];
             i8[r]=_input8[r];
             i9[r]=_input9[r];
             end
            if (new_input>previous_new_input || previous_new_input==1) begin
               fifo_input.enq(i1);
               fifo_input2.enq(i2);
               fifo_input3.enq(i3);
               fifo_input4.enq(i4);
               fifo_input5.enq(i5);
               fifo_input6.enq(i6);
               fifo_input7.enq(i7);
               fifo_input8.enq(i8);
               fifo_input9.enq(i9);
               previous_new_input<=new_input;
               multi_fifo_loaded<=True;
              // $display(" new inputs %0h %0h", i4[0], i5[0]);
               end
               if(!psum_fifo.notFull) begin
                  next_stage<=1;
                  end
                  else
                  next_stage<=0;
              
                  $display("gggg %0d %d %0d", next_stage, !psum_fifo.notFull, previous_new_input);
               
               endrule
      Reg#(int) k<-mkReg(0);
      
     (*descending_urgency="get_output9, aa, df"*)
      rule df (!psum_fifo.notFull ) ;
                psum_fifo.clear();
               endrule
     method Action top_cnn_input(Reg#(int) _new_input, Bool load, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight1, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight2, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight3, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight4, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight5,  Vector#(4, Reg#(FloatingPoint#(11,52))) _weight6, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight7, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight8, Vector#(4, Reg#(FloatingPoint#(11,52))) _weight9, Vector#(4, Reg#(FloatingPoint#(11, 52))) in1, Vector#(4, Reg#(FloatingPoint#(11, 52))) in2, Vector#(4, Reg#(FloatingPoint#(11, 52))) in3, Vector#(4, Reg#(FloatingPoint#(11, 52))) in4, Vector#(4, Reg#(FloatingPoint#(11, 52))) in5, Vector#(4, Reg#(FloatingPoint#(11, 52))) in6, Vector#(4, Reg#(FloatingPoint#(11, 52))) in7, Vector#(4, Reg#(FloatingPoint#(11, 52))) in8, Vector#(4, Reg#(FloatingPoint#(11, 52))) in9);
      input_load<= load;
      new_input<=_new_input;
        for (int m=0;m<4;m=m+1) begin
         weight[m]<=_weight1[m];
         weight2[m]<=_weight2[m];
         weight3[m]<=_weight3[m];
         weight4[m]<=_weight4[m];
         weight5[m]<=_weight5[m];
         weight6[m]<=_weight6[m];
         weight7[m]<=_weight7[m];
         weight8[m]<=_weight8[m];
         weight9[m]<=_weight9[m];
         _input[m]<=in1[m];
         _input2[m]<=in2[m];
         _input3[m]<=in3[m];
         _input4[m]<=in4[m];
         _input5[m]<=in5[m];
         _input6[m]<=in6[m];
         _input7[m]<=in7[m];
         _input8[m]<=in8[m];
         _input9[m]<=in9[m];
         end
   endmethod
   method Action load_input(Bool load);
         if (load) 
            fifo_clear<=True;
        endmethod
   method Bool output_status();
        return psum_fifo.notFull;
        endmethod
endmodule: mkmac_array

endpackage:mac_array

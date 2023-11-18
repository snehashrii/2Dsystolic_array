package mac_array;
import mac_row::*;
import Vector :: * ;

interface Ifc_conv;
method Action top_cnn_input(Vector#(4, Bit#(32)) _weight1, Vector#(4, Bit#(32)) _weight2, Vector#(4, Bit#(32)) _weight3, Vector#(4, Bit#(32)) _weight4, Vector#(4, Bit#(32)) in1, Vector#(4, Bit#(32)) in2, Vector#(4, Bit#(32)) in3, Vector#(4, Bit#(32)) in4);
endinterface

(*synthesize*)
module mkmac_array(Ifc_conv);
     Ifc_mac_row mac_r1 <- mkmac_row();
     Ifc_mac_row mac_r2 <- mkmac_row();
     Ifc_mac_row mac_r3 <- mkmac_row();
     Ifc_mac_row mac_r4 <- mkmac_row();

Vector#(4, Reg#(Bit#(32))) weight  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) weight2  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) weight3  <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) weight4  <- replicateM( mkReg( 0 ) );

Vector#(4, Reg#(Bit#(32))) _input <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) _input2 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) _input3 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) _input4 <- replicateM( mkReg( 0 ) );


Vector#(4, Reg#(Bit#(32))) psum_in <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) psum_out <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) psum_out1 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) psum_out2 <- replicateM( mkReg( 0 ) );
Vector#(4, Reg#(Bit#(32))) psum_out3 <- replicateM( mkReg( 0 ) );

Reg#(Bit#(1)) rg_psum_received <- mkReg(0); 
     rule array_weight;
     mac_r1.take_input(weight,psum_in);
     endrule
     
     rule row1_input;
        mac_r1.load_input(_input);
     endrule

     rule getoutput;
     psum_out[0] <= mac_r1.give(0);
     psum_out[1] <= mac_r1.give(1);
     psum_out[2] <= mac_r1.give(2);
     psum_out[3] <= mac_r1.give(3);
   // $display("tb output %0d   %0d    %0d %0d", psum_out[0], psum_out[1], psum_out[2], rg_psum_received);
     endrule
     (* fire_when_enabled *)
     rule array_weight_round2 (mac_r1.give(0)!=0 || mac_r1.give(1)!=0 || mac_r1.give(2)!=0 || psum_out[3]!=0 || psum_out[0]!=0);
      mac_r2.take_input(weight2,psum_out);
     endrule

     rule row2_input;
        mac_r2.load_input(_input2);
     endrule

      rule getoutput2;

     psum_out1[0] <= mac_r2.give(0);
     psum_out1[1] <= mac_r2.give(1);
     psum_out1[2] <= mac_r2.give(2);
     psum_out1[3] <= mac_r2.give(3);
    // $display("tb2 output %0d   %0d    %0d", psum_out1[0], psum_out1[1], psum_out1[2]);
     endrule

    (*fire_when_enabled*)
     rule row3_weight (mac_r2.give(0)!=0 || mac_r2.give(1)!=0 || mac_r2.give(2)!=0 || psum_out1[3]!=0);
     mac_r3.take_input(weight3,psum_out1);
     endrule
     
     rule row3_input;
        mac_r3.load_input(_input3);
     endrule

     rule get_output3;
     psum_out2[0] <= mac_r3.give(0);
     psum_out2[1] <= mac_r3.give(1);
     psum_out2[2] <= mac_r3.give(2);
     psum_out2[3] <= mac_r3.give(3);

    // $display("TB3 output %0d   %0d    %0d", psum_out2[0], psum_out2[1], psum_out2[2]);
     endrule

     (*fire_when_enabled*)
     rule row4_weight (mac_r3.give(0)!=0 || mac_r3.give(1)!=0 || mac_r3.give(2)!=0 || psum_out2[3]!=0);
     mac_r4.take_input(weight4,psum_out2);
     endrule
     
     rule row4_input;
        mac_r4.load_input(_input4);
     endrule

     rule get_output4;
     psum_out3[0] <= mac_r4.give(0);
     psum_out3[1] <= mac_r4.give(1);
     psum_out3[2] <= mac_r4.give(2);
     psum_out3[3] <= mac_r4.give(3);
     $display("TB4 output %0d   %0d    %0d", psum_out3[0], psum_out3[1], psum_out3[2], psum_out3[3]);
     endrule

     method Action top_cnn_input(Vector#(4, Bit#(32)) _weight1, Vector#(4, Bit#(32)) _weight2, Vector#(4, Bit#(32)) _weight3, Vector#(4, Bit#(32)) _weight4, Vector#(4, Bit#(32)) in1, Vector#(4, Bit#(32)) in2, Vector#(4, Bit#(32)) in3, Vector#(4, Bit#(32)) in4);
        writeVReg(weight,_weight1);
        writeVReg(weight2,_weight2);
        writeVReg(weight3,_weight3);
        writeVReg(weight4,_weight4);

        writeVReg(_input,in1);
        writeVReg(_input2,in2);
        writeVReg(_input3,in3);
        writeVReg(_input4,in4);
   endmethod


endmodule: mkmac_array

endpackage:mac_array

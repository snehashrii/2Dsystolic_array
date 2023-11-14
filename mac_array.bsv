package mac_array;
import mac_row::*;
import Vector :: * ;

(*synthesize*)
module mkmac_array(Empty);
     Ifc_mac_row mac_r1 <- mkmac_row();
     Ifc_mac_row mac_r2 <- mkmac_row();
     Ifc_mac_row mac_r3 <- mkmac_row();

Vector#(3, Reg#(Bit#(32))) weight  <- replicateM( mkReg( 1 ) );
weight[1]<- mkReg(4);
weight[2]<- mkReg(7);

Vector#(3, Reg#(Bit#(32))) weight2  <- replicateM( mkReg( 2 ) );
weight2[1]<- mkReg(5);
weight2[2]<- mkReg(8);

Vector#(3, Reg#(Bit#(32))) weight3  <- replicateM( mkReg( 3 ) );
weight3[1]<- mkReg(6);
weight3[2]<- mkReg(9);

Vector#(32, Reg#(Bit#(32))) _input <- replicateM( mkReg( 0 ) );
_input[0]<-mkReg(10);
_input[1]<- mkReg(11);
_input[2]<- mkReg(12);
_input[3]<-mkReg(0);
_input[4]<-mkReg(0);
_input[5]<-mkReg(0);
_input[6]<-mkReg(0);
_input[7]<-mkReg(0);

Vector#(32, Reg#(Bit#(32))) _input2 <- replicateM( mkReg( 0 ) );
_input2[0] <-mkReg(13);
_input2[1]<- mkReg(14);
_input2[2]<- mkReg(15);
_input2[3]<-mkReg(0);
_input2[4]<-mkReg(0);
_input2[5]<-mkReg(0);
_input2[6]<-mkReg(0);
_input2[7]<-mkReg(0);

Vector#(32, Reg#(Bit#(32))) _input3 <- replicateM( mkReg( 0 ) );
_input3[0] <-mkReg(16);
_input3[1]<- mkReg(17);
_input3[2]<- mkReg(18);
_input3[3]<-mkReg(0);
_input3[4]<-mkReg(0);
_input3[5]<-mkReg(0);
_input3[6]<-mkReg(0);
_input3[7]<-mkReg(0);
_input3[8]<-mkReg(0);

Vector#(3, Reg#(Bit#(32))) psum_in<- replicateM( mkReg( 0 ) );
Vector#(3, Reg#(Bit#(32))) psum_out <- replicateM( mkReg( 0 ) );
Vector#(3, Reg#(Bit#(32))) psum_out1 <- replicateM( mkReg( 0 ) );
Vector#(3, Reg#(Bit#(32))) psum_out2 <- replicateM( mkReg( 0 ) );
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
    // $display("tb output %0d   %0d    %0d %0d", psum_out[0], psum_out[1], psum_out[2], rg_psum_received);
     endrule
     (* fire_when_enabled *)
     rule array_weight_round2 (mac_r1.give(0)!=0 || mac_r1.give(1)!=0 || mac_r1.give(2)!=0 || psum_out[2]!=0);
      mac_r2.take_input(weight2,psum_out);
     endrule

     rule row2_input;
        mac_r2.load_input(_input2);
     endrule

      rule getoutput2;

     psum_out1[0] <= mac_r2.give(0);
     psum_out1[1] <= mac_r2.give(1);
     psum_out1[2] <= mac_r2.give(2);
     //$display("tb2 output %0d   %0d    %0d", psum_out1[0], psum_out1[1], psum_out1[2]);
     endrule

    (*fire_when_enabled*)
     rule row3_weight (mac_r2.give(0)!=0 || mac_r2.give(1)!=0 || mac_r2.give(2)!=0 || psum_out[2]!=0);
     mac_r3.take_input(weight3,psum_out1);
     endrule
     
     rule row3_input;
        mac_r3.load_input(_input3);
     endrule

     rule get_output3;
     psum_out2[0] <= mac_r3.give(0);
     psum_out2[1] <= mac_r3.give(1);
     psum_out2[2] <= mac_r3.give(2);
     $display("TB3 output %0d   %0d    %0d", psum_out2[0], psum_out2[1], psum_out2[2]);
     endrule

endmodule: mkmac_array

endpackage:mac_array

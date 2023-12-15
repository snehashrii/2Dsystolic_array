import Vector ::*;
import mac_array ::*;
import pooling ::*;
import fpu_common::*;
import FloatingPoint::*;

typedef struct { 
    Array#(Array#(int)) windows;
    } Inps deriving  (Bits);

function Inps im2col(int input_data[][], FloatingPoint#(11,52) weight_kernel[][]) provisos(Bitwise#(Bit#(32)));
Inps h;
int i, j,k,l,m, count, irow;
count=0;
irow=0;
int input1[9], input2[9][1024];
for (i=0;i<32;i=i+1) begin
   for(j=0;j<32;j=j+1) begin 
     for(k=i;k<i+3;k=k+1)  begin
        for(l=j;l<j+3;l=l+1) begin
           input1[count]=input_data[k][l];
           count=count+1;
           end
        end
        count=0;
        for (m=0;m<9;m=m+1) begin
           input2[m][irow]=input1[m];
           end

         /*if (irow==0)
        h.w=arrayToVector(input1);
        else if (irow==1)
        h.x=arrayToVector(input1);
        else if (irow==2)
        h.y=arrayToVector(input1);
        else
        h.z=arrayToVector(input1);*/

        irow=irow+1;
      end
      end
h.windows=input2;
FloatingPoint#(11,52) flat_kernel[9];
int c;
c=0;
for (i=0;i<3;i=i+1) begin
    for(j=0;j<3;j=j+1) begin
        flat_kernel[c]=weight_kernel[i][j];
        c=c+1;
        end
        end

   /*h.w1[0]=flat_kernel[0];
   h.w1[1]=0;
   h.w1[2]=0;
   h.w1[3]=0;
   h.w2[0]=flat_kernel[1];
   h.w2[1]=0;
   h.w2[2]=0;
   h.w2[3]=0;
   h.w3[0]=flat_kernel[2];
   h.w3[1]=0;
   h.w3[2]=0;
   h.w3[3]=0;
   h.w4[0]=flat_kernel[3];
   h.w4[1]=0;
   h.w4[2]=0;
   h.w4[3]=0;
   h.w5[0]=flat_kernel[4];
   h.w5[1]=0;
   h.w5[2]=0;
   h.w5[3]=0;
   h.w6[0]=flat_kernel[5];
   h.w6[1]=0;
   h.w6[2]=0;
   h.w6[3]=0;
   h.w7[0]=flat_kernel[6];
   h.w7[1]=0;
   h.w7[2]=0;
   h.w7[3]=0;
   h.w8[0]=flat_kernel[7];
   h.w8[1]=0;
   h.w8[2]=0;
   h.w8[3]=0;
   h.w9[0]=flat_kernel[8];
   h.w9[1]=0;
   h.w9[2]=0;
   h.w9[3]=0;*/



return h;
endfunction



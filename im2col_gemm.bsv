import Vector ::*;
import mac_array ::*;

typedef struct { 
    Vector#(4, Bit#(32)) w; 
    Vector#(4, Bit#(32)) x; 
    Vector#(4, Bit#(32)) y; 
    Vector#(4, Bit#(32)) z;  
    
    Vector#(4, Bit#(32)) w1; 
    Vector#(4, Bit#(32)) w2; 
    Vector#(4, Bit#(32)) w3; 
    Vector#(4, Bit#(32)) w4;} Inps deriving  (Bits);

function Inps im2col(Int#(32) input_data[][], Int#(32) weight_kernel[][]) provisos(Bitwise#(Bit#(32)));
Inps h;
int i, j,k,l, count, irow;
count=0;
irow=0;
Bit#(32) input1[4], input2[4][4];
for (i=0;i<2;i=i+1) begin
   for(j=0;j<2;j=j+1) begin 
     for(k=i;k<i+2;k=k+1)  begin
        for(l=j;l<j+2;l=l+1) begin
           input1[count]=pack(input_data[k][l]);
           count=count+1;
           end
        end
        count=0;
        if (irow==0)
        h.w=arrayToVector(input1);
        else if (irow==1)
        h.x=arrayToVector(input1);
        else if (irow==2)
        h.y=arrayToVector(input1);
        else
        h.z=arrayToVector(input1);

        irow=irow+1;
      end
      end
Bit#(32) flat_kernel[4];
int c;
c=0;
for (i=0;i<2;i=i+1) begin
    for(j=0;j<2;j=j+1) begin
        flat_kernel[c]=pack(weight_kernel[i][j]);
        c=c+1;
        end
        end

   h.w1[0]=flat_kernel[0];
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


return h;
endfunction


(*synthesize*)
module im2col_gemm(Empty);
Ifc_conv systolic <- mkmac_array();
Vector#(32, Reg#(Bit#(32))) ff <-replicateM( mkReg( 0 ) );
Reg#(int) c2 <- mkReg(0);
 Int#(32) input_data[3][3] = {{3,9,0},
                     {2,8,1},
                     {1,4,8}};
 Int#(32) weight_kernel[2][2] = {{8,9},
                                  {4,4}};
Inps i1;
i1=im2col(input_data, weight_kernel);

rule ghjgj;
 systolic.top_cnn_input(i1.w1,i1.w2,i1.w3,i1.w4,i1.w,i1.x,i1.y,i1.z);
endrule



endmodule
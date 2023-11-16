import Vector ::*;
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

return h;
endfunction


(*synthesize*)
module im2col_gemm(Empty);
Reg#(Bit#(32)) ff <-mkReg(0);

 Int#(32) input_data[3][3] = {{3,9,0},
                     {2,8,1},
                     {1,4,8}};
 Int#(32) weight_kernel[4][4] = {{8,9},
                                  {4,4}};
Inps i1;
i1=im2col(input_data, weight_kernel);

rule hjh;
$display("%0d %0d %0d %0d", i1.w[0], i1.w[1], i1.w[2], i1.w[3]);
$display("%0d %0d %0d %0d", i1.x[0], i1.x[1], i1.x[2], i1.x[3]);
$display("%0d %0d %0d %0d", i1.y[0], i1.y[1], i1.y[2], i1.y[3]);
$display("%0d %0d %0d %0d", i1.z[0], i1.z[1], i1.z[2], i1.z[3]);
$finish(0);
endrule

endmodule
function Bit#(32) act_relu(Bit#(32) input)
  Bit#(32) out;
   if (input[31]==0)
     out=in;
     else
     out=0;
     return out;
     endfunction 
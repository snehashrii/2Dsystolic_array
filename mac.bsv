package mac;

interface Ifc_mac;
method ActionValue#(Bit#(32)) mav_psumout(Bit#(32) weight, Bit#(32) input_data, Bit#(32) psum);
endinterface
(*synthesize*)

module mkmac(Ifc_mac);

      method ActionValue#(Bit#(32)) mav_psumout(Bit#(32) weight, Bit#(32) input_data, Bit#(32) psum);
        Bit#(32) result = 0;
        result=zeroExtend((weight*input_data)+psum);
        return result;
     endmethod


endmodule: mkmac
endpackage: mac

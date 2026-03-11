`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a ^ b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);
assign cout[0]=gin[0] | (pin[0]&cin);
assign cout[1]=gin[1] | (pin[1]&gin[0]) | (pin[1]&pin[0]&cin);
assign cout[2]=gin[2] | (pin[2]&gin[1]) | (pin[2]&pin[1]&gin[0]) | (pin[2]&pin[1]&pin[0]&cin);
assign gout=gin[3] | (pin[3]&gin[2]) | (pin[3]&pin[2]&gin[1]) | (pin[3]&pin[2]&pin[1]&gin[0]);
assign pout=pin[3]&pin[2]&pin[1]&pin[0];
   // TODO: your code here

endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);
assign cout[0]=gin[0] | (pin[0]&cin);
assign cout[1]=gin[1] | (pin[1]&gin[0]) | (pin[1]&pin[0]&cin);
assign cout[2]=gin[2] | (pin[2]&gin[1]) | (pin[2]&pin[1]&gin[0]) | (pin[2]&pin[1]&pin[0]&cin);
assign cout[3] = gin[3] | (pin[3]&gin[2]) | (pin[3]&pin[2]&gin[1]) | (pin[3]&pin[2]&pin[1]&gin[0]) | (pin[3]&pin[2]&pin[1]&pin[0]&cin);
    assign cout[4] = gin[4] | (pin[4]&gin[3]) | (pin[4]&pin[3]&gin[2]) | (pin[4]&pin[3]&pin[2]&gin[1])
                   | (pin[4]&pin[3]&pin[2]&pin[1]&gin[0]) | (pin[4]&pin[3]&pin[2]&pin[1]&pin[0]&cin);
    assign cout[5] = gin[5] | (pin[5]&gin[4]) | (pin[5]&pin[4]&gin[3]) | (pin[5]&pin[4]&pin[3]&gin[2])
                   | (pin[5]&pin[4]&pin[3]&pin[2]&gin[1]) | (pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&gin[0])
                   | (pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&pin[0]&cin);
    assign cout[6] = gin[6] | (pin[6]&gin[5]) | (pin[6]&pin[5]&gin[4]) | (pin[6]&pin[5]&pin[4]&gin[3])
                   | (pin[6]&pin[5]&pin[4]&pin[3]&gin[2]) | (pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&gin[1])
                   | (pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&gin[0]) | (pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&pin[0]&cin);
assign gout=gin[7] 
                | (pin[7]&gin[6])
                | (pin[7]&pin[6]&gin[5])
                | (pin[7]&pin[6]&pin[5]&gin[4])
                | (pin[7]&pin[6]&pin[5]&pin[4]&gin[3])
                | (pin[7]&pin[6]&pin[5]&pin[4]&pin[3]&gin[2])
                | (pin[7]&pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&gin[1])
                | (pin[7]&pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&gin[0]);
assign pout=pin[7]&pin[6]&pin[5]&pin[4]&pin[3]&pin[2]&pin[1]&pin[0];
   // TODO: your code here

endmodule

module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);
wire [31:0]g;
wire [31:0]p;
wire [7:0]gg;
wire [7:0]pp;
wire [30:0] c;
wire [6:0]cout8;
genvar i;
generate
for(i=0;i<32;i=i+1)begin
gp1 gp1a(
.a(a[i]),
.b(b[i]),
.g(g[i]),
.p(p[i])
);
end
endgenerate
gp4 gp4_1(.gin(g[3:0]),.pin(p[3:0]),.cin(cin),.gout(gg[0]),.pout(pp[0]),.cout(c[2:0]));

gp4 gp4_2(.gin(g[7:4]),.pin(p[7:4]),.cin(cout8[0]),.gout(gg[1]),.pout(pp[1]),.cout(c[6:4]));

gp4 gp4_3(.gin(g[11:8]),.pin(p[11:8]),.cin(cout8[1]),.gout(gg[2]),.pout(pp[2]),.cout(c[10:8]));

gp4 gp4_4(.gin(g[15:12]),.pin(p[15:12]),.cin(cout8[2]),.gout(gg[3]),.pout(pp[3]),.cout(c[14:12]));

gp4 gp4_5(.gin(g[19:16]),.pin(p[19:16]),.cin(cout8[3]),.gout(gg[4]),.pout(pp[4]),.cout(c[18:16]));

gp4 gp4_6(.gin(g[23:20]),.pin(p[23:20]),.cin(cout8[4]),.gout(gg[5]),.pout(pp[5]),.cout(c[22:20]));

gp4 gp4_7(.gin(g[27:24]),.pin(p[27:24]),.cin(cout8[5]),.gout(gg[6]),.pout(pp[6]),.cout(c[26:24]));

gp4 gp4_8(.gin(g[31:28]),.pin(p[31:28]),.cin(cout8[6]),.gout(gg[7]),.pout(pp[7]),.cout(c[30:28]));

gp8 gp8a(.gin(gg[7:0]),.pin(pp[7:0]),.cin(cin),.gout(),.pout(),.cout(cout8[6:0]));
  assign sum[3:0]    = p[3:0]    ^ {c[2:0], cin};
  assign sum[7:4]    = p[7:4]    ^ {c[6:4], cout8[0]};
  assign sum[11:8]   = p[11:8]   ^ {c[10:8], cout8[1]};
  assign sum[15:12]  = p[15:12]  ^ {c[14:12], cout8[2]};
  assign sum[19:16]  = p[19:16]  ^ {c[18:16], cout8[3]};
  assign sum[23:20]  = p[23:20]  ^ {c[22:20], cout8[4]};
  assign sum[27:24]  = p[27:24]  ^ {c[26:24], cout8[5]};
  assign sum[31:28]  = p[31:28]  ^ {c[30:28], cout8[6]};
 
endmodule

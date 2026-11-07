`timescale 1ns / 1ps
`default_nettype none
module full_adder(
input wire a,b,cin,
output wire sum,cout
    );
    assign sum = a^b^cin;
    assign cout= a&b | b&cin | cin&a;
endmodule
`default_nettype wire
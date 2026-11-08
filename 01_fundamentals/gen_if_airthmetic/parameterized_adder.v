`timescale 1ns / 1ps
`default_nettype none
module parameterized_adder#(parameter WIDTH = 8)(
    input wire [WIDTH-1:0]a,
    input wire [WIDTH-1:0]b,
    output wire [WIDTH-1:0]sum,
    output wire carry
   );
    wire [WIDTH:0]total_sum;
    assign total_sum = {1'b0,a} + {1'b0,b};
    assign sum = total_sum[WIDTH-1:0];
    assign carry = total_sum[WIDTH];
endmodule
`default_nettype wire
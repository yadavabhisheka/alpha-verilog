`timescale 1ns / 1ps
`default_nettype none

module parameterized_add_subr#(parameter WIDTH = 8)(
    input wire [WIDTH-1:0]a,
    input wire [WIDTH-1:0]b,
    input wire sub,
    output wire [WIDTH-1:0]result,
    output wire carry,
    output wire borrow
);

wire [WIDTH-1:0]b_modified;
wire [WIDTH:0]total;

assign b_modified = b ^ {WIDTH{sub}};
assign total = {1'b0,a} + {1'b0,b_modified} + sub;

assign result = total[WIDTH-1:0];
assign carry = total[WIDTH];
assign borrow = sub & ~carry;

endmodule

`default_nettype wire
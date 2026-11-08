`timescale 1ns / 1ps
`default_nettype none

module gen_if_airthmetic#(parameter MODE = 0,WIDTH = 8)(
    input wire [WIDTH-1:0]a,
    input wire [WIDTH-1:0]b,
    input wire sub,
    output wire [WIDTH-1:0]result,
    output wire carry,
    output wire borrow
);

generate
    if(MODE == 0) begin: adder_only
        parameterized_adder #(.WIDTH(WIDTH)) adder(
            .a(a),.b(b),.sum(result),.carry(carry)
        );
        assign borrow = 1'b0;
    end else begin: adder_subtractor
        parameterized_add_subr #(.WIDTH(WIDTH)) adder(
            .a(a),.b(b),.sub(sub),
            .result(result),.carry(carry),.borrow(borrow)
        );
    end
endgenerate

endmodule

`default_nettype wire
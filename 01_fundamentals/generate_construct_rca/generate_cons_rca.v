/*Your task is to implement this using two existing modules:
1. full_adder — the individual processing block.
2. ripple_carry_adder — the top-level module that generates multiple full adders.
Design specification
Signal  	    Width
a	            WIDTH bits
b	            WIDTH bits
cin	            1 bit
sum	            WIDTH bits
cout	        1 bit
Internal carry	WIDTH+1 bits


Use:
- Parameter WIDTH = 8
- genvar
- generate and for
- Named port connections
- Your existing full-adder module
verify:
- Create a testebench to verify the design for WIDTH = 4, 8, and 16 bits. 
The testbench should use all possible combinations of inputs for each width and check the output against the expected result.
*/



`timescale 1ns / 1ps
`default_nettype none
module generate_cons_rca #(parameter WIDTH = 8)(
    input wire [WIDTH-1:0]a,
    input wire [WIDTH-1:0]b,
    input wire cin,
    output wire [WIDTH-1:0]sum,
    output wire cout    
    );
    wire [WIDTH:0]carry;
    assign carry[0] = cin;
    genvar i;
    generate
        for(i=0;i<WIDTH;i=i+1)begin
            //fulladder
            full_adder fa(.a(a[i]),.b(b[i]),.cin(carry[i]),.cout(carry[i+1]),.sum(sum[i]));
        end
    endgenerate
    assign cout = carry[WIDTH];
endmodule
`default_nettype wire
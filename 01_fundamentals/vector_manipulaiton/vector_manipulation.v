/*Design specification
Inputs:
- data: 16-bit input.
- a, b: two 4-bit inputs.
- sel: 1-bit input.
Outputs:
- bit_out: extract bit 5 of data.
- upper: extract bits [15:8].
- lower: extract bits [3:0].
- combined: concatenate a and b.
- replicated: replicate sel eight times.
Requirements
- Use ANSI-style module declaration.
- Use dataflow modeling.
- Write a self-checking testbench.
- Test all possible values of sel.
- Include several different 16-bit input patterns.
- Check every output against an independently calculated expected
*/
`timescale 1ns / 1ps
`default_nettype none
module vector_manipulation(
input wire [15:0]data,
input wire [3:0]a,
input wire [3:0]b,
input wire sel,

output wire bit_out,
output wire [7:0]upper,
output wire [3:0]lower,
output wire [7:0]combined,
output wire [7:0]replicated
    );
    
    assign bit_out = data[5];
    assign upper = data[8+:8];
    assign lower = data [3:0];
    assign combined = {a,b};
    assign replicated = {8{sel}};
endmodule
`default_nettype wire

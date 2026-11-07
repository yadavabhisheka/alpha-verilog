/*Design specification (RTL + Verification)

Design one parameterized unsigned adder.

Parameters

- WIDTH = 8 by default.

Ports
- a: WIDTH bits.
- b: WIDTH bits.
- sum: WIDTH + 1 bits.
Requirements
1. Use ANSI-style module declaration.
2. Use dataflow modeling.
3. Use explicit zero extension before addition.
4. Instantiate the module with WIDTH = 4, 8 and 16 in a separate top-level test module.
5. Verify all three configurations.
6. Test zero, maximum values, carry generation and random inputs.
7. Use a self-checking testbench.
*/
`timescale 1ns / 1ps
`default_nettype none
module parameterized_adder#(parameter WIDTH = 8)(
    input wire [WIDTH-1:0]a,
    input wire [WIDTH-1:0]b,
    output wire [WIDTH:0]sum
   );
    assign sum = {1'b0,a} + {1'b0,b};
endmodule
`default_nettype wire
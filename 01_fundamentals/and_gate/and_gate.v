`timescale 1ns / 1ps
`default_nettype none
module and_gate(
input wire a,b,
output reg y
  );
  
  //gate_level
  //and one(y,a,b);
  //dataflow
  //assign y= a&b;
  //behaviour
  always @(*) begin
     y=a&b;
  end
endmodule
`default_nettype wire
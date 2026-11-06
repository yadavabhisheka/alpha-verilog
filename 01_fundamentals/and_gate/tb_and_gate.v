`timescale 1ns / 1ps
module tb_and_gate;
reg a,b;
wire y;
reg expected;
integer i,error;
//dut
and_gate dut(.a(a),.b(b),.y(y));
//noclk
initial begin 
$dumpfile("and_gate.vcd");
$dumpvars(0,tb_and_gate);
error = 0;
//stimulus
for(i=0;i<4;i=i+1)begin
    {a,b} = i;
    
 //model
 case({a,b})
 2'b00 : expected = 1'b0;
 2'b01 : expected = 1'b0;
 2'b10 : expected = 1'b0;
 2'b11 : expected = 1'b1;
 default : expected = 1'bx;
 endcase
 #10; //delay
 //checker
 if(y!==expected)begin
    $display("Failed at Time = %0t Expected = %b Y =%b",$time,expected,y);
        error = error + 1;
 end
 end
 //verdict
 if(error==0)
    $display("All test passed");
 else 
    $display("Test Failed error = %d",error);
 $finish;
end

endmodule

`timescale 1ns / 1ps
module tb_parameterized_adder;

reg [3:0] a4,b4;
wire [4:0] sum4;

reg [7:0] a8,b8;
wire [8:0] sum8;

reg [15:0] a16,b16;
wire [16:0] sum16;

reg [16:0]expected_sum;
integer i,error,total_check,passed;
//dut
parameterized_adder #(.WIDTH(4)) adder4(
    .a(a4),.b(b4),.sum(sum4)
);

parameterized_adder #(.WIDTH(8)) adder8(
    .a(a8),.b(b8),.sum(sum8)
);

parameterized_adder #(.WIDTH(16)) adder16(
    .a(a16),.b(b16),.sum(sum16)
);
//check_output
task check_output(
    input [16:0] expected,
    input [16:0] actual
                );
    begin
        total_check = total_check + 1;
        if (actual !== expected) begin
            $display("FAIL: expected=%h actual=%h @ %0t", expected, actual, $time);
            error = error + 1;
        end else begin
            $display("PASS: value=%h @ %0t", actual, $time);
            passed = passed + 1;
        end
    end
    endtask
//noclk
initial begin
$dumpfile("parameterized_adder.vcd");
$dumpvars(0,tb_parameterized_adder);

error = 0;  
total_check = 0;
passed = 0;
//adder4bit
for(i=0;i<256;i=i+1)begin
    {a4,b4} = i;
 expected_sum = {13'b0,a4}+{13'b0,b4}; 
 #1  
check_output(expected_sum,{12'b0,sum4});
end
//adder8bit
for(i=0;i<1024;i=i+1)begin
    {a8,b8} = i;
 expected_sum = {9'b0,a8}+{9'b0,b8};  
 #1 
check_output(expected_sum,{8'b0,sum8});
end
//random
for(i=0;i<101;i=i+1)begin
    a8 = $random;
    b8 = $random;
expected_sum = {9'b0,a8}+{9'b0,b8};  
 #1 
check_output(expected_sum,{8'b0,sum8});
end
//direct
a8 = 8'h00;
b8 = 8'h00;
expected_sum = {9'b0,a8}+{9'b0,b8};  
#1
check_output(expected_sum,{8'b0,sum8});

a8 = 8'hFF;
b8 = 8'h00;
expected_sum = {9'b0,a8}+{9'b0,b8};  
#1
check_output(expected_sum,{8'b0,sum8});

a8 = 8'hFF;
b8 = 8'h01;
expected_sum = {9'b0,a8}+{9'b0,b8};  
#1
check_output(expected_sum,{8'b0,sum8});

a8 = 8'hFF;
b8 = 8'hFF;
expected_sum = {9'b0,a8}+{9'b0,b8};  
#1
check_output(expected_sum,{8'b0,sum8});

a8 = 8'hAA;
b8 = 8'h55;
expected_sum = {9'b0,a8}+{9'b0,b8};  
#1
check_output(expected_sum,{8'b0,sum8});
//adder16bit
for(i=0;i<2048;i=i+1)begin
    {a16,b16} = i;
 expected_sum = {1'b0,a16}+{1'b0,b16};  
 #1 
check_output(expected_sum,sum16);

end
//random
for(i=0;i<101;i=i+1)begin
    a16 = $random;
    b16= $random;
expected_sum = {1'b0,a16}+{1'b0,b16};  
 #1 
check_output(expected_sum,sum16);

end
//direct
a16 = 16'h0000;
b16 = 16'h0000;
expected_sum = {1'b0,a16}+{1'b0,b16};  
#1
check_output(expected_sum,sum16);

a16 = 16'hFFFF;
b16 = 16'h0000;
expected_sum = {1'b0,a16}+{1'b0,b16};  
#1
check_output(expected_sum,sum16);

a16 = 16'hFFFF;
b16 = 16'h0001;
expected_sum = {1'b0,a16}+{1'b0,b16};  
#1
check_output(expected_sum,sum16);

a16 = 16'hFFFF;
b16 = 16'hFFFF;
expected_sum = {1'b0,a16}+{1'b0,b16};  
#1
check_output(expected_sum,sum16);

a16 = 16'hAAAA;
b16 = 16'h5555;
expected_sum = {1'b0,a16}+{1'b0,b16};  
#1
check_output(expected_sum,sum16);


//veridict
    $display("\n=======Test Results======");
    $display("Total Checks =%d",total_check);
    $display("Pass =%d",passed);
    $display("Fails =%d",error);
    if(error==0)
            $display("All test passed");
    else
        $display("Error = %d test failed",error);
 $finish;

end
endmodule
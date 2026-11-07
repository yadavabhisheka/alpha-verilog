`timescale 1ns / 1ps
module tb_vector_manipulation;
reg [15:0]data;
reg [3:0]a;
reg [3:0]b;
reg sel;

wire bit_out;
wire [7:0]upper;
wire [3:0]lower;
wire [7:0]combined;
wire [7:0]replicated;

reg [15:0]expected_value;
integer i,error,total_check,passed;
//dut
vector_manipulation dut(
        .data(data),
        .a(a),.b(b),.sel(sel),
    .bit_out(bit_out),.upper(upper),.lower(lower),
    .combined(combined),.replicated(replicated));
 //check_output   
  task check_output(
    input [15:0] expected,
    input [15:0] actual
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
    data = 0;
    a = 0;
    b = 0;
    error = 0;
    total_check = 0;
    passed = 0;
    //sel_check
    sel = 1;
    expected_value = 8'b11111111;
    #1
    check_output(expected_value,replicated);
    
    sel = 0;
    expected_value = 8'b00000000;
    #1
    check_output(expected_value,replicated);
    
    //{a,b}_check
    for(i=0;i<256;i=i+1)begin
        {a,b} = i;
        expected_value = i;
    #1
    check_output(expected_value,combined);
    end
    //data_check
    //bit_check 
    data = 16'h0000;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'hAAAA;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'h0020;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'h0A00;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'hFFF0;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'hFFFF;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
    data = 16'h5555;
    expected_value = data[5];
    #1
    check_output(expected_value,bit_out);
    //upper_check
    expected_value = data[15:8];
    #1
    check_output(expected_value,upper);
    //lower
    expected_value = data[3:0];
    #1
    check_output(expected_value,lower);
    
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

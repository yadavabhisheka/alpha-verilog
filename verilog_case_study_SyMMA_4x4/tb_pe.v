//TESTBENCH : PE-optimized zero detection man
//testing each corener cases
`timescale 1ns / 1ps
`default_nettype none
module tb_pe;
reg clk;
reg rst;
reg acc_clear;
reg weight_load;
reg mac_enable;
reg valid_in;

reg signed [7:0]weight_in;
reg signed [7:0]activation_in;
reg signed [31:0]acc_in;

wire signed [7:0]activation_out;
wire signed [31:0]acc_out;
wire valid_out;

reg signed [31:0]expected_acc_out;
reg signed [7:0]expected_activation_out;
reg expected_valid_out;
integer total_errors,total_checks,passed; 
//dut
pe dut(.rst(rst),.clk(clk),.acc_clear(acc_clear),.weight_load(weight_load),.mac_enable(mac_enable),
        .valid_in(valid_in),.weight_in(weight_in),.activation_in(activation_in),.acc_in(acc_in)
        ,.activation_out(activation_out),.acc_out(acc_out),.valid_out(valid_out));

//clk
initial begin
    clk=0;
    forever #5 clk = ~clk;
end

//check_output_for_all
task check_output (
    input [127:0]test_name
    );
   begin    
        total_checks = total_checks + 1;
        if ((activation_out !== expected_activation_out) || (acc_out !== expected_acc_out) || (valid_out !== expected_valid_out))begin
            total_errors = total_errors + 1;
            $display("Test Failed! | test_name = %0s time = %0t | Ex_acc_out = %d acc_out = %d | Ex_valid_out = %d valid_out = %d | Ex_activation_out = %d activation_out = %d |"
                     ,test_name,$time,expected_acc_out,acc_out,expected_valid_out,valid_out,expected_activation_out,activation_out);
        end else begin    
            passed = passed + 1;
            $display("Test Passed! | test_name = %0s time = %0t | Ex_acc_out = %d acc_out = %d | Ex_valid_out = %d valid_out = %d | Ex_activation_out = %d activation_out = %d |"
                     ,test_name,$time,expected_acc_out,acc_out,expected_valid_out,valid_out,expected_activation_out,activation_out);
        end

   end
endtask
    
//apply_reset
task apply_reset;
begin
    @(negedge clk) rst = 1'b1;
    acc_clear = 0;
    weight_load = 0;
    mac_enable = 0;
    valid_in = 0;
    weight_in = 8'sd5;
    activation_in = 8'sd4;
    acc_in = 32'sd10;

    repeat(2)@(posedge clk);
    #1;
    expected_acc_out = 32'sd0;
    expected_activation_out = 8'sd0;
    expected_valid_out = 1'b0;
    #1;
    check_output("PE_TC01_RESET");

    @(negedge clk) rst = 1'b0;
    weight_in = 8'sd0;
    activation_in = 8'sd0;
    acc_in = 32'sd0;
end
endtask

//load_weight
task load_weight(
    input signed[7:0]w,
    input [127:0]label
    );
begin
@(negedge clk); 
weight_load = 1'b1;
weight_in = w;


expected_acc_out = acc_in;
expected_activation_out = 8'sd0;
expected_valid_out = 1'b0;

@(posedge clk);
#1;
check_output(label);
@(negedge clk);
weight_load = 1'b0;

end
endtask

//step_mac
task step_mac(
    input en,
    input v_in,
    input signed [7:0]act,
    input signed [31:0]acc,
    input signed [31:0]exp_acc,
    input signed [7:0]exp_act,
    input exp_v,
    input [127:0]label
);
begin
    @(negedge clk);
    mac_enable = en;
    valid_in = v_in;
    activation_in = act;
    acc_in = acc;

    expected_acc_out = exp_acc;
    expected_activation_out = exp_act;
    expected_valid_out= exp_v;

    @(posedge clk);
    #1;
    check_output(label);
end
endtask

initial begin
    total_errors = 0;
    total_checks = 0;
    passed = 0;

    rst = 0;
    acc_clear = 0;
    weight_load = 0;
    mac_enable = 0;
    valid_in = 0;
    weight_in  = 0;
    activation_in = 0;
    acc_in = 0;

    //PE_TC01_RESET
    apply_reset;
    //PE_TC02_UNLOAD
    step_mac(1'b1, 1'b1, 8'sd7, 32'sd10, 32'sd10, 8'sd7, 1'b1, "PE_TC02_UNLOAD");
    //PE_TC03_LOAD
   @(negedge clk);
   acc_in = 32'sd15;
   activation_in = 8'sd9;
   valid_in = 1'b1;
   load_weight(8'sd6,"PE_TC03_LOAD");
   @(negedge clk);
   acc_in = 32'sd0;
   activation_in = 8'sd0;
   valid_in = 1'b0;

    //PE_TC04_POS_POS
    step_mac(1'b1, 1'b1, 8'sd4, 32'sd10, 32'sd34, 8'sd4, 1'b1, "PE_TC04_POS_POS");

    //PE_TC05_NEG_POS   
    step_mac(1'b1, 1'b1, -8'sd5, 32'sd40, 32'sd10, -8'sd5, 1'b1, "PE_TC05_NEG_POS");

    //PE_TC06_POS_NEG
    load_weight(-8'sd7,"LOAD_W_NEG7");
    step_mac(1'b1, 1'b1, 8'sd3, 32'sd5, -32'sd16, 8'sd3, 1'b1, "PE_TC06_POS_NEG");

    //PE_TC07_NEG_NEG
    step_mac(1'b1, 1'b1, -8'sd4, -32'sd10, 32'sd18, -8'sd4, 1'b1, "PE_TC07_NEG_NEG");

    //PE_TC08_ZERO_ACT
    step_mac(1'b1, 1'b1, 8'sd0, 32'sd55, 32'sd55, 8'sd0, 1'b1, "PE_TC08_ZERO_ACT");

    //PE_TC09_ZERO_WGT
    load_weight(8'sd0,"LOAD_W_ZERO");
    step_mac(1'b1, 1'b1, 8'sd12, -32'sd20, -32'sd20, 8'sd12, 1'b1, "PE_TC09_ZERO_WGT");

    //PE_TC10_INV_BUBBLE
    load_weight(8'sd5,"LOAD_W_POS5");
    step_mac(1'b1, 1'b0, 8'sd9, 32'sd33, 32'sd33, 8'sd9, 1'b0, "PE_TC10_INV_BUBBLE");

    //PE_TC11_MAC_DIS
    step_mac(1'b0, 1'b1, 8'sd9, 32'sd33, 32'sd33, 8'sd9, 1'b1, "PE_TC11_MAC_DIS");
    
    //PE_TC12_ACC_CLR
    acc_clear = 1;
    step_mac(1'b0, 1'b1, 8'sd9, 32'sd33, 32'sd0, 8'sd0, 1'b0, "PE_TC12_ACC_CLR");

    acc_clear = 0;
    step_mac(1'b1, 1'b1, 8'sd2, 32'sd0, 32'sd10, 8'sd2, 1'b1, "PE_TC12_CLR_CY2");

    //PE_TC13_PRIORITY
   
    acc_clear = 1'b1;
    weight_load = 1'b1;
    weight_in = 8'sd99;
    step_mac(1'b1, 1'b1, 8'sd9, 32'sd33, 32'sd0, 8'sd0, 1'b0, "PE_TC13_AC_WL");

   
    acc_clear = 1'b0;
    weight_load = 1'b0; 
    step_mac(1'b1, 1'b1, 8'sd2, 32'sd0, 32'sd10, 8'sd2, 1'b1, "PE_TC13_W_KEPT");

   
    rst = 1'b1;
    acc_clear = 1'b1;
    step_mac(1'b1, 1'b1, 8'sd9, 32'sd33, 32'sd0, 8'sd0, 1'b0, "PE_TC13_RST_AC");

   
    rst = 1'b0;
    acc_clear = 1'b0;
    step_mac(1'b1, 1'b1, 8'sd2, 32'sd10, 32'sd10, 8'sd2, 1'b1, "PE_TC13_UNLOAD");

    //PE_TC14_WRELOAD
    load_weight(8'sd3,"LOAD_W_POS3");
    step_mac(1'b1, 1'b1, 8'sd2, 32'sd0, 32'sd6, 8'sd2, 1'b1, "PE_TC14_W1");

    load_weight(-8'sd4, "LOAD_W_NEG4");
    step_mac(1'b1, 1'b1, 8'sd2, 32'sd0, -32'sd8, 8'sd2, 1'b1, "PE_TC14_W2");


    //PE_TC15_MAX_POS
    load_weight(-8'sd128, "LOAD_W_N128");
    step_mac(1'b1, 1'b1, -8'sd128, 32'sd0, 32'sd16384, -8'sd128, 1'b1, "PE_TC15_MAX_POS");

    //PE_TC16_MAX_NEG
    step_mac(1'b1, 1'b1, 8'sd127, 32'sd0, -32'sd16256, 8'sd127, 1'b1, "PE_TC16_MAX_NEG");

    //PE_TC17_OVERFLOW
    load_weight(8'sd1, "LOAD_W_POS1");
    step_mac(1'b1, 1'b1, 8'sd1, 32'sd2147483647, -32'sd2147483648, 8'sd1, 1'b1, "PE_TC17_WRAP");

    //PE_TC18_STREAM
    load_weight(8'sd2, "LOAD_W_POS2");

    step_mac(1'b1, 1'b1, 8'sd1, 32'sd0, 32'sd2, 8'sd1, 1'b1, "PE_TC18_CY1");

    step_mac(1'b1, 1'b1, 8'sd2, acc_out, 32'sd6, 8'sd2, 1'b1, "PE_TC18_CY2");

    step_mac(1'b1, 1'b1, 8'sd3, acc_out, 32'sd12, 8'sd3, 1'b1, "PE_TC18_CY3");

    step_mac(1'b1, 1'b1, 8'sd4, acc_out, 32'sd20, 8'sd4, 1'b1, "PE_TC18_CY4");

    //Test summary
    $display("======TESTBENCH SUMMARY======");
    $display("TOTAL TEST: %d",total_checks);
    $display("FAILED: %d",total_errors);
    $display("PASSED: %d",passed);
    if(total_errors==0) $display("ALL TESTCASES PASSED");
    
$finish;
end
endmodule
`default_nettype wire
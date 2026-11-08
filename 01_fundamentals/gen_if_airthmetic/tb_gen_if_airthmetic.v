`timescale 1ns / 1ps
`default_nettype none

module tb_gen_if_arithmetic;

reg [7:0]a,b;
reg sub;

wire [7:0]result0,result1;
wire carry0,carry1,borrow0,borrow1;

reg [8:0]expected_add;
reg [7:0]expected_result;
reg expected_carry,expected_borrow;

integer i,error_mode0,error_mode1,total_checks,passed;

gen_if_airthmetic #(.MODE(0),.WIDTH(8)) dut0(
    .a(a),.b(b),.sub(sub),
    .result(result0),.carry(carry0),.borrow(borrow0)
);

gen_if_airthmetic #(.MODE(1),.WIDTH(8)) dut1(
    .a(a),.b(b),.sub(sub),
    .result(result1),.carry(carry1),.borrow(borrow1)
);

task check_outputs;
begin
    expected_add = {1'b0,a}+{1'b0,b};

    if(sub == 0) begin
        expected_result = expected_add[7:0];
        expected_carry = expected_add[8];
        expected_borrow = 0;
    end else begin
        expected_result = a-b;
        expected_carry = (a>=b);
        expected_borrow = (a<b);
    end

    total_checks = total_checks + 2;

    if({carry0,result0} !== expected_add || borrow0 !== 1'b0) begin
        $display("FAIL MODE0 A=%h B=%h SUB=%b",a,b,sub);
        error_mode0 = error_mode0+1;
    end else begin
        passed = passed+1;
    end

    if(result1 !== expected_result ||
       carry1 !== expected_carry ||
       borrow1 !== expected_borrow) begin

        $display("FAIL MODE1 A=%h B=%h SUB=%b",a,b,sub);
        $display("Expected: Result=%h Carry=%b Borrow=%b",
                 expected_result,expected_carry,expected_borrow);
        $display("Actual: Result=%h Carry=%b Borrow=%b",
                 result1,carry1,borrow1);

        error_mode1 = error_mode1+1;
    end else begin
        passed = passed+1;
    end
end
endtask

initial begin

    $dumpfile("gen_if_arithmetic.vcd");
    $dumpvars(0,tb_gen_if_arithmetic);

    error_mode0 = 0;
    error_mode1 = 0;
    total_checks = 0;
    passed = 0;

    a = 0;
    b = 0;
    sub = 0;

    //directed addition
    a=8'h00; b=8'h00; sub=0; #1; check_outputs();
    a=8'hFF; b=8'h01; sub=0; #1; check_outputs();
    a=8'hFF; b=8'hFF; sub=0; #1; check_outputs();
    a=8'hAA; b=8'h55; sub=0; #1; check_outputs();

    //directed subtraction
    a=8'd10; b=8'd5; sub=1; #1; check_outputs();
    a=8'd5; b=8'd10; sub=1; #1; check_outputs();
    a=8'hFF; b=8'h01; sub=1; #1; check_outputs();
    a=8'h00; b=8'h00; sub=1; #1; check_outputs();
    a=8'hFF; b=8'hFF; sub=1; #1; check_outputs();

    //random testing
    for(i=0;i<100;i=i+1) begin
        a=$random;
        b=$random;
        sub=$random;
        #1;
        check_outputs();
    end

    $display("\n======= TEST RESULTS =======");
    $display("Total Checks = %0d",total_checks);
    $display("Passed = %0d",passed);
    $display("MODE0 Errors = %0d",error_mode0);
    $display("MODE1 Errors = %0d",error_mode1);

    if(error_mode0==0 && error_mode1==0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILED");

    $finish;
end

endmodule

`default_nettype wire
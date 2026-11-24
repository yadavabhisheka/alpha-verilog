//Processing Element v1: Optimizied Zero Dectection MAC
//Single Cycle operation everything happens on one clk cycle
`timescale 1ns / 1ps
`default_nettype none
module pe(
//control_signals
input wire clk,
input wire rst,
input wire acc_clear,
input wire weight_load,
input wire mac_enable,
input wire valid_in,

//input_values
input wire signed [7:0]weight_in,
input wire signed [7:0]activation_in,
input wire signed [31:0]acc_in,

//output_to_next_pe
output reg signed [7:0]activation_out,
output reg signed [31:0]acc_out,
//valid_output_is_propagating
output reg valid_out
);
//weight_reg
reg signed [7:0]weight_reg;
reg weight_valid;
//datapath_wires
wire zero_detect;
wire mac_active;
wire signed [7:0]mul_a;
wire signed [7:0]mul_w;
wire signed [15:0]product;
wire signed [31:0]product_ext;
wire signed [31:0]acc_next;
//zero_detection_if_0_no_need_to_multiply
assign zero_detect = (activation_in==8'sd0) || (weight_reg==8'sd0);
//whether_each_signal_is_ready
assign mac_active = mac_enable && valid_in && weight_valid && !zero_detect && !weight_load;
//values_to_multiply
assign mul_a = mac_active ? activation_in : 8'sd0;
assign mul_w = mac_active ? weight_reg : 8'sd0;
//product_of_weight_activation
assign product = mul_a * mul_w;
//sign_extension_using_concatation
assign product_ext = {{16{product[15]}},product};
//final_multiply_and_accumulate
assign acc_next = mac_active ? (acc_in + product_ext) : acc_in;

//sync_clk: target 100MHZ
always @(posedge clk)begin
    //Priority 1: if rst=1'b1 everything goes to zero
if(rst)begin
    weight_reg <= 8'sd0;
    weight_valid <= 1'b0;
    acc_out <= 32'sd0;
    activation_out <= 8'sd0;
    valid_out <= 1'b0;
    //Priority 2: if acc_clear=1'b1 outputs goes to zero
end else if(acc_clear) begin
    acc_out <= 32'sd0;
    activation_out <= 8'sd0;
    valid_out <= 1'b0;
    //Priority 3: if rst and acc_clear is down lets load the weights
end else if(weight_load)begin 
    weight_reg <= weight_in;
    weight_valid <= 1'b1;
    acc_out <= acc_in;
    activation_out <= 8'sd0;
    valid_out <= 1'b0;
    //Last priority: just assign the outputs
end else begin 
    acc_out <= acc_next;
    activation_out <= activation_in;
    valid_out <= valid_in;
end
end 
endmodule
`default_nettype wire
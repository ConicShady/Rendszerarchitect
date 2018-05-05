`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2018 04:29:41 PM
// Design Name: 
// Module Name: baud_generator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define clk_period 31.25

module baud_generator_tb();
    
    reg clk_in;
    wire clk_out;
    reg [2:0]baud_reg;
    wire [14:0]divider;

baud_generator BAUD_GENERATOR(
    .clk_in(clk_in),
    .clk_out(clk_out),
    .baud_reg(baud_reg),
    .divider(divider)
);

initial clk_in=1;
initial baud_reg=3'b111;

always #(`clk_period/2) clk_in=~clk_in;
    
initial begin
    #(`clk_period*600);
    $finish;
end    
endmodule

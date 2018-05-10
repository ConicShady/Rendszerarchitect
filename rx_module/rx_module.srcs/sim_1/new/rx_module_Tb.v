`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2018 12:44:45 PM
// Design Name: 
// Module Name: rx_module_Tb
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

module rx_module_Tb();

    reg clk, rxIn;
    reg [6:0]confBits;
    wire baudrate,baudrate16;
    wire [32:0]clkNum;
    
 rx_module RX_MODULE(
    .clk(clk),
    .rxIn(rxIn),
    .confBits(confBits),
    .baudrate(baudrate),
    .baudrate16(baudrate16),
    .clkNum(clkNum)
);

initial clk <=1;
initial confBits <= 7'b1101111;

always #(`clk_period/2) clk <= ~clk;


initial begin
    #(`clk_period*12000);
    $finish;
end    

endmodule

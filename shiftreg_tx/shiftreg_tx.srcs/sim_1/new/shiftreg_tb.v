`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2018 09:20:06 PM
// Design Name: 
// Module Name: shiftreg_tb
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

`define clk_period 10

module shiftreg_tb();

    reg clk,load,reset;
    reg [11:0]din;
    wire dout;
    
shiftreg_tx SHIFTREG(
    .clk(clk),
    .load(load),
    .reset(reset),
    .din(din),
    .dout(dout)
);

initial clk =1;
initial din=12'b101010101001;

always #(`clk_period/2) clk=~clk;

initial begin
    reset=0;
    #`clk_period;
    
    reset=1;
    #`clk_period;
    
    reset=0;
    #(`clk_period);
    
    load=0;
        #`clk_period;
        
    load=1;
    #`clk_period;
            
    load=0;
    #(`clk_period);
    
    din=12'b000000000000;
    #`clk_period;
    
    #(`clk_period*50);
    $finish;
end
    
endmodule

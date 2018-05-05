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
    
    
    reg clk,dataReady;
    reg [7:0]dataIn;
    reg [6:0]confBits;
    wire dout;
    wire [3:0]frameLen;
    
    wire [3:0] szamlalo;
    wire foglalt;
    wire [11:0] frameki;
    wire paritas;
    
shiftreg_tx SHIFTREG(
    .confBits(confBits),
    .clk(clk),
    .dataIn(dataIn),
    .dataReady(dataReady),
    .dout(dout),
    .frameLen(frameLen),
    .foglalt(foglalt),
    .szamlalo(szamlalo),
    .frameki(frameki),
    .paritas(paritas)
    
);

initial confBits=7'b1110000;
initial clk =1;

always #(`clk_period/2) clk=~clk;

initial begin
    dataIn=8'b01010110;
    dataReady=0;
    
    #77 dataReady=1;
    
    /*
    #18 dataReady=0;
   
    #98 dataReady=1;
    
    #18 dataReady=0;
   */
    /*
    #120 dataReady=1;
    
    #40 dataReady=0;
        */    

    #(`clk_period*50);
    $finish;
end
    
endmodule

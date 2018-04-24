`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2018 09:04:14 PM
// Design Name: 
// Module Name: shiftreg_tx
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


module shiftreg_tx(
    input clk,
    input load,
    input reset,
    input [11:0]din,
    output dout
    );
    
    reg dout;
    wire [11:0]din;
    wire clk;
    wire reset;
    wire load;
    
    reg [11:0]temp;
    
always @(posedge (clk)) begin
    if(reset)
        temp <=1;
    else if(load)
        temp <=din;
    else begin
        dout <=temp[11];
        temp<={temp[10:0],1'b0};
    end
end     
    
endmodule

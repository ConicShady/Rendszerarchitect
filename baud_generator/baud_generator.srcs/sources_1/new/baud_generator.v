`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2018 04:18:03 PM
// Design Name: 
// Module Name: baud_generator
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


module baud_generator(
    input clk_in,
    input [2:0] baud_reg,
    output clk_out,
    output [14:0]divider
    );
    
    reg [14:0]clkCntr = 15'b000000000000000;
    reg [14:0]divider;
    reg clk_out;
    
initial clk_out<=1;

always @(baud_reg) begin
    case(baud_reg)
       3'b000:  divider <= 15'b110100000101011;
       3'b001:  divider <= 15'b011010000010101;
       3'b010:  divider <= 15'b001101000001011;
       3'b011:  divider <= 15'b000110100000101;
       3'b100:  divider <= 15'b000011010000011;
       3'b101:  divider <= 15'b000001101000001;
       3'b110:  divider <= 15'b000001000101100;
       3'b111:  divider <= 15'b000000100010110;
    endcase
end

always@ (posedge(clk_in)) begin
    clkCntr<=clkCntr+1;
end

always @(clkCntr) begin
    if(clkCntr==((divider/2)+1))begin
        clk_out<=~clk_out;
        clkCntr<=1;
    end

end   
endmodule

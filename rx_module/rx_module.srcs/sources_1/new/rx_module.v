`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2018 04:13:53 PM
// Design Name: 
// Module Name: rx_module
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


module rx_module(
    input clk,
    input rxIn,
    input [6:0]confBits,    //0:data, 1-2:parity, 3:stop, 4-6: baudrate
        //PARITÁS: MSB(confBits[2]): van-nincs, LSB(confBits[1]): milyen? 0: páros, 1: páratlan
    output comError,  //A startbittel vagy a stopbittel hiba következikl be, és felhasználói beavatkozás szükséges 0: no error, 1: error
    output parError,  ///A paritásbit errorja 0: no error, 1: parity error
    output [12:0]dataIn,
    output baudrate,
    output baudrate16,
    output clkNum
    );
    
    reg [3:0]baudCntr=4'b0000;
    reg baudrate;
    reg baudrate16;
    reg [14:0]divider;
    reg [14:0]divider16;
    reg [14:0]clkCntr = 15'b000000000000000;
    reg [14:0]clkCntr16 = 15'b000000000000000;
    reg [32:0]clkNum = 0;
    
    reg comError;
    reg parError;
    reg [12:0]dataIn;

//Baud rate el?állítása a CLK-ból    
initial baudrate <= 1;
initial baudrate16 <= 1;
    
always @(confBits) begin
    case(confBits[6:4])
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
always @(divider) begin
    divider16 <= divider>>4;
end

always@ (posedge(clk)) begin
    clkCntr <= clkCntr+1;
    clkCntr16 <= clkCntr16+1;
    clkNum <= clkNum+1;
    
    if(clkCntr==((divider/2)))begin
            baudrate <= ~baudrate;
            clkCntr <= 1;
    end
    
    if(clkCntr16==((divider16>>1)))begin
            baudrate16 <= ~baudrate16;
            clkCntr16 <= 1;
    end
end
/*
always @(clkCntr16) begin
    if(clkCntr16==((divider16>>1)))begin
        baudrate16 <= ~baudrate16;
        clkCntr16 <= 1;
    end
end  
*/
endmodule

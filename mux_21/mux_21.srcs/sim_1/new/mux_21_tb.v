`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2018 07:52:37 PM
// Design Name: 
// Module Name: mux_21_tb
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

module mux_21_tb();

reg in0,in1,sel;
wire r;

mux_21 MUX_21(
    .in0(in0),
    .in1(in1),
    .sel(sel),
    .r(r)
    );

initial begin

     in0=1;
     in1=0;
     sel=0;
#100 sel=1;
#100 sel=0;
#100 sel=1;
#100 sel=0;
#100 sel=1;
#100 sel=0;

end
endmodule

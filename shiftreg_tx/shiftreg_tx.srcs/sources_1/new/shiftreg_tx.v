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

//Kimenetek, bemenetek, változók
module shiftreg_tx(
    input [6:0]confBits, //0:data, 1-2:parity, 3:stop, 4-6: baudrate
    //PARITÁS: MSB(confBits[2]): van-nincs, LSB(confBits[1]): milyen? 0: páros, 1: páratlan
    input clk,
    input [7:0]dataIn,
    input dataReady,
    output dout,
    output [3:0]frameLen,
    output foglalt,
    output [3:0] szamlalo,
    output [11:0]temporary,
    output [11:0] frameki,
    output paritas
    );
    
    reg foglalt;
    reg [3:0] szamlalo;
    reg [11:0] frameki;
    reg paritas;
    
    reg busy=0;
    reg [3:0]bitCntr=0;
    wire [3:0]frameLen;
    reg dout;
    reg [11:0]temp;
    wire parity;
    wire [11:0]frame1; wire [11:0]frame2; wire [11:0]frame3; wire [11:0]frame4; wire [11:0]frame5; wire [11:0]frame6; wire [11:0]frame7; wire [11:0]frame8;
    wire [2:0]sel;
 
//A framelength meghatározása, mert ez csak egy kombinációs hálózat 
assign frameLen=9+confBits[0]+confBits[2]+confBits[3];

//A MUX kiválasztó jeleinek számolása a konfigurációs regiszterek alapján
assign sel={confBits[0],confBits[2],confBits[3]};

//Parityx with assign
assign parity = (confBits[1]==0) ? ((confBits[0]==0) ? ^dataIn[6:0] : ^dataIn) : ((confBits[0]==0) ? ~^dataIn[6:0] : ~^dataIn) ;

//FRAME-ek el?állítása
assign frame1={1'b0,dataIn[6:0],1'b1,3'b111};
assign frame2={1'b0,dataIn[6:0],2'b1,2'b11};
assign frame3={1'b0,dataIn[6:0],parity,1'b1,2'b11};
assign frame4={1'b0,dataIn[6:0],parity,2'b11,1'b1};
assign frame5={1'b0,dataIn[7:0],1'b1,2'b11};
assign frame6={1'b0,dataIn[7:0],2'b11,1'b1};
assign frame7={1'b0,dataIn[7:0],parity,1'b1,1'b1};
assign frame8={1'b0,dataIn[7:0],parity,2'b11};

//MUX a shift reg el?tt
always @( posedge (busy), sel) begin
   case (sel)
       3'b000:  temp <= frame1;
       3'b001:  temp <= frame2;
       3'b010:  temp <= frame3;
       3'b011:  temp <= frame4;
       3'b100:  temp <= frame5;
       3'b101:  temp <= frame6;
       3'b110:  temp <= frame7;
       3'b111:  temp <= frame8;
   endcase
end

always @(posedge (clk)) begin
    
    foglalt<=busy;
    szamlalo<=bitCntr;
    frameki<=temp;
    paritas<=parity;

 // shift-regiszter
    if(busy==0)begin
        if(dataReady==1)begin
            busy<=1;
        end
        else
            temp <=12'b111111111111;     
    end
    
    if(busy==1) begin
        bitCntr <=bitCntr+1;
        dout <=temp[11];
        temp <={temp[10:0],1'b1};
        if(bitCntr==(frameLen-1)) begin
            bitCntr <=4'b0000;
            busy <=0;
            dout<=1;
        end
    end    
end
endmodule

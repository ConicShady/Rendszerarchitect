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
    reg [11:0]temporary;
    reg [11:0] frameki;
    reg paritas;
    
    reg busy=0;
    reg [3:0]bitCntr=0;
    wire [3:0]frameLen;
    reg dout;
    reg [11:0]temp;
    reg parity;
    reg [11:0]frame1; reg [11:0]frame2; reg [11:0]frame3; reg [11:0]frame4; reg [11:0]frame5; reg [11:0]frame6; reg [11:0]frame7; reg [11:0]frame8;
    reg sel;
    reg [11:0]shrIn;
 
assign frameLen=9+confBits[0]+confBits[2]+confBits[3];
/*
always @ (*) begin
//parity
    if (confBits[0]==0)
        parity<=(dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^dataIn[6];
    else
        parity<=(dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^(dataIn[6]^dataIn[7]); 
    if (confBits[1]==1)
        parity<=~parity;
        
 //framegenerátor
    frame1<={1'b0,dataIn[6:0],1'b1,3'b111};
    frame2<={1'b0,dataIn[6:0],2'b11,2'b11};
    frame3<={1'b0,dataIn[6:0],parity,1'b1,2'b11};
    frame4<={1'b0,dataIn[6:0],parity,2'b11,1'b1};
    frame5<={1'b0,dataIn[7:0],1'b1,2'b11};
    frame6<={1'b0,dataIn[7:0],2'b11,1'b1};
    frame7<={1'b0,dataIn[7:0],parity,1'b1,1'b1};
    frame8<={1'b0,dataIn[7:0],parity,2'b11};
    
 //multiplexer 8_1
    sel={confBits[0],confBits[2],confBits[3]};
    case (sel)
        3'b000:shrIn<=frame1;
        3'b001:shrIn<=frame2;
        3'b010:shrIn<=frame3;
        3'b011:shrIn<=frame4;
        3'b100:shrIn<=frame5;
        3'b101:shrIn<=frame6;
        3'b110:shrIn<=frame7;
        3'b111:shrIn<=frame8;
    endcase 
        
end
   */
always @(posedge (clk)) begin
    
    foglalt<=busy;
    szamlalo<=bitCntr;
    temporary<=temp;
    frameki<=shrIn;
    paritas<=parity;
    

    //parity
    if(confBits[1]==0) begin
        if (confBits[0]==0)
            parity<=(dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^dataIn[6];
        else
            parity<=(dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^(dataIn[6]^dataIn[7]); 
    end
    if (confBits[1]==1) begin
        if (confBits[0]==0)
            parity<=~((dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^dataIn[6]);
        else
            parity<=~((dataIn[0]^dataIn[1])^(dataIn[2]^dataIn[3])^(dataIn[4]^dataIn[5])^(dataIn[6]^dataIn[7])); 
    end
        
        
 //framegenerátor
    frame1<={1'b0,dataIn[6:0],1'b1,3'b111};
    frame2<={1'b0,dataIn[6:0],2'b11,2'b11};
    frame3<={1'b0,dataIn[6:0],parity,1'b1,2'b11};
    frame4<={1'b0,dataIn[6:0],parity,2'b11,1'b1};
    frame5<={1'b0,dataIn[7:0],1'b1,2'b11};
    frame6<={1'b0,dataIn[7:0],2'b11,1'b1};
    frame7<={1'b0,dataIn[7:0],parity,1'b1,1'b1};
    frame8<={1'b0,dataIn[7:0],parity,2'b11};
    
 //multiplexer 8_1
    sel={confBits[0],confBits[2],confBits[3]};
    case (sel)
        3'b000:shrIn<=frame1;
        3'b001:shrIn<=frame2;
        3'b010:shrIn<=frame3;
        3'b011:shrIn<=frame4;
        3'b100:shrIn<=frame5;
        3'b101:shrIn<=frame6;
        3'b110:shrIn<=frame7;
        3'b111:shrIn<=frame8;
    endcase 
/*
    else if(reset)begin
        temp <=12'b111111111111;
        dout <=1;
    end
 */   
 
 // shift-regiszter
    if(busy==0)begin
        if(dataReady==1)begin
            temp <=shrIn;
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

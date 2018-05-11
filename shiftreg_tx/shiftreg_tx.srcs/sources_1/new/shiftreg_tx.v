`timescale 1ns / 1ps

//Kimenetek, bemenetek, változók
module shiftreg_tx(
    input [6:0]confBits, //0:data, 1-2:parity, 3:stop, 4-6: baudrate
    //PARITÁS: MSB(confBits[2]): van-nincs, LSB(confBits[1]): milyen? 0: páros, 1: páratlan
    input clk,
    input [7:0]dataIn,
    input dataReady,
    output dout,
    output [3:0]frameLen,
    output busy,
    output [3:0] bitCntr,
    output [10:0] temp,
    output parity,
    output baudrate
    );
         
    reg busy=0;
    reg [3:0]bitCntr=0;
    wire [3:0]frameLen;
    reg dout;
    reg [11:0]temp;
    wire parity;
    wire [11:0]frame1; wire [11:0]frame2; wire [11:0]frame3; wire [11:0]frame4; wire [11:0]frame5; wire [11:0]frame6; wire [11:0]frame7; wire [11:0]frame8;
    wire [2:0]sel;
    reg [11:0]muxOut;
    reg baudrate;
    reg [14:0]clkCntr = 15'b000000000000000;
    reg [14:0]divider;
 
initial dout <=1;
initial baudrate <= 0;
//A framelength meghatározása, mert ez csak egy kombinációs hálózat 
assign frameLen=9+confBits[0]+confBits[2]+confBits[3]; //tényleges kiküldött hossz (9...12 bitszélesség)

//A MUX kiválasztó jeleinek számolása a konfigurációs regiszterek alapján
assign sel={confBits[0],confBits[2],confBits[3]};

//Parityx with assign
assign parity = (confBits[1]==0) ? ((confBits[0]==0) ? ^dataIn[6:0] : ^dataIn) : ((confBits[0]==0) ? ~^dataIn[6:0] : ~^dataIn) ;

// baudrate divider számolása
always @(confBits) begin
    case(confBits[6:4])
       3'b000:  divider <= 15'b110100000101011;//1200
       3'b001:  divider <= 15'b011010000010101;//2400
       3'b010:  divider <= 15'b001101000001011;//4800
       3'b011:  divider <= 15'b000110100000101;//9600
       3'b100:  divider <= 15'b000011010000011;//19200
       3'b101:  divider <= 15'b000001101000001;//38400
       3'b110:  divider <= 15'b000001000101100;//57600
       3'b111:  divider <= 15'b000000100010110;//115200
    endcase
end 

always@ (posedge(clk)) begin
    clkCntr <= clkCntr+1;
    
    if(clkCntr==((divider-1)))begin
        baudrate <= ~baudrate;
    end
    if(clkCntr==((divider)))begin
        baudrate <= ~baudrate;
        clkCntr <= 1; 
    end
end
//FRAME-ek eloállítása (12 bitszélesség)
    assign frame1={3'b111,1'b1,dataIn[6:0],1'b0};
    assign frame2={2'b11,2'b11,dataIn[6:0],1'b0};
    assign frame3={2'b11,1'b1,parity,dataIn[6:0],1'b0};
    assign frame4={1'b1,2'b11,parity,dataIn[6:0],1'b0};
    assign frame5={2'b11,1'b1,dataIn[7:0],1'b0};
    assign frame6={1'b1,2'b11,dataIn[7:0],1'b0};
    assign frame7={1'b1,1'b1,parity,dataIn[7:0],1'b0};
    assign frame8={2'b11,parity,dataIn[7:0],1'b0};

//MUX 8:1 //busy-t kivenni, és a frame-re frissüljön, muxout
always @(*) begin
   case (sel)
       3'b000:  muxOut <= frame1;
       3'b001:  muxOut <= frame2;
       3'b010:  muxOut <= frame3;
       3'b011:  muxOut <= frame4;
       3'b100:  muxOut <= frame5;
       3'b101:  muxOut <= frame6;
       3'b110:  muxOut <= frame7;
       3'b111:  muxOut <= frame8;
   endcase
end

//Baud-rate-et létrehozni, és az lesz az engedélyez?, startbitet nem kell rögtön küldeni
always @(posedge (clk)) begin
    if(baudrate == 1) begin
     // shift-regiszter    
        if(busy==0) begin
            if(dataReady==1) begin
                busy <= 1;
                temp <= muxOut;
                end
            else
                temp <= 12'b11111111111; // maradjon egy a temp, ha nincs elérhet? adat
        end
        
        if(busy==1) begin
            bitCntr <=bitCntr+1;
            dout <=temp[0];
            temp <={1'b1,temp[11:1]};
            if(bitCntr==(frameLen))begin
                bitCntr <=4'b0000;
                busy <=0;
                dout<=1;
            end       
        end    
    end
end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:08:38 09/18/2021 
// Design Name: 
// Module Name:    MBO_testpin 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MBO_testpin(
	input clk,	//A7
	input rst,	//A3
	input clk_alt, //B8 alternative clk
	
	input  RxD_Z, // P4
	output DE_Z, // N4
	output TxD_Z, //M4
	
	input  RxD_Y, // P7
	output DE_Y, // P6
	output TxD_Y, //M5
	
	input  RxD_X, // N10
	output DE_X, // N9
	output TxD_X, //N10
	
	input wire test, //P1
	
	input wire FL,	//N1
	
	output reg [5:0] AUX, //C6 B6 C5 B5 C4 B4
	output reg [7:0] A,		// j13 j14 h13 h12 g14 g13 f14 f13 (от старших к младшим)
	output reg [15:0] B,	// M1 L3 L2 L1 K3 J3 H3 H2 H1 G3 G1 F1 F2 F3 D1 D2
	 
	output reg miso_aux1, // N14
	output reg CS_aux1,		// N13
	output reg SCK_aux1,	//M13
	output reg mosi_aux1,	//M12
	
	output reg miso_aux2, // L14
	output reg CS_aux2,		// L13
	output reg SCK_aux2,	//J12
	output reg mosi_aux2,	//K14
	//HF_CLK_A	
	output L09_clk_p,	// D13(p)
	output L09_clk_n,	//D12(n)
	output L10_clk_p,	// G12(p), 
	output L10_clk_n,	// C14(n)
	//HF_CLK_B
	output L01_clk_p, //B2(p) B1(n)
	output L01_clk_n,
	output L02_clk_p,	//C3(p) C2(n)
	output L02_clk_n
	
    );

OBUFDS IBUFDS_L09(
	.O(L09_clk_p),
	.OB(L09_clk_n),
	.I(L09_clk)
);

OBUFDS IBUFDS_L10(
	.O(L10_clk_p),
	.OB(L10_clk_n),
	.I(L10_clk)
);

OBUFDS IBUFDS_L01(
	.O(L01_clk_p),
	.OB(L01_clk_n),
	.I(L01_clk)
);

OBUFDS IBUFDS_L02(
	.O(L02_clk_p),
	.OB(L02_clk_n),
	.I(L02_clk)
);
	
//reg L09_clk, L10_clk, L01_clk, L02_clk;
reg [1:0] counter_clk;
assign L02_clk = counter_clk[0];
assign L01_clk = counter_clk[0];
assign L10_clk = counter_clk[0];
assign L09_clk = counter_clk[0];

always @(posedge clk)counter_clk <= counter_clk +1;

reg reg_DE_Z;
reg reg_TxD_Z;

reg reg_DE_Y;
reg reg_TxD_Y;

reg reg_DE_X;
reg reg_TxD_X;

reg [7:0] X,Y,Z;
reg [15:0] counter;
//assign A=X;
reg X_send,Y_send,Z_send;

assign DE_X = reg_DE_X;
assign DE_Y = reg_DE_Y;
assign DE_Z = reg_DE_Z;

assign TxD_X = reg_TxD_X;
assign TxD_Y= reg_TxD_Y;
assign TxD_Z= reg_TxD_Z;

always @(posedge clk) begin 
	
	if (~rst) begin 
		
		X[0] <= RxD_X;
		Y[0] <= RxD_Y;
		Z[0] <= RxD_Z;
		
		X[7:1] <= X[6:0];
		Y[7:1] <= Y[6:0];
		Z[7:1] <= Z[6:0];
		
		if ( X[7]) X_send <=1;
		if ( Y[7]) Y_send <=1;
		if ( Z[7]) Z_send <=1;
		
		if ( X_send) begin 
			reg_DE_X <=1'b1;
			reg_TxD_X <= X[7];
		end
		
		if ( Y_send) begin 
			reg_DE_Y <=1'b1;
			reg_TxD_Y <= Y[7];
		end
		
		if ( Z_send) begin 
			reg_DE_Z <=1'b1;
			reg_TxD_Z <= Z[7];
		end
		
		A<=X;
	end
end

always @(posedge clk_alt) begin 
	if (FL | test) begin 
		AUX[5:0] <= Y[5:0];
		B[7:0] <= Z;
		B[15:8] <= Y;
	end
	else begin 
		counter <= counter +1;
		
		miso_aux1 <= counter [0];
		CS_aux1 <= counter [1]	;
		SCK_aux1 <= counter [2] ;
		mosi_aux1 <= counter [3];
		
		miso_aux2<= counter [4];
		CS_aux2 <= counter [5] ;
		SCK_aux2 <= counter [6];
		mosi_aux2<= counter [7];
	end
end

endmodule

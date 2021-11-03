`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:04 10/27/2021 
// Design Name: 
// Module Name:    mbo_top 
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
module mbo_top(
input wire	clk,
input wire	in_bo5_1,
input wire	in_bo5_2,
input wire	opros,
output reg	out,
//output reg [23:0] 	w2_reg1, w2_reg2
//output reg [15:0] 	w3_reg1, w3_reg2,
output reg [23:0] 	fake_out
//output reg [7:0]  	w1_reg1, w1_reg2, 
//output reg [7:0] 	cnt_data1, cnt_data2
    );

reg strob_data1, strob_data2;
reg [7:0] 	reg_data1, reg_data2;
reg [23:0] 	w2_reg1, w2_reg2; 
//reg [15:0] 	w3_reg1, w3_reg2; 
//reg [7:0]  	w1_reg1, w1_reg2; 
reg [7:0] 	cnt_data1=0, cnt_data2=0;
//reg [23:0] 	fake_out;
reg [63:0]         reg_out;

always @(posedge clk) begin
	reg_data1[7] <= in_bo5_1;
	reg_data1[6:0] <= reg_data1[7:1];
	
	reg_data2[7] <= in_bo5_2;
	reg_data2[6:0] <= reg_data2[7:1];
	
	if (cnt_data1 == 190) strob_data1 <= 0;
	else if (!reg_data1[7]) strob_data1 <= 1;
	
	if (cnt_data1 == 190) cnt_data1 <= 0;
	else if (strob_data1) cnt_data1 <= cnt_data1 + 1;
	
	case (cnt_data1)
		7: w2_reg1[23:16] <= reg_data1;
		70: w2_reg1 [15:08] <= reg_data1;
		140: w2_reg1 [07:00] <= reg_data1;
	endcase
	
	if (cnt_data2 == 190) strob_data2 <= 0;
	else if (!reg_data2[7]) strob_data2 <= 1;
	
	if (cnt_data2 == 190) cnt_data2 <= 0;
	else if (strob_data2) cnt_data2 <= cnt_data2 + 1;
	
	case (cnt_data2)
		7: w2_reg2[23:16] <= reg_data1;
		70: w2_reg2 [15:08] <= reg_data1;
		140: w2_reg2 [07:00] <= reg_data1;
	endcase
	
	fake_out <= w2_reg1 + w2_reg2;
	
	reg_out[0] <= fake_out[23];
	reg_out[63:1] <= reg_out[62:0];
	
	out <= reg_out[63]; 

end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:01:01 06/19/2017 
// Design Name: 
// Module Name:    Oct 
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
module oct_verilog(periodo_in, CLK_in, data_oct);	
	 
// Generador de señal cuadrada con la octava de la frecuencia introducida. La amplitud
// de la señal no es la máxima posible (la señal oscilará entre 12'b000000000000 y
// 12'b000011111111) para que cuando ésta se suma con la señal original del ADC no se genere
// overflow/saturación cada vez que se encuentren los picos de ambas señales

// Declaración de entradas
	input [31:0] periodo_in;
	input CLK_in;
	
// Declaración de salidas
	output [11:0] data_oct;	// Señal octavada que irá al DAC

	reg [7:0] osc = 8'b0;
	
// Parámetros del módulo
	integer clk_div_out = 0;	
	
//	Sintetización de la señal octavada
	always@(posedge CLK_in) begin
		if(periodo_in != 32'b0) begin
			if(clk_div_out == periodo_in) begin
				osc <= ~osc;
				clk_div_out <= 0;
			end
			else
				clk_div_out <= clk_div_out + 1;
		end
		else
			osc <= 12'b0;
	end
	
	assign data_oct = {4'b0,osc};

endmodule

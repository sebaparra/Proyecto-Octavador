`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:40 06/21/2017 
// Design Name: 
// Module Name:    sumador_verilog 
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
module sumador_verilog(original_in, octava_in, salida_total);

// Módulo encargado de convertir la señal de salida del ADC en un formato legible por el DAC y luego
// sumarla con la octava calculada anteriormente. La suma se realiza de tal forma que 
// en caso de existir overflow, se sature.

	input [13:0] original_in;	// Señal proveniente del ADC
	input [11:0] octava_in;	// Señal proveniente del módulo Oct
	output [11:0] salida_total;	// Suma de ambas señales que irá al DAC
	
	reg [11:0] original_dac = 0;	// Registro que guardará la señal original convertida a un formato legible por el DAC
	reg [12:0] salida_reg = 13'b0;	// Se crea un registro para la salida + 1 bit para chequear si hay overflow
	
	wire [11:0] data_dac;
	
	assign data_dac = original_in[13:2];	// Se trunca y se eliminan los 2 bits menos significativos										
	assign data_in_dac = data_dac + 12'b100000000000;	// Se suma el número más negativo en complemento de 2 como offset
	assign salida_total = {salida_reg[11],salida_reg[10],salida_reg[9],salida_reg[8],
									salida_reg[7],salida_reg[6],salida_reg[5], salida_reg[4],
									salida_reg[3],salida_reg[2], salida_reg[1], salida_reg[0]};
	
	
	always@(*) begin
		salida_reg = original_dac + octava_in;
		if(salida_reg[12] == 1) // Chequear overflow
			salida_reg=13'b1111111111111;	// Satura si hay overflow
	end

endmodule

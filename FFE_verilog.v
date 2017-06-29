`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:25 06/06/2017 
// Design Name: 
// Module Name:    ffe_verilog 
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
module ffe_verilog(CLK_IN, data_in, periodo);

// Módulo que detecta la frecuencia fundamental de una señal de 14 bits codificada
// en complemento de 2 mediante la detección de cambios de signo (cruces por cero)

	 
// Declaración de entradas
	input CLK_IN;	// Reloj de entrada
	input [13:0] data_in;	// Señal de entrada del adc (14 bits)
	
	
// Declaración de salidas
	output reg [31:0] periodo = 32'b0;	// Periodo fundamental de la señal de entrada expresado en ciclos de reloj
	
// Divisor de reloj
	integer contador = 0;	// Cuenta los ciclos de reloj entre cada cambio de signo
	
// Registros
	reg cruce_cero = 0;	// Indica si se ha detectado un cruce por cero en el pasado
	reg finish = 1;	// Determina si se ha finalizado el algoritmo
	reg past_sign = 0;	// Registro que guardará el signo del valor pasado de data_in
	
	
// Máquina de estados que detecta ceros consecutivos de data_in
	always@(posedge CLK_IN) begin
		if(finish == 0) begin
			if(data_in[13] != past_sign) begin	// Revisa si hubo un cambio de signo
				if(cruce_cero) begin	// Revisa si se ha detectado un cruce por cero anteriormente 
					cruce_cero <= 0;	// Se resetea el indicador de ceros
					contador <= contador + 1;	// Se actualiza el contador
					finish <= 1;	// Indica que se ha encontrado la frecuencia fundamental
				end
				else begin
					cruce_cero <= 1;	// Se actualiza el indicador
					past_sign <= data_in[13];	// Se actualiza el signo del valor pasado de data_in
				end
			end
			else begin
				if(cruce_cero)	
					contador <= contador + 1;	// Si ya se detectó un cruce por cero, se actualiza el contador de ciclos de reloj
			end
		end
		else begin
			past_sign <= data_in[13];	// Se actualiza el signo del valor pasado de data_in
			periodo <= contador * 2;	// Se guarda el periodo fundamental (la multiplicación por dos es fácil de sintetizar ya que es sólo un shift left) 
			contador <= 0;			// Se reinicia el contador
			finish <= 0;	// Se vuelve a iniciar el algoritmo
		end
	end
	
endmodule

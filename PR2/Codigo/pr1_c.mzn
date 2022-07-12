include "globals.mzn";
% Declaración de variables
float: importe;

  %Se pasa el importe a centimos
int: miImporte = round(importe*100);

  %Valor de las monedas en centimos
array [1..8] of int: monedas = [1, 2, 5, 10, 20, 50, 100, 200];

  %Array que almacena el número de cada tipo de monedas necesario
array [1..6] of var 0..2 : numMonedas;

  %Separar el importe en euros y centimos
int: importeEuros = miImporte div 100;
int: importeCentimos = miImporte - (importeEuros*100);

  %Calcular cantidad de monedas de 1€ y de 2€
int: num2 = importeEuros div 2;
int: num1 = importeEuros mod 2;


%Restricciones

  %La suma del número de monedas por cada tipo de moneda debe ser igual al importe
constraint sum(i in 1..6)(monedas[i]  *  numMonedas[i] ) == importeCentimos;

%solve satisfy;
solve minimize sum(numMonedas);

output["Número de  monedas de \(monedas[i]/100)€ = \(numMonedas[i]) \n" |i  in 1..6];
output["Número de  monedas de \(monedas[7]/100)€ = \(num1) \n"];
output["Número de  monedas de \(monedas[8]/100)€ = \(num2) \n"];
output["Número total de monedas: \(sum(numMonedas)+num2+num1)"];

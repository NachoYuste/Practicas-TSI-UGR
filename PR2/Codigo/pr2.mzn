include "globals.mzn";

%Inicialización de variables y constantes

set of int: numAsignaturas = 0..9;
set of int: dias = 1..5; set of int:  franjas = 1..6;

set of int: prof1 = 5..6; set of int: prof2 = 1..2; int: prof3 = 3; set of int: prof4 = 1..6;  %Horarios de profesores

array[dias, franjas] of var numAsignaturas: horario;

%Restricciones
constraint forall(i in dias)(horario[i, 4] == 0);  %Recreo

constraint (count(horario[1, prof1], 1, 2)  /\ count(horario[2, prof1], 1, 2) ) /\ (count(horario[3, prof1], 3, 2) /\ count(horario[4, prof1], 3, 2) );  %Asignaturas profesor 1
constraint(count(horario[1, prof2], 4, 2) /\ count(horario[2, prof2], 4, 2)) /\ (count(horario[4, prof2], 5, 2) /\ count(horario[5, prof2], 5, 2));      %Asignaturas profesor 2
constraint (horario[3,3] == 6 /\ horario[5,3] == 6)  /\ horario[1,3] == 9;   %Asignaturas profesor 3 
constraint count(horario[3,prof4], 8, 2)  /\ (count(horario[2, prof4], 7, 1)  /\ count(horario[5, prof4], 7, 1))  /\ count(horario, 2, 2)  ; %Asignaturas profesor 4

solve satisfy;


output[" -------------------------------------\n"];
output["|  L  |  M  |  X  |  J  |  V  | \n"];
output[" -------------------------------------\n"];
output[if i==4  then   "|  R  |  E  | CR |  E  |  O  |\n"
            else "| A\(horario[1, i]) | A\(horario[2, i]) | A\(horario[3, i]) | A\(horario[4, i]) | A\(horario[5, i]) |\n" endif |i in franjas]; 
output[" -------------------------------------\n"];
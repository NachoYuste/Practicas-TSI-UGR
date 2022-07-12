include "globals.mzn";
int: numeroNodos = 8;
int: numeroAristas = 28;

set of int: aristas = 1..numeroAristas;
set of int: nodos = 1..numeroNodos;
set of int: posiblesColores = 1..numeroNodos-1;

%Array que almacena los colores de cada aristas codificadas por numeros, es decir, cada numero corresponde a un color
array[aristas] of var posiblesColores: coloresAristas;

%Matriz con los datos que devuelve la función generadora de grafos
array[aristas,1..2] of nodos: grafo =[|7 , 4 |2 , 4 |3 , 8 |5 , 2 |7 , 2 |1 , 2 |7 , 1 |1 , 5 |6 , 3 |5 , 4 |6 , 4 |1 , 8 |1 , 3 |4 , 8 |1 , 8 |2 , 3 |4 , 5 |8 , 4 |4 , 7 |7 , 6 |2 , 7 |6 , 5 |5 , 7 |8 , 7 |4 , 6 |8 , 1 |6 , 1 |6 , 3 |];


%Las aristas estan codificadas de la siguiente forma
%las aristas van del nodo x al nodo y
%En este caso los nodos x estan almacenados en nodosX y los nodos y en nodosY
%Ejemplo la arista 4,5 se codifica de la forma grafo1[1] = 4 y grafo2[2] = 5

array[aristas] of var nodos: nodosX = grafo[aristas,1];
array[aristas] of var nodos: nodosY = grafo[aristas,2];




%se encuentran dos aristas con nodos parejos en caso en que las aristas se almacenan de la forma x,y - t,x = 3,4 5,3
constraint forall(ind1 in aristas, ind2 in ind1..numeroAristas)
           ( nodosX[ind1] = nodosY[ind2] /\ ind1!=ind2 /\ nodosY[ind1] != nodosX[ind2] -> coloresAristas[ind1] != coloresAristas[ind2] ) ;
constraint forall(ind1 in aristas, ind2 in ind1..numeroAristas) 
          ( nodosY[ind1] = nodosX[ind2] /\ ind1!=ind2 /\ nodosX[ind1] != nodosY[ind2] -> coloresAristas[ind1] != coloresAristas[ind2] );


%se encuentran dos aristas con nodos parejos en caso en que las aristas se almacenan de la forma x,y - x,t = 3,4 3,5
constraint forall(ind1 in aristas, ind2 in ind1..numeroAristas) 
           ( nodosX[ind1] = nodosX[ind2] /\ ind1!=ind2 /\ nodosY[ind1] != nodosY[ind2] -> coloresAristas[ind1] != coloresAristas[ind2] );

%se encuentran dos aristas con nodos parejos en caso en que las aristas se almacenan de la forma y,x - t,x = 4,3 1,3
constraint forall(ind1 in aristas, ind2 in ind1..numeroAristas) 
           ( nodosY[ind1] = nodosY[ind2] /\ ind1!=ind2 /\ nodosX[ind1] != nodosX[ind2] -> coloresAristas[ind1] != coloresAristas[ind2] );

%obtener la cantidad de diferentes variables en el array colorAristas
var int: numerocolores =  nvalue(coloresAristas);

%Se minimiza el numero de diferentes colores
solve minimize numerocolores;


output["El array es: "];
output[ "\(coloresAristas[ind]), " | ind in aristas];
output["\nEl numero de colores minimo es: \(numerocolores)" ];



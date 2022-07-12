include "globals.mzn";

%Inicialización de variables
enum personas = {Vasco, Catalan, Gallego, Navarro, Andaluz}; 
array [personas] of int: arrayPersonas = [1,2,3,4,5];

enum casas = {Roja, Verde, Blanca, Amarilla, Azul};     
array [casas] of int: arrayCasas = [1,2,3,4,5];

enum animales = {Perro, Caracol, Zorro, Caballo, Cebra};
array [animales] of int: arrayAnimales = [1,2,3,4,5];

enum trabajos = {Pintor, Escultor, Diplomatico, Violinista, Medico};  
array [trabajos] of int: arrayTrabajos = [1,2,3,4,5];

enum bebidas = {Te, Cafe, Leche, Zumo, Agua};    
array [bebidas] of int: arrayBebidas = [1,2,3,4,5];

array [1..5] of int: posicionCasas = [1,2,3,4,5]; %Posicion de las casas de izquierda a derecha

enum atributos = {C, A, T, B, P};  %Atributos ordenados igual que en la inicialización
array [atributos, personas] of var 1..5: gridAtributos;

%Restricciones

%Restricciones directas del enunciado
constraint gridAtributos[C, Vasco] == arrayCasas[Roja];              %a
constraint gridAtributos[A, Catalan] = arrayAnimales[Perro];     %b
constraint gridAtributos[T, Gallego] == arrayTrabajos[Pintor];    %c
constraint gridAtributos[B, Navarro] == arrayBebidas[Te];          %d
constraint gridAtributos[P, Andaluz] == 1;                                     %e


%Restricciones relativas
  %Un mismo atributo no puede aplicarse a dos personas
constraint forall(i in atributos)(all_different(gridAtributos[i, personas])); 

constraint forall(i in personas)((gridAtributos[C, i] == arrayCasas[Verde]) -> gridAtributos[B, i] == arrayBebidas[Cafe]);  %f
constraint forall(p1 in personas, p2 in personas)( (p1!=p2  /\
                            gridAtributos[C,p1] == arrayCasas[Verde] /\gridAtributos[C,p2] == arrayCasas[Blanca])
                        ->gridAtributos[P,p1] == (gridAtributos[P,p2]+1) );    %g

constraint forall(i in personas)( (gridAtributos[T, i] == arrayTrabajos[Escultor] ) -> gridAtributos[A,i] == arrayAnimales[Caracol]);  %h
constraint forall(i in personas)( (gridAtributos[T, i] == arrayTrabajos[Diplomatico] ) -> gridAtributos[C,i] == arrayCasas[Amarilla]);  %i
constraint forall(i in personas)( (gridAtributos[P, i]== posicionCasas[3] ) -> gridAtributos[B,i] == arrayBebidas[Leche]);  %j
constraint forall(i in personas)( (gridAtributos[C, i]== arrayCasas[Azul] ) -> gridAtributos[P,i] == (gridAtributos[P,Andaluz]+1));  %k
constraint forall(i in personas)( (gridAtributos[T, i]== arrayTrabajos[Violinista] ) -> gridAtributos[B,i] == arrayBebidas[Zumo]);  %l
constraint forall(p1 in personas, p2 in personas)( (p1!=p2  /\
                            gridAtributos[A,p1] == arrayAnimales[Zorro] /\ gridAtributos[T,p2] == arrayTrabajos[Medico])
                        ->( (gridAtributos[P,p1] == (gridAtributos[P,p2]+1)) \/ (gridAtributos[P,p1] == (gridAtributos[P,p2]-1) ) ) ); %m
constraint forall(p1 in personas, p2 in personas)( (p1!=p2  /\
                            gridAtributos[A,p1] == arrayAnimales[Caballo] /\ gridAtributos[T,p2] == arrayTrabajos[Diplomatico])
                        ->( (gridAtributos[P,p1] == (gridAtributos[P,p2]+1)) \/ (gridAtributos[P,p1] == (gridAtributos[P,p2]-1) ) ) ); %n

  %Restricciones para asegurar que en las dos anteriores funcionan correctamente
constraint forall(p in personas) ( (gridAtributos[A, p] == arrayAnimales[Caballo])  ->(gridAtributos[T,p] != arrayTrabajos[Diplomatico]));
constraint forall(p in personas) ( (gridAtributos[A, p] == arrayAnimales[Zorro])  ->(gridAtributos[T,p] != arrayTrabajos[Medico]));


solve satisfy;


output["\(personas[i]):\n\tCasa -> \(casas[gridAtributos[C, i]])\n\tTrabajo -> \(trabajos[gridAtributos[T,i]])\n\tAnimal -> \(animales[gridAtributos[A,i]])\n\tBebida -> \(bebidas[gridAtributos[B,i]])\n\tPosicion -> \(gridAtributos[P,i])\n" | i in personas];

output[ if fix(gridAtributos[A, i]) == 5 then "\nLa cebra la tiene el \(personas[i])\n" endif | i in personas];
output[ if fix(gridAtributos[B, i]) == 5 then "El \(personas[i]) bebe agua\n" endif | i in personas];















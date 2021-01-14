% Use this editor as a MiniZinc scratch book

int: Hini = 1;
int: Hfin = 2;
int: Duracion = 3;

int: Regalo = 1;
int: Tintoreria = 2;
int: Peluqueria = 3;
int: Paquete = 4;

int: Farmacia = 2;
int: Visita = 3;

int: Desplazamiento = 1;
int: vuelo = 20;

var 0..24: hSalidaAdan;
var 4..24: hSalidaEva;
var 0..24: hLlegadaAeropuerto;
var 0..24: hLlegadaCasaEva;
var 0..24: holgura;

array [1..4,1..3] of var 0..24:  adan;
array [1..3, 1..3] of var 0..24:  eva;

constraint adan[Regalo,Duracion]= 4;
constraint adan[Tintoreria,Duracion] = 1;
constraint adan[Peluqueria,Duracion] = 2;
constraint adan[Paquete,Duracion] = 1;

constraint eva[Regalo,Duracion] = 4;
%esta es dinamica Eva[farmacia][duracion] = 
constraint eva[Visita,Duracion] = 2;

%ADAN
%TINTORERIA
constraint (adan[Tintoreria, Hini] >= 0 /\  adan[Tintoreria, Hfin] <= 7 /\ adan[Tintoreria, Hfin] = adan[Tintoreria, Hini] + adan[Tintoreria, Duracion]) \/ (adan[Tintoreria, Hini] >= 14 /\  adan[Tintoreria, Hfin] <= 21 /\ adan[Tintoreria, Hfin] = adan[Tintoreria, Hini] + adan[Tintoreria, Duracion]);

%PELUQUERIA
constraint (adan[Peluqueria, Hini] >= 4 /\  adan[Peluqueria, Hfin] <= 9 /\ adan[Peluqueria, Hfin] = adan[Peluqueria, Hini] + adan[Peluqueria, Duracion]) \/ (adan[Peluqueria, Hini] >= 13 /\  adan[Peluqueria, Hfin] <= 21 /\ adan[Peluqueria, Hfin] = adan[Peluqueria, Hini] + adan[Peluqueria, Duracion]);





%PAQUETE
constraint (adan[Paquete, Hini] >= 8 /\  adan[Paquete, Hini] <= 14 /\ adan[Paquete, Hfin] = adan[Paquete, Hini] + adan[Paquete, Duracion]) \/ ( adan[Paquete, Hini] >= 16 /\  adan[Paquete, Hini] <= 23 /\ adan[Paquete, Hfin] = adan[Paquete, Hini] + adan[Paquete, Duracion]);
%EVA
%VISITA
constraint (eva[Visita, Hini] >= 4 /\  eva[Visita, Hfin] <= 9 /\ eva[Visita, Hfin] = eva[Visita, Hini] + eva[Visita, Duracion]) \/ (eva[Visita, Hini] >= 15 /\  eva[Visita, Hfin] <= 19 /\ eva[Visita, Hfin] = eva[Visita, Hini] + eva[Visita, Duracion]);
%Farmacia
constraint(
if eva[Farmacia,Hini] <= 14 then eva[Farmacia,Duracion] = 5 /\ eva[Farmacia,Hfin] = eva[Farmacia,Hini] + eva[Farmacia,Duracion] else eva[Farmacia,Duracion] = 4 /\ eva[Farmacia,Hfin] = eva[Farmacia,Hini] + eva[Farmacia,Duracion] endif 
);
%AMBOS
%REGALO
constraint (
adan[Regalo,Hini] = eva[Regalo,Hini] /\ adan[Regalo,Hfin] = eva[Regalo,Hfin] /\ adan[Regalo,Hfin] = adan[Regalo,Hini]+ adan[Regalo,Duracion] /\ adan[Regalo,Hini] >= 0 /\ adan[Regalo,Hini] <= 21
);

%Avion
constraint forall (i in 1..4, j in 1..4 where i!= j) (adan[i, Hfin]<= hLlegadaAeropuerto - Desplazamiento );

constraint hLlegadaAeropuerto < vuelo;
constraint holgura = vuelo -hLlegadaAeropuerto;

%Restricciones desplazamiento adan
constraint forall (i in 1..4, j in 1..4 where i!= j) (adan[i, Hini] >= adan[j, Hfin] + Desplazamiento \/ adan[i, Hini] <= adan[j, Hini] - Desplazamiento );

constraint forall (i in 1..4, j in 1..4 where i!= j) (adan[i, Hini] >= Desplazamiento + hSalidaAdan);

%Restricciones desplazamiento eva
constraint forall (i in 1..3, j in 1..3 where i!= j) (eva[i, Hini] >= eva[j, Hfin] + Desplazamiento \/ eva[i, Hini] <= eva[j, Hini] - Desplazamiento );

constraint forall (i in 1..3, j in 1..3 where i!= j) (eva[i, Hini] >= Desplazamiento + hSalidaEva);

constraint forall (i in 1..3, j in 1..3 where i!= j) (eva[i, Hfin]<= hLlegadaCasaEva - Desplazamiento );

solve satisfy;
%máxima holgura = 4
%solve maximize holgura;
%Eva llega pronto a casa = 17
%solve minimize hLlegadaCasaEva;
%Más tarde salir Adan = 3
%solve maximize hSalidaAdan;

%Eva acabe visita 4 horas antes de adan entre pelu Sí
%constraint eva[Visita,Hfin] + 4 <= adan[Peluqueria,Hini];
%Eva acabe visita 5 horas antes de adan entre pelu No
%constraint eva[Visita,Hfin] + 5 < adan[Peluqueria,Hini];

output ["Recordar que el momento 0 es 10:00 \nAdan\n Actividad Hini Hfin Duracion\nRegalo "]++
 [show(adan[1,j])++ if j =3 then "\n" else " " endif| j in 1..3]++ ["Tintoreria "] ++
 [show(adan[2,j])++ if j =3 then "\n" else " " endif| j in 1..3]++
 ["Peluquería "] ++
 [show(adan[3,j])++ if j =3 then "\n" else " " endif| j in 1..3]++
 ["Paquete "] ++
 [show(adan[4,j])++ if j =3 then "\n" else " " endif| j in 1..3]++ ["\n\nEva\nActividad Hini Hfin Duracion\nRegalo "] ++
 [show(eva[1,j])++ if j =3 then "\n" else " " endif| j in 1..3]++ ["Farmacia "] ++
 [show(eva[2,j])++ if j =3 then "\n" else " " endif| j in 1..3]++
 ["Visita "] ++
 [show(eva[3,j])++ if j =3 then "\n" else " " endif| j in 1..3]++
 ["\n\n Hora salida Adan = ", show(hSalidaAdan), "\n Hora salida Eva = ",show(hSalidaEva)]++
 ["\n\n Hora llegada Aeropuerto = ", show(hLlegadaAeropuerto)]++
 ["\n\n Hora Eva llega casa = ", show( hLlegadaCasaEva)]++
 ["\n\n Holgura entre llegar aeropuerto y vuelo = ", show( holgura)]
 
 ;
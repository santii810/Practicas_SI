/* Initial beliefs and rules */
//Nivel 3
////////Para usar el jugador 2 seria poner 2 en propietario////
propietario(1).
/////////////////////////////////////////////////////
celdasNeutras(0).
celdasRival(0).
puntosMejorPatron(0). 
maxCeldasNeutras(0).
maxCeldasRival(0).
////////////////////
igual(X,Y,X,Y).	
igualColor(X,Y,C,C):-datos(X,Y,C).
datos(X,Y,Color,Tipo,Prop):- tablero(celda(X,Y,Prop),ficha(Color,Tipo)).
datos(X,Y,Color):- tablero(celda(X,Y,_),ficha(Color,_)).


fichaEspecial(X,Y):-datos(X,Y,_,Tipo,_) & (Tipo = ct | Tipo = co | Tipo = gs | Tipo = ip).
//esObstaculo(X,Y):- tablero(celda(X,Y,_),obstacle) | tablero(celda(X,Y,_),e).
esObstaculo(X,Y):- tablero(celda(X,Y,_),obstacle).

jugada(none,none,none).
valorFicha(in,1).
valorFicha(ip,2).
valorFicha(gs,4).
valorFicha(co,6).
valorFicha(ct,8).
puntosPatron(0).
puntosMejorPatron(0).

hayPatron(X,Y,C,Nombre) :- (
						 (grupo3FilA(X,Y,C) & Nombre = grupo3FilA) | (grupo3FilB(X,Y,C) & Nombre = grupo3FilB) | (grupo3FilC(X,Y,C) & Nombre = grupo3FilC) |
						 (grupo3ColA(X,Y,C) & Nombre = grupo3ColA) | (grupo3ColB(X,Y,C) & Nombre = grupo3ColB) | (grupo3ColC(X,Y,C) & Nombre = grupo3ColC) |
						 Nombre = none
						 ).


//Agrupaciones de 3
grupo3FilA(X,Y,C) :- // #_#
	size(N) & X-1 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C).
grupo3FilB(X,Y,C) :- // _##
	size(N) & X+2 < N & datos(X,Y,C) & datos(X+1,Y,C) & datos(X+2,Y,C).
grupo3FilC(X,Y,C) :- // ##_
	size(N) & X-2 >= 0 & datos(X-2,Y,C) & datos(X-1,Y,C) & datos(X,Y,C).

grupo3ColA(X,Y,C) :- // #_# (ficha desde medio)
		size(N) & Y-1 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y,C) & datos(X,Y+1,C).
grupo3ColB(X,Y,C) :- // #_# (ficha desde medio)
		size(N) & Y+2 < N & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C).
grupo3ColC(X,Y,C) :- // #_# (ficha desde medio)
		size(N) & Y-2 >= 0 & datos(X,Y-2,C) & datos(X,Y-1,C) & datos(X,Y,C).


//Agrupaciones de 4
grupo4FilA(X,Y,C) :- // #_##
	size(N) & X-1 >= 0 & X+2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X+2,Y,C).
grupo4FilB(X,Y,C) :- // ##_#
	size(N) & X-2 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,C) & datos(X+1,Y,C).	
grupo4ColA(X,Y,C) :- // #_## (Vertical)
	size(N) & Y-1 >= 0 & Y+2 < N & datos(X,Y-1,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C).
grupo4ColB(X,Y,C) :- // ##_# (Vertical)
	size(N) & Y-2 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y-2,C) & datos(X,Y,C) & datos(X,Y+1,C).

//Cuadrado	
grupo4SquareA(X,Y,C) :- // hueco arriba-izquierda
	size(N) & X+1 < N & Y+1 < N & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X+1,Y+1,C).
grupo4SquareB(X,Y,C) :- // hueco arriba-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,C) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C).
grupo4SquareC(X,Y,C) :- // hueco abajo-izquierda
	size(N) & X+1 < N & Y-1 >= 0 & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X+1,Y-1,C).
grupo4SquareD(X,Y,C) :- // hueco abajo-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,C) & datos(X-1,Y,C) & datos(X,Y-1,C) & datos(X-1,Y-1,C).	

//Agrupación de 5
//##_##
grupo5Fil(X,Y,C) :- size(N) & X+2 < N & X-2 >= 0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,C) & datos(X-1,Y,C) & datos(X-2,Y,C).
//(Medio vertical)##_##
grupo5Col(X,Y,C) :- size(N) & Y+2 < N & Y-2 >= 0 & datos(X,Y+1,C) & datos(X,Y+2,C) & datos(X,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C).

//Agrupación 5 en T
grupo5TN(X,Y,C) :- size(N) & X-1 >=0 & X+1 < N & Y+2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C).
grupo5TI(X,Y,C) :- size(N) & X-1 >=0 & X+1 < N & Y-2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C).
grupo5TR(X,Y,C) :- size(N) & X-2 >=0 & Y+1 < N & Y-1 >=0 & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y-1,C).
grupo5TL(X,Y,C) :- size(N) & X+1 < N & Y+1 < N & Y-1 >=0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y-1,C).



direccion(0,"up").
direccion(1,"down").
direccion(2,"right").
direccion(3,"left").

movPrueba(Mov) :- Mov = moverDesdeEnDireccion(pos(1,0),"left").


randomMov(Mov):-
	size(Size) &
	.random(R1) & .random(R2) & .random(R3) & 
	direccion(4 * math.floor(R1), Dir) &
	Mov = moverDesdeEnDireccion(pos(math.floor(R2*Size) ,math.floor(R3 * Size)),Dir).

movPrueba(Mov) :- Mov = moverDesdeEnDireccion(pos(1,0),"left").
	
/* Initial goals */


/* Plans */

//Estrategia level 3
+!mejorJugada:size(N) & level(L) & L=3 & propietario(Prop)<-
	-+jugada(none,none,none);
	-+puntosMejorPatron(0); 
	-+maxCeldasNeutras(0);
	-+maxCeldasRival(0);

	!mirarCeldasRival;
	!mirarCeldasNeutras;
	//Celdas del territorio jugador o celdas neutras
	!mirarPorPuntos(Prop);
	!mirarPorPuntos(0);
	.

//Planes para cada uno de los casos de la estrategia
+!mirarCeldasRival:propietario(Own) <-
	.findall(tablero(celda(X,Y,Prop),ficha(C,T)),tablero(celda(X,Y,Prop),ficha(C,T)),Lista);
	for ( .member(tablero(celda(X1,Y1,O1),ficha(C1,T1)),Lista) ) {
		!ganarCeldasRival(X1,Y1);
	}.
+!mirarCeldasRival.

//Para ganar celdas comunes (miramos el patron que tenga mas celdas)
+!mirarCeldasNeutras:propietario(Own) & jugada(none,none,none) <- //Aqui llegara si no se registra una jugada de conquistar celdas rivales
	.findall(tablero(celda(X,Y,Own),ficha(C,T)),tablero(celda(X,Y,Own),ficha(C,T)),Lista);
	for ( .member(tablero(celda(X1,Y1,O1),ficha(C1,T1)),Lista) ) {
		!ganarCeldasNeutras(X1,Y1);
	}.
+!mirarCeldasNeutras.

//Miramos una jugada por puntos moviendo una celda neutral o una celda del jugador haciendo patrones en su terreno
+!mirarPorPuntos(Own):jugada(none,none,none) <- //Aqui llegara si no se registra una jugada de conquistar celdas neutrales
	.findall(tablero(celda(X,Y,Own),ficha(C,T)),tablero(celda(X,Y,Own),ficha(C,T)),Lista);
	for ( .member(tablero(celda(X1,Y1,O1),ficha(C1,T1)),Lista) ) {
		!comprobarDir(X1,Y1);
	}.
+!mirarPorPuntos(Own).

//////////////////////////////////////////////////Ganar celdas al rival///////////////////////////////////////////////////////////////////////////////////

+!ganarCeldasRival(X,Y): tablero(celda(X,Y,O),ficha(C,T)) <-
	!left(X,Y,"left",ganarRival);
	!up(X,Y,"up",ganarRival);
	!right(X,Y,"right",ganarRival);
	!down(X,Y,"down",ganarRival).
+!ganarCeldasRival(X,Y).

+!right(X,Y,D,Option):Option=ganarRival & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X+1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X+1,Y);
	!agrupacionCeldas(X+1,Y,C1,X,Y,D);
	!intercambio(X,Y,X+1,Y);
	.
+!right(X,Y,D,Option):Option=ganarRival.

+!left(X,Y,D,Option):Option=ganarRival& tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X-1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X-1,Y);
	!agrupacionCeldas(X-1,Y,C1,X,Y,D);
	!intercambio(X,Y,X-1,Y);
	.
+!left(X,Y,D,Option):Option=ganarRival.

+!down(X,Y,D,Option):Option=ganarRival & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y+1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y+1);
	!agrupacionCeldas(X,Y+1,C1,X,Y,D);
	!intercambio(X,Y,X,Y+1);
	.
+!down(X,Y,D,Option):Option=ganarRival.

+!up(X,Y,D,Option):Option=ganarRival & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y-1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y-1);
	!agrupacionCeldas(X,Y-1,C1,X,Y,D);
	!intercambio(X,Y-1,X,Y);
	.
+!up(X,Y,D,Option):Option=ganarRival.

//Comprobamos en todos los patrones el numero de celdas rivales para ganarle territorio	
+!agrupacionCeldas(X,Y,C,A,B,D) <-
	-+celdasRival(0);
	!grupo3FilA(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo3FilB(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo3FilC(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo3ColA(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo3ColB(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo3ColC(X,Y,C,A,B,D);

	-+celdasRival(0);
	!grupo5TN(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo5TI(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo5TR(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo5TL(X,Y,C,A,B,D);

	-+celdasRival(0);
	!grupo5Fil(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo5Col(X,Y,C,A,B,D);

	-+celdasRival(0);
	!grupo4FilA(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4FilB(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4ColA(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4ColB(X,Y,C,A,B,D);

	-+celdasRival(0);
	!grupo4SquareA(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4SquareB(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4SquareC(X,Y,C,A,B,D);
	-+celdasRival(0);
	!grupo4SquareD(X,Y,C,A,B,D);
	.
+!agrupacionCeldas(X,Y,C,A,B,D).

//Agrupacion de T
+!grupo5TN(X,Y,C,A,B,D):grupo5TN(X,Y,C) <- 
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y+2);
	!mejorPatronRival(A,B,D).
+!grupo5TN(X,Y,C,A,B,D).

+!grupo5TI(X,Y,C,A,B,D):grupo5TI(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y-2);
	!mejorPatronRival(A,B,D).
+!grupo5TI(X,Y,C,A,B,D).

+!grupo5TR(X,Y,C,A,B,D):grupo5TR(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X-2,Y);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y-1);
	!mejorPatronRival(A,B,D).
+!grupo5TR(X,Y,C,A,B,D).

+!grupo5TL(X,Y,C,A,B,D):grupo5TL(X,Y,C) <-
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X+2,Y);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y-1);
	!mejorPatronRival(A,B,D).
+!grupo5TL(X,Y,C,A,B,D).

//Agrupacion de 5
+!grupo5Fil(X,Y,C,A,B,D):grupo5Fil(X,Y,C) <-
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X+2,Y);
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X-2,Y);
	!mejorPatronRival(A,B,D).
+!grupo5Fil(X,Y,C,A,B,D).

+!grupo5Col(X,Y,C,A,B,D):grupo5Col(X,Y,C) <-
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y+2);
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y-2);
	!mejorPatronRival(A,B,D).
+!grupo5Col(X,Y,C,A,B,D).

//Agrupacion de 4
+!grupo4FilA(X,Y,C,A,B,D):grupo4FilA(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X+2,Y);
	!mejorPatronRival(A,B,D).
+!grupo4FilA(X,Y,C,A,B,D).

+!grupo4FilB(X,Y,C,A,B,D):grupo4FilB(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X-2,Y);
	!calcularCeldas(X+1,Y);
	!mejorPatronRival(A,B,D).
+!grupo4FilB(X,Y,C,A,B,D).

+!grupo4ColA(X,Y,C,A,B,D):grupo4ColA(X,Y,C) <-
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y+2);
	!mejorPatronRival(A,B,D).
+!grupo4ColA(X,Y,C,A,B,D).

+!grupo4ColB(X,Y,C,A,B,D):grupo4ColB(X,Y,C) <-
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y-2);
	!calcularCeldas(X,Y+1);
	!mejorPatronRival(A,B,D).
+!grupo4ColB(X,Y,C,A,B,D).

//Agrupacion cuadrado
+!grupo4SquareA(X,Y,C,A,B,D):grupo4SquareA(X,Y,C) <-
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X+1,Y+1);
	!mejorPatronRival(A,B,D).
+!grupo4SquareA(X,Y,C,A,B,D).

+!grupo4SquareB(X,Y,C,A,B,D):grupo4SquareB(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X-1,Y+1);
	!mejorPatronRival(A,B,D).
+!grupo4SquareB(X,Y,C,A,B,D).

+!grupo4SquareC(X,Y,C,A,B,D):grupo4SquareC(X,Y,C) <-
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X+1,Y-1);
	!mejorPatronRival(A,B,D).
+!grupo4SquareC(X,Y,C,A,B,D).

+!grupo4SquareD(X,Y,C,A,B,D):grupo4SquareD(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X-1,Y-1);
	!mejorPatronRival(A,B,D).
+!grupo4SquareD(X,Y,C,A,B,D).

//Agrupacion de 3
+!grupo3FilA(X,Y,C,A,B,D):grupo3FilA(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X+1,Y);
	!mejorPatronRival(A,B,D).
+!grupo3FilA(X,Y,C,A,B,D).

+!grupo3FilB(X,Y,C,A,B,D):grupo3FilB(X,Y,C) <-
	!calcularCeldas(X+1,Y);
	!calcularCeldas(X+2,Y);
	!mejorPatronRival(A,B,D).
+!grupo3FilB(X,Y,C,A,B,D).

+!grupo3FilC(X,Y,C,A,B,D):grupo3FilC(X,Y,C) <-
	!calcularCeldas(X-1,Y);
	!calcularCeldas(X-2,Y);
	!mejorPatronRival(A,B,D).
+!grupo3FilC(X,Y,C,A,B,D).

+!grupo3ColA(X,Y,C,A,B,D):grupo3ColA(X,Y,C) <-
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y+1);
	!mejorPatronRival(A,B,D).
+!grupo3ColA(X,Y,C,A,B,D).

+!grupo3ColB(X,Y,C,A,B,D):grupo3ColB(X,Y,C) <-
	!calcularCeldas(X,Y+1);
	!calcularCeldas(X,Y+2);
	!mejorPatronRival(A,B,D).
+!grupo3ColB(X,Y,C,A,B,D).

+!grupo3ColC(X,Y,C,A,B,D):grupo3ColC(X,Y,C) <-
	!calcularCeldas(X,Y-1);
	!calcularCeldas(X,Y-2);
	!mejorPatronRival(A,B,D).
+!grupo3ColC(X,Y,C,A,B,D).

+!calcularCeldas(X,Y): tablero(celda(X,Y,Own),ficha(C,T)) & celdasRival(Celdas) & rival(Own) <-
	-+celdasRival(Celdas+1).
+!calcularCeldas(X,Y).

+!mejorPatronRival(X,Y,D) : celdasRival(P1) & maxCeldasRival(P2) & P1 > P2 <-
	-+maxCeldasRival(P1);
	-+jugada(X,Y,D);
	-+celdasRival(0);
	.
+!mejorPatronRival(X,Y,D) : celdasRival(P1) & maxCeldasRival(P2) & P1 <= P2.
	
+!mejorPatronRival(X,Y,D).
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////Ganar celdas neutras///////////////////////////////////////////////////////////////////////////////
//Caso que ganemos territorio neutro
+!ganarCeldasNeutras(X,Y): tablero(celda(X,Y,O),ficha(C,T)) <-
	-+celdasNeutras(0);
	!left(X,Y,"left",ganarNeutral);
	-+celdasNeutras(0);
	!up(X,Y,"up",ganarNeutral);
	-+celdasNeutras(0);
	!right(X,Y,"right",ganarNeutral);
	-+celdasNeutras(0);
	!down(X,Y,"down",ganarNeutral).
+!ganarCeldasNeutras(X,Y).

+!right(X,Y,D,Option):Option=ganarNeutral & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X+1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X+1,Y);
	!mayorNeutral(X+1,Y,C1,X,Y,D);
	!intercambio(X,Y,X+1,Y);
	.
+!right(X,Y,D,Option):Option=ganarNeutral.

+!left(X,Y,D,Option):Option=ganarNeutral & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X-1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X-1,Y);
	!mayorNeutral(X-1,Y,C1,X,Y,D);
	!intercambio(X,Y,X-1,Y);
	.
+!left(X,Y,D,Option):Option=ganarNeutral.

+!down(X,Y,D,Option):Option=ganarNeutral & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y+1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y+1);
	!mayorNeutral(X,Y+1,C1,X,Y,D);
	!intercambio(X,Y,X,Y+1);
	.
+!down(X,Y,D,Option):Option=ganarNeutral.

+!up(X,Y,D,Option):Option=ganarNeutral & tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y-1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y-1);
	!mayorNeutral(X,Y-1,C1,X,Y,D);
	!intercambio(X,Y-1,X,Y);
	.
+!up(X,Y,D,Option):Option=ganarNeutral.

+!mayorNeutral(X,Y,C,A,B,D) <-
	-+celdasNeutras(0);
	!grupo3FilA2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo3FilB2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo3FilC2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo3ColA2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo3ColB2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo3ColC2(X,Y,C,A,B,D);

	-+celdasNeutras(0);
	!grupo5TN2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo5TI2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo5TR2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo5TL2(X,Y,C,A,B,D);

	-+celdasNeutras(0);
	!grupo5Fil2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo5Col2(X,Y,C,A,B,D);

	-+celdasNeutras(0);
	!grupo4FilA2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4FilB2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4ColA2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4ColB2(X,Y,C,A,B,D);

	-+celdasNeutras(0);
	!grupo4SquareA2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4SquareB2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4SquareC2(X,Y,C,A,B,D);
	-+celdasNeutras(0);
	!grupo4SquareD2(X,Y,C,A,B,D);
	.


//Agrupacion de T
+!grupo5TN2(X,Y,C,A,B,D):grupo5TN(X,Y,C) <- 
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y+2);
	!mejorPatronNeutro(A,B,D).
+!grupo5TN2(X,Y,C,A,B,D).

+!grupo5TI2(X,Y,C,A,B,D):grupo5TI(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y-2);
	!mejorPatronNeutro(A,B,D).
+!grupo5TI2(X,Y,C,A,B,D).

+!grupo5TR2(X,Y,C,A,B,D):grupo5TR(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X-2,Y);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y-1);
	!mejorPatronNeutro(A,B,D).
+!grupo5TR2(X,Y,C,A,B,D).

+!grupo5TL2(X,Y,C,A,B,D):grupo5TL(X,Y,C) <-
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X+2,Y);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y-1);
	!mejorPatronNeutro(A,B,D).
+!grupo5TL2(X,Y,C,A,B,D).

//Agrupacion de 5
+!grupo5Fil2(X,Y,C,A,B,D):grupo5Fil(X,Y,C) <-
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X+2,Y);
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X-2,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo5Fil2(X,Y,C,A,B,D).

+!grupo5Col2(X,Y,C,A,B,D):grupo5Col(X,Y,C) <-
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y+2);
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y-2);
	!mejorPatronNeutro(A,B,D).
+!grupo5Col2(X,Y,C,A,B,D).

//Agrupacion de 4
+!grupo4FilA2(X,Y,C,A,B,D):grupo4FilA(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X+2,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo4FilA2(X,Y,C,A,B,D).

+!grupo4FilB2(X,Y,C,A,B,D):grupo4FilB(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X-2,Y);
	!calcularCeldasNeutras(X+1,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo4FilB2(X,Y,C,A,B,D).

+!grupo4ColA2(X,Y,C,A,B,D):grupo4ColA(X,Y,C) <-
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y+2);
	!mejorPatronNeutro(A,B,D).
+!grupo4ColA2(X,Y,C,A,B,D).

+!grupo4ColB2(X,Y,C,A,B,D):grupo4ColB(X,Y,C) <-
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y-2);
	!calcularCeldasNeutras(X,Y+1);
	!mejorPatronNeutro(A,B,D).
+!grupo4ColB2(X,Y,C,A,B,D).

//Agrupacion cuadrado
+!grupo4SquareA2(X,Y,C,A,B,D):grupo4SquareA(X,Y,C) <-
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X+1,Y+1);
	!mejorPatronNeutro(A,B,D).
+!grupo4SquareA2(X,Y,C,A,B,D).

+!grupo4SquareB2(X,Y,C,A,B,D):grupo4SquareB(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X-1,Y+1);
	!mejorPatronNeutro(A,B,D).
+!grupo4SquareB2(X,Y,C,A,B,D).

+!grupo4SquareC2(X,Y,C,A,B,D):grupo4SquareC(X,Y,C) <-
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X+1,Y-1);
	!mejorPatronNeutro(A,B,D).
+!grupo4SquareC2(X,Y,C,A,B,D).

+!grupo4SquareD2(X,Y,C,A,B,D):grupo4SquareD(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X-1,Y-1);
	!mejorPatronNeutro(A,B,D).
+!grupo4SquareD2(X,Y,C,A,B,D).


//Agrupacion de 3
+!grupo3FilA2(X,Y,C,A,B,D):grupo3FilA(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X+1,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo3FilA2(X,Y,C,A,B,D).

+!grupo3FilB2(X,Y,C,A,B,D):grupo3FilB(X,Y,C) <-
	!calcularCeldasNeutras(X+1,Y);
	!calcularCeldasNeutras(X+2,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo3FilB2(X,Y,C,A,B,D).

+!grupo3FilC2(X,Y,C,A,B,D):grupo3FilC(X,Y,C) <-
	!calcularCeldasNeutras(X-1,Y);
	!calcularCeldasNeutras(X-2,Y);
	!mejorPatronNeutro(A,B,D).
+!grupo3FilC2(X,Y,C,A,B,D).

+!grupo3ColA2(X,Y,C,A,B,D):grupo3ColA(X,Y,C) <-
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y+1);
	!mejorPatronNeutro(A,B,D).
+!grupo3ColA2(X,Y,C,A,B,D).

+!grupo3ColB2(X,Y,C,A,B,D):grupo3ColB(X,Y,C) <-
	!calcularCeldasNeutras(X,Y+1);
	!calcularCeldasNeutras(X,Y+2);
	!mejorPatronNeutro(A,B,D).
+!grupo3ColB2(X,Y,C,A,B,D).

+!grupo3ColC2(X,Y,C,A,B,D):grupo3ColC(X,Y,C) <-
	!calcularCeldasNeutras(X,Y-1);
	!calcularCeldasNeutras(X,Y-2);
	!mejorPatronNeutro(A,B,D).
+!grupo3ColC2(X,Y,C,A,B,D).



+!calcularCeldasNeutras(X,Y): tablero(celda(X,Y,0),ficha(C,T)) & celdasNeutras(Celdas) <-
	-+maxCeldasNeutras(Celdas+1).
+!calcularCeldasNeutras(X,Y).

+!mejorPatronNeutro(X,Y,D) : celdasNeutras(P1) & maxCeldasNeutras(P2) & P1 > P2 <-
	-+maxCeldasNeutras(P1);
	-+jugada(X,Y,D);
	-+celdasNeutras(0);
	.
+!mejorPatronNeutro(X,Y,D) : celdasNeutras(P1) & maxCeldasNeutras(P2) & P1 <= P2.
	
+!mejorPatronNeutro(X,Y,D).
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//Estrategia para level 1 y 2
+!mejorJugada:size(N) <-
	-+jugada(none,none,none);
	-+puntosMejorPatron(0); 
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			if(datos(X,Y,C)){
				!comprobarDir(X,Y);
			}
		}
	}.

//comprobar en las 4 direciones
+!comprobarDir(X,Y) <-
	-+puntosPatron(0);
	!left(X,Y,"left");
	-+puntosPatron(0);
	!up(X,Y,"up");
	-+puntosPatron(0);
	!right(X,Y,"right");
	-+puntosPatron(0);
	!down(X,Y,"down");
	.

+!right(X,Y,D): tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X+1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X+1,Y);
	!agrupacion(X+1,Y,C,X,Y,D);
	!intercambio(X,Y,X+1,Y);
	.
+!right(X,Y,D).

+!left(X,Y,D): tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X-1,Y,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X-1,Y);
	!agrupacion(X-1,Y,C,X,Y,D);
	!intercambio(X,Y,X-1,Y);
	.
+!left(X,Y,D).

+!down(X,Y,D): tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y+1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y+1);
	!agrupacion(X,Y+1,C,X,Y,D);
	!intercambio(X,Y,X,Y+1);
	.
+!down(X,Y,D).

+!up(X,Y,D): tablero(celda(X,Y,O1),ficha(C1,T1)) & tablero(celda(X,Y-1,O2),ficha(C2,T2)) <-	
	!intercambio(X,Y,X,Y-1);
	!agrupacion(X,Y-1,C,X,Y,D);
	!intercambio(X,Y-1,X,Y);
	.
+!up(X,Y,D).

+!intercambio(X1,Y1,X2,Y2) : tablero(celda(X1,Y1,O1),ficha(C1,T1)) & tablero(celda(X2,Y2,O2),ficha(C2,T2)) <-
	-tablero(celda(X1,Y1,O1),ficha(C1,T1));
	-tablero(celda(X2,Y2,O2),ficha(C2,T2));
	+tablero(celda(X1,Y1,O2),ficha(C2,T2));
	+tablero(celda(X2,Y2,O1),ficha(C1,T1)).
+!intercambio(X1,Y1,X2,Y2).


 +!agrupacion(X,Y,C,A,B,D) <-
 	-+puntosPatron(0);
	!grupo3FilA1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo3FilB1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo3FilC1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo3ColA1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo3ColB1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo3ColC1(X,Y,C,A,B,D);

	-+puntosPatron(0);
	!grupo5TN1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo5TI1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo5TR1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo5TL1(X,Y,C,A,B,D);

	-+puntosPatron(0);
	!grupo5Fil1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo5Col1(X,Y,C,A,B,D);

	-+puntosPatron(0);
	!grupo4FilA1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4FilB1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4ColA1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4ColB1(X,Y,C,A,B,D);

	-+puntosPatron(0);
	!grupo4SquareA1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4SquareB1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4SquareC1(X,Y,C,A,B,D);
	-+puntosPatron(0);
	!grupo4SquareD1(X,Y,C,A,B,D);
 .


//Agrupacion de T
+!grupo5TN1(X,Y,C,A,B,D):grupo5TN(X,Y,C) <- 
	-+puntosPatron(6);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y+2);
	!comprobarMejorPatron(A,B,D).
+!grupo5TN1(X,Y,C,A,B,D).

+!grupo5TI1(X,Y,C,A,B,D):grupo5TI(X,Y,C) <-
	-+puntosPatron(6);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y-2);
	!comprobarMejorPatron(A,B,D).
+!grupo5TI1(X,Y,C,A,B,D).

+!grupo5TR1(X,Y,C,A,B,D):grupo5TR(X,Y,C) <-
	-+puntosPatron(6);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X-2,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y-1);
	!comprobarMejorPatron(A,B,D).
+!grupo5TR1(X,Y,C,A,B,D).

+!grupo5TL1(X,Y,C,A,B,D):grupo5TL(X,Y,C) <-
	-+puntosPatron(6);
	!calcularPuntos(X,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X+2,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y-1);
	!comprobarMejorPatron(A,B,D).
+!grupo5TL1(X,Y,C,A,B,D).

//Agrupacion de 5
+!grupo5Fil1(X,Y,C,A,B,D):grupo5Fil(X,Y,C) <-
	-+puntosPatron(8);
	!calcularPuntos(X,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X+2,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X-2,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo5Fil1(X,Y,C,A,B,D).

+!grupo5Col1(X,Y,C,A,B,D):grupo5Col(X,Y,C) <-
	-+puntosPatron(8);
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y+2);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y-2);
	!comprobarMejorPatron(A,B,D).
+!grupo5Col1(X,Y,C,A,B,D).

//Agrupacion de 4
+!grupo4FilA1(X,Y,C,A,B,D):grupo4FilA(X,Y,C) <-
	-+puntosPatron(2);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X+2,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo4FilA1(X,Y,C,A,B,D).

+!grupo4FilB1(X,Y,C,A,B,D):grupo4FilB(X,Y,C) <-
	-+puntosPatron(2);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X-2,Y);
	!calcularPuntos(X+1,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo4FilB1(X,Y,C,A,B,D).

+!grupo4ColA1(X,Y,C,A,B,D):grupo4ColA(X,Y,C) <-
	-+puntosPatron(2);
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y+2);
	!comprobarMejorPatron(A,B,D).
+!grupo4ColA1(X,Y,C,A,B,D).

+!grupo4ColB1(X,Y,C,A,B,D):grupo4ColB(X,Y,C) <-
	-+puntosPatron(2);
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y-2);
	!calcularPuntos(X,Y+1);
	!comprobarMejorPatron(A,B,D).
+!grupo4ColB1(X,Y,C,A,B,D).

//Agrupacion cuadrado
+!grupo4SquareA1(X,Y,C,A,B,D):grupo4SquareA(X,Y,C) <-
	-+puntosPatron(4);
	!calcularPuntos(X,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X+1,Y+1);
	!comprobarMejorPatron(A,B,D).
+!grupo4SquareA1(X,Y,C,A,B,D).

+!grupo4SquareB1(X,Y,C,A,B,D):grupo4SquareB(X,Y,C) <-
	-+puntosPatron(4);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X-1,Y+1);
	!comprobarMejorPatron(A,B,D).
+!grupo4SquareB1(X,Y,C,A,B,D).

+!grupo4SquareC1(X,Y,C,A,B,D):grupo4SquareC(X,Y,C) <-
	-+puntosPatron(4);
	!calcularPuntos(X,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X+1,Y-1);
	!comprobarMejorPatron(A,B,D).
+!grupo4SquareC1(X,Y,C,A,B,D).

+!grupo4SquareD1(X,Y,C,A,B,D):grupo4SquareD(X,Y,C) <-
	-+puntosPatron(4);
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X-1,Y-1);
	!comprobarMejorPatron(A,B,D).
+!grupo4SquareD1(X,Y,C,A,B,D).

//Agrupacion de 3
+!grupo3FilA1(X,Y,C,A,B,D):grupo3FilA(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X+1,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo3FilA1(X,Y,C,A,B,D).

+!grupo3FilB1(X,Y,C,A,B,D):grupo3FilB(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X+1,Y);
	!calcularPuntos(X+2,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo3FilB1(X,Y,C,A,B,D).

+!grupo3FilC1(X,Y,C,A,B,D):grupo3FilC(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X-1,Y);
	!calcularPuntos(X-2,Y);
	!comprobarMejorPatron(A,B,D).
+!grupo3FilC1(X,Y,C,A,B,D).

+!grupo3ColA1(X,Y,C,A,B,D):grupo3ColA(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y+1);
	!comprobarMejorPatron(A,B,D).
+!grupo3ColA1(X,Y,C,A,B,D).

+!grupo3ColB1(X,Y,C,A,B,D):grupo3ColB(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y+1);
	!calcularPuntos(X,Y+2);
	!comprobarMejorPatron(A,B,D).
+!grupo3ColB1(X,Y,C,A,B,D).

+!grupo3ColC1(X,Y,C,A,B,D):grupo3ColC(X,Y,C) <-
	!calcularPuntos(X,Y);
	!calcularPuntos(X,Y-1);
	!calcularPuntos(X,Y-2);
	!comprobarMejorPatron(A,B,D).
+!grupo3ColC1(X,Y,C,A,B,D).	

+!comprobarMejorPatron(X,Y,D) : puntosPatron(P1) & puntosMejorPatron(P2) & P1 > P2 <-
	-+puntosMejorPatron(P1);
	-+jugada(X,Y,D);
	-+puntosPatron(0);
	.
+!comprobarMejorPatron(X,Y,D) : puntosPatron(P1) & puntosMejorPatron(P2) & P1 <= P2.
	
+!comprobarMejorPatron(X,Y,D).
	
//Grupo de 5
+!calcularPuntos(X,Y): tablero(celda(X,Y,_),ficha(_,T)) & puntosPatron(Puntos) & valorFicha(T,Valor) <-
	-+puntosPatron(Puntos+Valor).



//Comienzo del turno
+puedesMover[source(judge)] <- 
	!mejorJugada;
	!realizarMovimiento.


//Realizacion de la jugada
+!realizarMovimiento : jugada(X,Y,D) & not X=none & not Y=none & not D=none <-				
	.print("Intentando mover desde la posicion (",X,",",Y,") en direccion ",D);
	.wait(2000);
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),D));
	.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),D)).

//Realizacion de la jugada random
+!realizarMovimiento : randomMov(Mov) <-				
	.print("Movimiento random");
	.print("Intentando mover desde la posicion (",X,",",Y,") en direccion ",D);
	.wait(20);
	.send(judge,tell,Mov);
	.send(judge,untell,Mov).

//Movimiento realizado correctamente
+valido[source(judge)] <- 
	.print("Movimiento correcto realizado").


//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- 
	!realizarMovimiento.

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <-
	!realizarMovimiento.

+invalido(fueraTablero,N)[source(judge)] : N>3 <-
	.send(judge,tell,pasoTurno);
	.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)].

+tablero(Celda,Ficha)[source(judge)] <-  
	-tablero(Celda,Ficha)[source(judge)];
	+tablero(Celda,Ficha).

+deleteTableroBB [source(judge)]<-
	.abolish(tablero(X,Y)).

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) <- 
	.print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


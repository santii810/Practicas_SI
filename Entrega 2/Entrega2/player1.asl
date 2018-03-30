// Agent player in project ESEI_SAGA.mas2j
//Roi Pérez López, Martín Puga Egea
/* Initial beliefs and rules */
igual(X,Y,X,Y).	
igualColor(X,Y,C,C):-datos(X,Y,C).
//Agrupaciones de 3
grupo3Fil(X,Y,C,A,B) :- // #_#
	size(N) & X-1 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B).
grupo3Col(X,Y,C,A,B) :- // #_# (ficha desde medio)
	size(N) & Y-1 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B).


		
//Agrupaciones de 4
grupo4FilA(X,Y,C,A,B) :- // #_##
	size(N) & X-1 >= 0 & X+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X+2,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B).
grupo4FilB(X,Y,C,A,B) :- // ##_#
	size(N) & X-2 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X+1,Y,A,B).	
grupo4ColA(X,Y,C,A,B) :- // #_## (Vertical)
	size(N) & Y-1 >= 0 & Y+2 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B).
grupo4ColB(X,Y,C,A,B) :- // ##_# (Vertical)
	size(N) & Y-2 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y-2,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) & not igual(X,Y+1,A,B).

//Cuadrado	
grupo4SquareA(X,Y,C,A,B) :- // hueco arriba-izquierda
	size(N) & X+1 < N & Y+1 < N & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X+1,Y+1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X+1,Y+1,A,B).
grupo4SquareB(X,Y,C,A,B) :- // hueco arriba-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X-1,Y+1,A,B).
grupo4SquareC(X,Y,C,A,B) :- // hueco abajo-izquierda
	size(N) & X+1 < N & Y-1 >= 0 & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X+1,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X+1,Y-1,A,B).
grupo4SquareD(X,Y,C,A,B) :- // hueco abajo-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y-1,C) & datos(X-1,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X-1,Y+1,A,B).	

//AgrupaciÃ³n de 5
//##_##
grupo5Fil(X,Y,C,A,B) :- size(N) & X+2 < N & X-2 >= 0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X-1,Y,C) & datos(X-2,Y,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B).
//(Medio vertical)##_##
grupo5Col(X,Y,C,A,B) :- size(N) & Y+2 < N & Y-2 >= 0 & datos(X,Y+1,C) & datos(X,Y+2,C) & datos(X,Y,_) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B).

//AgrupaciÃ³n 5 en T
grupo5TN(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B).
grupo5TI(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y-2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B).
grupo5TR(X,Y,C,A,B) :- size(N) & X-2 >=0 & Y+1 < N & Y-1 >=0 & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B).
grupo5TL(X,Y,C,A,B) :- size(N) & X+1 < N & Y+1 < N & Y-1 >=0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B).

//Para elegir la agrupacion prioritaria
grupo3(X,Y,C,A,B):- grupo3Fil(X,Y,C,A,B) | grupo3Col(X,Y,C,A,B).	
grupo4(X,Y,C,A,B):- grupo4FilA(X,Y,C,A,B) | grupo4FilB(X,Y,C,A,B) | grupo4ColA(X,Y,C,A,B) | grupo4ColB(X,Y,C,A,B).
grupoCuadrado(X,Y,C,A,B):- grupo4SquareA(X,Y,C,A,B) | grupo4SquareB(X,Y,C,A,B) | grupo4SquareC(X,Y,C,A,B) | grupo4SquareD(X,Y,C,A,B).
grupoT(X,Y,C,A,B):- grupo5TN(X,Y,C,A,B) | grupo5TI(X,Y,C,A,B) | grupo5TR(X,Y,C,A,B) | grupo5TL(X,Y,C,A,B).
grupo5(X,Y,C,A,B):- grupo5Fil(X,Y,C,A,B) | grupo5Col(X,Y,C,A,B).


datos(X,Y,Color):- tablero(celda(X,Y,_),ficha(Color,_)).

direccion(0,"up").
direccion(1,"down").
direccion(2,"right").
direccion(3,"left").


randomMov(Mov):-
	size(Size) &
	.random(R1) & .random(R2) & .random(R3) & 
	direccion(4 * math.floor(R1), Dir) &
	Mov = moverDesdeEnDireccion(pos(math.floor(R2*Size) ,math.floor(R3 * Size)),Dir).

movPrueba(Mov) :- Mov = moverDesdeEnDireccion(pos(1,0),"left").
	
/* Initial goals */


/* Plans */

+buscarMejorJugada:size(N) <-
	-buscarMejorJugada;
	//-grupo5(_,_,_);-grupoT(_,_,_);-grupoCuadrado(_,_,_);-grupo4(_,_,_);-grupo3(_,_,_);
	+borrarBusqueda;
	-borrarBusqueda;
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			if(datos(X,Y,C)){
				if(grupo5(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C)){-+grupo5(X,Y,"up")};
				if(grupo5(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C)){-+grupo5(X,Y,"down")};
				if(grupo5(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C)){-+grupo5(X,Y,"left")};
				if(grupo5(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C)){-+grupo5(X,Y,"right")};
				
				if(grupoT(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C)){-+grupoT(X,Y,"up")};
				if(grupoT(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C)){-+grupoT(X,Y,"down")};
				if(grupoT(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C)){-+grupoT(X,Y,"left")};
				if(grupoT(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C)){-+grupoT(X,Y,"right")};
				
				if(grupo4(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C)){-+grupo4(X,Y,"up")};
				if(grupo4(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C)){-+grupo4(X,Y,"down")};
				if(grupo4(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C)){-+grupo4(X,Y,"left")};
				if(grupo4(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C)){-+grupo4(X,Y,"right")};
				
				if(grupoCuadrado(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C)){-+grupoCuadrado(X,Y,"up")};
				if(grupoCuadrado(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C)){-+grupoCuadrado(X,Y,"down")};
				if(grupoCuadrado(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C)){-+grupoCuadrado(X,Y,"left")};
				if(grupoCuadrado(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C)){-+grupoCuadrado(X,Y,"right")};
				
				if(grupo3(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C)){-+grupo3(X,Y,"up")};
				if(grupo3(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C)){-+grupo3(X,Y,"down")};
				if(grupo3(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C)){-+grupo3(X-1,Y,"left")};
				if(grupo3(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C)){-+grupo3(X,Y,"right")};
			}
		}
	}.

+borrarBusqueda <-
	-borrarBusqueda;
	.findall(grupo5(A1,B1,D1),grupo5(A1,B1,D1),L1);for ( .member(K1,L1) ) {-K1;};
	.findall(grupoT(A2,B2,D2),grupoT(A2,B2,D2),L2);for ( .member(K2,L2) ) {-K2;};
	.findall(grupo4(A3,B3,D3),grupo4(A3,B3,D3),L3);for ( .member(K3,L3) ) {-K3;};
	.findall(grupoCuadrado(A4,B4,D4),grupoCuadrado(A4,B4,D4),L4);for ( .member(K4,L4) ) {-K4;};
	.findall(grupo3(A5,B5,D5),grupo3(A5,B5,D5),L5);for ( .member(K5,L5) ) {-K5;}.
+eliminarDatosTablero <-
	-eliminarDatosTablero;
	.findall(tablero(X,Y),tablero(X,Y),Lista);	
	for ( .member(Datos,Lista) ) {
			-Datos[source(judge)];
		 }.
//Comienzo del turno
+puedesMover[source(judge)] <- !realizarMovimiento.


//Realizacion de la jugada
+!realizarMovimiento <-
	//?randomMov(moverDesdeEnDireccion(pos(P1,P2),Dir));					
//	?movPrueba(moverDesdeEnDireccion(pos(P1,P2),Dir));
	+buscarMejorJugada;
	-buscarMejorJugada;
	
	if(grupo5(A1,B1,D1)){
		.print("Quiero eliminar un grupo de 5");
		X=A1;
		Y=B1;
		D=D1;
	}else{
		if(grupoT(A2,B2,D2)){
			.print("Quiero eliminar un grupo de T");
			X=A2;
			Y=B2;
			D=D2;
		}else{
			if(grupo4(A3,B3,D3)){
				.print("Quiero eliminar un grupo de 4");
				X=A3;
				Y=B3;
				D=D3;
			}else{
				if(grupoCuadrado(A4,B4,D4)){
					.print("Quiero eliminar un grupo cuadrado");
					X=A4;
					Y=B4;
					D=D4;
				}else{
					if(grupo3(A5,B5,D5)){
						.print("Quiero eliminar un grupo de 3");
						X=A5;
						Y=B5;
						D=D5;
					}else{
						.print("Quiero eliminar un grupo Random");
						?randomMov(moverDesdeEnDireccion(pos(P1,P2),Dir));
						X=P1;
						Y=P2;
						D=Dir;
					}
				}
			}
		}
	}
	
	.print("Intentando mover desde la posicion (",X,",",Y,") en direccion ",D);
	.wait(3000);
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),D));
	.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),D)).

//Movimiento realizado correctamente
+valido[source(judge)] <- 
	+eliminarDatosTablero;
	-eliminarDatosTablero;
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

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) <- 
	.print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


// Agent player in project ESEI_SAGA.mas2j
//Roi Pérez López, Martín Puga Egea
/* Initial beliefs and rules */
pensarJugada(X1,Y1,Dir):-
	size(N)&
	.random(X11,10) &
	.random(Y11,10) &
	X1 = math.round((N-1)*X11) &
	Y1 = math.round((N-1)*Y11) &
	(
	tablero(celda(X1,Y1,_),ficha(Color1,_)) &
	((tablero(celda(X1,Y1-1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "up")) |
	(tablero(celda(X1,Y1+1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "down")) |
	(tablero(celda(X1-1,Y1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "left")) |
	(tablero(celda(X1+1,Y1,_),ficha(Color2,_)) &
	(Color1 \== Color2 & Dir = "right")) | Dir = "up")
	).


/* Initial goals */


/* Plans */


//Comienzo del turno
+puedesMover[source(judge)] <- !realizarJugada.


//Realizacion de la jugada
+!realizarJugada : pensarJugada(P1,P2,Dir) <-
					.print("Quiero mover desde posicion (",P1,",",P2,") en direccion ",Dir)
					.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir));
					.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)).


//Movimiento realizado correctamente
+valido[source(judge)] <- .print("He hecho una buena jugada!").


//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- .print("Me he equivocado al comprobar el color de las fichas. Pensare otra jugada");
							!realizarJugada.

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <-
								.print("Me he equivocado y he intentado mover una ficha hacia fuera del tablero");
								!realizarJugada.

+invalido(fueraTablero,N)[source(judge)] : N>3 <-
								.print("Me he equivocado demasiadas veces intentando mover fichas hacia fuera del tablero. Paso Turno!");
								.send(judge,tell,pasoTurno);
								.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)] <- .print("Soy un tramposo!!! Intente realizar una jugada fuera de mi turno y el Juez me ha pillado").

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) <- .print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


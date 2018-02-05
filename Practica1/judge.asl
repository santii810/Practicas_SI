// Agent Judge in project Practica1.mas2j



/* Initial beliefs and rules */
size(10). //tama�o del tablero
tablero(DX,DY) :- DX <0 | DY <0 | (size(X) & X<DX) | X < DY.
mismaPosicion(OX,OY,DX,DY) :-	OX=DX & OY=DY.

turno(player1).

cambiarTurno(X):-
	X=player1 & turno(player2).
cambiarTurno(X):-
	X = player2 & turno(player1).
	

/* Initial goals */
!start.


/* Plans */

+!start : turno(X) <- 
	.print("Iniciar partida.");
	.send(X, tell, puedesMover).

+mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)] : mismaPosicion(OX,OY,DX,DY) <-
	.print("Movimiento incorrecto: se intenta mover una ficha a la misma posicion");
	.send(A,tell,correjir).
+mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)] :  tablero(DX,DY)    <- 
	.print("Movimiento incorrecto: se intenta mover una ficha a una posicion fuera del tablero");
	.send(A,tell,correjir).
+mover(Ficha,pos(OX,OY),pos(DX,DY)) [source(A)] <- 
	.print("Movimiento correcto").
	

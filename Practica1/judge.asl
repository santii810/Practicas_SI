// Agent Judge in project Practica1.mas2j

/* Initial beliefs and rules */
numTurno(1).
maxTurnos(100).
size(10). //tamaño del tablero
tablero(DX,DY) :- DX <0 | DY <0 | (size(X) & X<DX) | X < DY.
mismaPosicion(OX,OY,OX,OY).
turno(player1).
correcto(OX,OY,DX,DY):- not(tablero(DX,DY)) & not(mismaPosicion(OX,OY,DX,DY)).

finTurno :- maxTurnos(Max) & numTurno(N) & Max < N.
cambiarTurno(X):-
	X=player1 & turno(player2).
cambiarTurno(X):-
	X = player2 & turno(player1).


/* Initial goals */
!start.


/* Plans */
+!start : finTurno.
+!start  <- 
	?numTurno(N);	
	?turno(X);
	.print("\n\n\n");
	.print("Inicio turno ", N, " jugador " , X);
	.send(X, tell, mueve);
	.send(X,untell, mueve).

+mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)] : mismaPosicion(OX,OY,DX,DY) <-
	.print("Movimiento incorrecto: se intenta mover una ficha a la misma posicion");
	.send(A,tell,correjir);
	.send(A,untell,correjir);
	-mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)].
+mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)] :  tablero(DX,DY)    <- 
	.print("Movimiento incorrecto: se intenta mover una ficha a una posicion fuera del tablero");
	.send(A,tell,correjir);
	.send(A,untell,correjir);
	-mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)].
+mover(Ficha,pos(OX,OY),pos(DX,DY)) [source(A)]: correcto(OX,OY,DX,DY)<- 
	.print("Movimiento correcto. Moviendo de (", OX, ",", OY, ") a (", DX, ",", DY, ")." );
	.send(A,tell,puedesMover);
	.send(A,untell,movimientoCorrecto);
	-mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)];
	if(A=player1)
		{-+turno(player2);}
	else
		{-+turno(player1);};
	?numTurno(N);
	-+numTurno(N+1);
	!start.
	
+mover(Ficha,pos(OX,OY),pos(DX,DY))<-
	.print("Movimiento indeterminado").
	
	


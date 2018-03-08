// Agent judge in project practica1.mas2j

/* Initial beliefs and rules */

/*
Los movimientos que comunica el juez son:
valido							=> 	OK
invalido(fueraTablero,Veces)	=>  SI (Veces > 3) THEN pasaTurno
invalido(fueraTurno,Veces)		=>  SI (Veces > 3) THEN expulsado
tryAgain

Las estructuras de datos que se manejaran son 
	ficha(Color,Tipo)
	celda(X,Y,Own)

Mi estructura de tablero va a ser tablero(X,Y,Own,Color,Tipo)

*/

contador(100).

actual(player1).

mueve(Player) :-
	start &
	actual(Player) & 
	quedanMovimientos & 
	not inhabil(Player).

quedanMovimientos:-
	contador(N) & N>0.
	
inhabil(Player):-
	invalido(Player, F, 3).
	
invalido(player1,fueraTablero,0).
invalido(player1,fueraTurno,0).
invalido(player2,fueraTablero,0).
invalido(player2,fueraTurno,0).

valorTipo(in,0).
valorTipo(ip,1).
valorTipo(ct,2).
valorTipo(gs,3).
valorTipo(co,4).

valorColor(16,0).
valorColor(32,1).
valorColor(64,2).
valorColor(128,3).
valorColor(256,4).
valorColor(512,5).


valido(X1,Y1,X2,Y2):-
	not mismapos(X1,Y1,X2,Y2) &
	not fueratablero(X1,Y1,X2,Y2) &
	distintoColor(X1,Y1,X2,Y2).

mismapos(X,Y,X,Y).
	
fueratablero(X1,Y1,X2,Y2):-
	negativo(X1) | negativo(X2).

fueratablero(X1,Y1,X2,Y2):-
	negativo(Y1).

fueratablero(X1,Y1,X2,Y2):-
	negativo(Y2).

fueratablero(X1,Y1,X2,Y2):-
	sizeof(N) & .print("El tablero es de tamaño: ",N+1) &
	(X1 > N | X2 > N | Y1 > N | Y2 > N).

negativo(X):- X < 0.

distintoColor(X1,Y1,X2,Y2):-
	color(X1,Y1,C1) & 
	color(X2,Y2,C2) & 
	not C1 = C2.
	
ficha(X,Y,F):-
	tablero(X,Y,Own,Color,Tipo) &
	F = ficha(Color,Tipo).
	
celda(X,Y,Cell):-
	tablero(X,Y,Own,Color,Tipo) &
	Cell = celda(X,Y,Own).
	
owner(X,Y,Own):-
	tablero(X,Y,Own,Color,Tipo).
	
type(X,Y,Tipo):-
	tablero(X,Y,Own,Color,Tipo).
	
color(X,Y,Color):-
	tablero(X,Y,Own,Color,Tipo).

/* Initial goals */

!start.

/* Plans */
+!start : sizeof(N) <-
	.broadcast(tell,size(N));
	!startGame.
+!start <- !start.

+!startGame : mueve(Player) <-
	.send(Player,tell,puedesmover);
	.print("He iniciado el protocolo de movimientos.");
	.send(Player,untell,puedesmover);
	.print("He borrado mi rastro en ",Player);
	-contador(N);
	+contador(N-1).
	
+!startGame : actual(Player) & inhabil(Player) & quedanMovimientos <-
	-contador(N);
	+contador(N-1);
	if (invalido(Player,fueraTablero,3)) {
		-invalido(Player,fueraTablero,3);
		+invalido(Player,fueraTablero,0);
	};
	!exchangePlayer;
	!startGame.		
	
+!startGame : true <-
	.print("That's all falks............").


+!exchangePlayer : actual(A)<-
	if (A = player1){-+actual(player2);} 
		else {-+actual(player1);};
	.send(A,untell,valido).

	
+moverDesdeEnDireccion(pos(X,Y),up)[source(A)] : actual(A) & tablero(X,Y,O,Color,T) <-
	.print("Elimino lo recibido.....");
	-moverDesdeEnDireccion(pos(X,Y),up)[source(A)];
	.print(A," quiere mover la ficha",ficha(Color,T)," desde la posicion: ",pos(X,Y)," en direccion up.");
	+mueve(ficha(Color,T),pos(X,Y),pos(X,Y-1))[source(A)].

+moverDesdeEnDireccion(pos(X,Y), down)[source(A)] : actual(A) & tablero(X,Y,O,Color,T) <-
	.print("Elimino lo recibido.....");
	-moverDesdeEnDireccion(pos(X,Y),down)[source(A)];
	.print(A," quiere mover la ficha",ficha(Color,T)," desde la posicion: ",pos(X,Y)," en direccion down.");
	+mueve(ficha(Color,T),pos(X,Y),pos(X,Y+1))[source(A)].

+moverDesdeEnDireccion(pos(X,Y),left)[source(A)] : actual(A) & tablero(X,Y,O,Color,T) <-
	.print("Elimino lo recibido.....");
	-moverDesdeEnDireccion(pos(X,Y),left)[source(A)];
	.print(A," quiere mover la ficha",ficha(Color,T)," desde la posicion: ",pos(X,Y)," en direccion left.");
	+mueve(ficha(Color,T),pos(X,Y),pos(X-1,Y))[source(A)].

+moverDesdeEnDireccion(pos(X,Y),right)[source(A)] : actual(A) & tablero(X,Y,O,Color,T) <-
	.print("Elimino lo recibido.....");
	-moverDesdeEnDireccion(pos(X,Y),right)[source(A)];
	.print(A," quiere mover la ficha",ficha(Color,T)," desde la posicion: ",pos(X,Y)," en direccion right.");
	+mueve(ficha(Color,T),pos(X,Y),pos(X,Y+1))[source(A)].
	
+!actualizarTablero(Tab1,Tab2) : Tab1=tablero(X1,Y1,O1,C1,T1) & Tab2=tablero(X2,Y2,O2,C2,T2) <-
	.broadcast(untell,cell(C1,pos(X1,Y1),T1,O1));
	.broadcast(untell,cell(C2,pos(X2,Y2),T2,O2));
	-tablero(X1,Y1,O1,C1,T1)[source(self)];
	-tablero(X2,Y2,O2,C2,T2)[source(self)].

+!hacerMovimiento(X1,Y1,X2,Y2):	
		tablero(X1,Y1,O1,C1,T1) & tablero(X2,Y2,O2,C2,T2) & 
		valorColor(Color2,C2) & valorColor(Color1,C1) & 
		valorTipo(T2,Tipo2) & valorTipo(T1,Tipo1) <-
	//.print(tablero(X1,Y1,O1,C1,T1)," , ", tablero(X2,Y2,O2,C2,T2)," , ", Color1,",",Color2);
	put(X1,Y1,Color2,Tipo2);
	put(X2,Y2,Color1,Tipo1);
	!actualizarTablero(tablero(X1,Y1,O1,C1,T1),tablero(X2,Y2,O2,C2,T2));
	.wait(10).

+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & valido(X1,Y1,X2,Y2) & not inhabil(A) <- 
	.print("Acabo de verificar el movimiento del jugador: ",A);
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	.print("Muevo la ficha: ",F, "desde la posicion:", pos(X1,Y1)," hasta la posición: ", pos(X2,Y2));
	!hacerMovimiento(X1,Y1,X2,Y2);
	.send(A,tell,valido);
	!exchangePlayer;
	!startGame.	
	
+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & inhabil(A) <- 
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	.print("Este jugador no puede mover: ",A);
	if (invalido(A,fueraTablero,Veces)) {
		-invallido(A,fueraTablero,Veces); 
		+invalido(A,fueraTablero,0);
	};
	!exchangePlayer;
	!startGame.	
	
+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & fueratablero(X1,Y1,X2,Y2) <-
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	-invalido(A,fueraTablero,N);
	+invalido(A,fueraTablero,N+1);
	.print("Jugador: ", A, " Acabo de comprobar que tu movimiento es fuera del tablero");
	.send(A,tell,invalido(fueraTablero,N+1));
	.send(A,untell,invalido(fueraTablero,N+1)).

+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & not distintoColor(X1,Y1,X2,Y2) <-
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	.print("Jugador: ", A, " Acabo de comprobar que la celda contiene una ficha del mismo color");
	.send(A,tell,tryAgain);
	.send(A,untell,tryAgain).

+mueve(F,P1,P2)[source(A)] : not actual (A)<-
	-mueve(F,P1,P2)[source(A)];
	-invalido(A,fueraTurno,N);
	+invalido(A,fueraTurno,N+1)
	.print("Movimiento no experado del jugador: ",A);
	.send(A,tell,invalido(fueraTurno,N+1));
	.send(A,untell,invalido(fueraTurno,N+1)).
	
+mueve(F,P1,P2)[source(A)] : actual (A)<-
	-mueve(F,P1,P2)[source(A)];
	.print("Movimiento no controlado del jugador: ",A).
	
+mueve(F,P1,P2)<-
	-mueve(F,P1,P2);
	.print("Movimiento indeterminado").
	
+cell(Color1,pos(X1,Y1),T1,O1)[source(percept)] : valorColor(Color1,C1) <-
	-cell(Color1,pos(X1,Y1),T1,O1)[source(percept)];
	.broadcast(tell,cell(C1,pos(X1,Y1),T1,O1));
	+tablero(X1,Y1,O1,C1,T1).

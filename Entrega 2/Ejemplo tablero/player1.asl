// Agent player1 in project practica1.mas2j



/* Initial beliefs and rules */
enTablero(X,Y) :-
	size(N) & X <= N & Y <= N & X >= 0 & Y >= 0.
	
validoMov(pos(X,Y),up) :-
	enTablero(X,Y) &
	enTablero(X,Y-1).

validoMov(pos(X,Y),down) :-
	enTablero(X,Y) &
	enTablero(X,Y+1).

validoMov(pos(X,Y),left) :-
	enTablero(X,Y) &
	enTablero(X-1,Y).

validoMov(pos(X,Y),right) :-
	enTablero(X,Y) &
	enTablero(X+1,Y).

creaPos(pos(X,Y)) :-
	size(N) & 
	X = math.round(math.random(N)) &
	Y = math.round(math.random(N)).
	
creaDir(Dir) :-
	VDir = math.round(math.random(3)) &
	direccion(VDir,Dir).
	
direccion(0,up).
direccion(1,down).
direccion(2,left).
direccion(3,right).

/* Initial goals */



//!start.



/* Plans */
/*
+!start : size(N) & creaPos(P) & creaDir(D) <- 
	.print("He considerado el movimiento de mover la ficha de la posicion: ",P," en direccion: ",D);
	.wait(2000);
	+movimiento(P,D).
+!start <- !start.
*/	
+tryAgain[source(judge)]: size(N) & creaPos(P) & creaDir(D) <- 
	.print("El juez me pide otro movimiento.......................................");
	.print("Muevo desde: ",P," con direccion ", D," en un tablero de ", N+1,"x",N+1);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).

+puedesmover[source(judge)]: size(N) & creaPos(P) & creaDir(D) <- 
	.print("Acabo de recibir del juez el testigo de mover");
	.print("Muevo desde: ",P," con direccion ", D," en un tablero de ", N+1,"x",N+1);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
//+puedesmover[source(judge)] <-
//	.print("Aun no tengo un movimiento valido"); .wait(2000).            
	
/*	
+puedesmover[source(judge)] : not invalidoC(P1,P2) <- 
	.print("Acabo de recibir nuevamente del juez el testigo de mover");
	.print("Procedo a actualizar los conocimientos sobre movimientos");
	+invalidoA(pos(-3,4),pos(5,4));
	+invalidoB(pos(1000,3), pos(5,4));
	.print("Muevo de: pos(1,1) a pos(1,1)......");
	.send(judge,tell,mueve(ficha,pos(1,1),pos(1,1))).*/

+invalido(fueraTablero,Veces)[source(judge)] : Veces > 3 <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 3 veces");
	.print("Pierdo el turno.").
	
+invalido(fueraTablero,Veces)[source(judge)] : Veces < 4 & creaPos(P) & creaDir(D)  <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero: ",  Veces, " veces.");
	.print("Muevo desde ",P," en dirección ", D);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
+invalido(fueraTablero,Veces)[source(judge)] <-
	.print("jjjjjj").
	
+invalido(fueraTurno,Veces)[source(judge)] : Veces < 3 & creaPos(P) & creaDir(D)  <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero: ",  Veces, " veces.");
	.print("Muevo desde ",P," en dirección ", D);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
+invalido(fueraTurno,Veces)[source(judge)] <-
	.print("ffffff").

+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").


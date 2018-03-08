//Agent player2 in project practica1.mas2j

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
	Vdir = math.round(math.random(10)) mod 4 &
	direccion(VDir,Dir).
	
direccion(0,up).
direccion(1,down).
direccion(2,left).
direccion(3,right).

/* Initial goals */

/* Plans */
+!nuevoMovimiento : size(N) & creaPos(P) & creaDir(D) <- 
	.print("Muevo desde: ",P," con direccion ", D," en un tablero de ", N+1,"x",N+1);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
+tryAgain[source(judge)] <- 
	.print("El juez me pide otro movimiento, que fastidio      ...................");
	!nuevoMovimiento.

+puedesmover[source(judge)]: size(N) & creaPos(P) & creaDir(D) <- 
	.print("Acabo de recibir del juez el testigo de mover");
	!nuevoMovimiento.
	
+invalido(fueraTablero,Veces)[source(judge)] : Veces > 3 <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 3 veces");
	.print("Pierdo el turno.").
	
+invalido(fueraTablero,Veces)[source(judge)] : Veces < 2 & creaPos(P) & creaDir(D) <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero: ",  Veces, " veces.");
	.print("Muevo desde ",P," en dirección ", D);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
+invalido(fueraTablero,Veces)[source(judge)] <-
	.print("Porque aqui").
	
+invalido(fueraTurno,Veces)[source(judge)] : Veces < 3 & creaPos(P) & creaDir(D)  <-
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero: ",  Veces, " veces.");
	.print("Muevo desde ",P," en dirección ", D);
	.send(judge,tell,moverDesdeEnDireccion(P,D)).
	
+invalido(fueraTurno,Veces)[source(judge)] <-
	.print("Porque aqui").

+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido validado por el JUEZZZZZZZZZ").

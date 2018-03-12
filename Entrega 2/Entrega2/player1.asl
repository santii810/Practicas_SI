// Agent player in project ESEI_SAGA.mas2j
//Roi Pérez López, Martín Puga Egea
/* Initial beliefs and rules */
direccion(0,up).
direccion(1,down).
direccion(2,right).
direccion(3,left).

randomMov(Mov):-
	size(Size) &
	.random(R1) & .random(R2) & .random(R3) & 
	direccion(4 * math.floor(R1), Dir) &
	Mov = moverDesdeEnDireccion(pos(math.floor(R2*Size) ,math.floor(R3 * Size)),Dir).
	
	
/* Initial goals */


/* Plans */


//Comienzo del turno
+puedesMover[source(judge)] <- !realizarMovimiento.


//Realizacion de la jugada
+!realizarMovimiento <-
	?randomMov(moverDesdeEnDireccion(pos(P1,P2),Dir));					
	.print("Intentando mover desde la posicion (",P1,",",P2,") en direccion ",Dir)
	.send(judge,tell,moverDesdeEnDireccion(pos(P1,P2),Dir));
	.send(judge,untell,moverDesdeEnDireccion(pos(P1,P2),Dir)).


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

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) <- 
	.print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


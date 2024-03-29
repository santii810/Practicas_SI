
// Agent Player2 in project Practica1.mas2j

/* Initial beliefs and rules */
direccion(0,up).
direccion(1,down).
direccion(2,right).
direccion(3,left).

randomMov(Mov):-
	.random(Random) &
	direccion(math.floor(Random*4), Direccion)&
	.random(X) &
	.random(Y) &
	Mov = moverDesdeEnDireccion(pos(math.floor(X*10),math.floor(Y*10)),D).

/* Initial goals */

//!start.
+!start <-
	.wait(5);
	.print("Inicio forzado jugador2");
	.random(Random);
	?direccion(math.floor(Random*4), Direccion);
	.random(X);
	.random(Y);
	Mov = moverDesdeEnDireccion(pos(math.floor(X*10),math.floor(Y*10)),Direccion);
	.print(Mov);
	.send(judge,tell,Mov);
	!start.	

/* Plans */
//Si es el primer movimiento, entonces viene a partir de un correcto
+puedesMover[source(judge)] <- 
	.print("Inicio Jugador 2");
	.random(Random);
	?direccion(math.floor(Random*4), Direccion);
	.random(X);
	.random(Y);
	Mov = moverDesdeEnDireccion(pos(math.floor(X*10),math.floor(Y*10)),Direccion);
	.print(Mov);	
	.send(judge,tell,Mov).
	
// Si devuelve un invalidod e tipo fueraTurno el jugador no puede hacer nada
+invalido(fueraTurno,Veces) [source(judge)].

//Cuando el jugador hace un movimiento invalido mas de 3 veces deja el turno
+invalido(fueraTablero,Veces) [source(judge)] : Veces > 3.
	
//Si recibe un invalido de tipo fueraTablero el jugador debe rectificar el movimiento
+invalido(fueraTablero,Veces) [source(judge)] <-
	.print("Corrigiendo movimiento");
	.random(Random);
	?direccion(math.floor(Random*4), Direccion);
	.random(X);
	.random(Y);
	Mov = moverDesdeEnDireccion(pos(math.floor(X*10),math.floor(Y*10)),Direccion);
	.print(Mov);	
	.send(judge,tell,Mov).
		
	
	//Si recibe un invalido de tipo fueraTablero el jugador debe rectificar el movimiento
+invalido(mismoColor) [source(judge)] <-
	.print("Corrigiendo movimiento");
	.random(Random);
	?direccion(math.floor(Random*4), Direccion);
	.random(X);
	.random(Y);
	Mov = moverDesdeEnDireccion(pos(math.floor(X*10),math.floor(Y*10)),Direccion);
	.print(Mov);	
	.send(judge,tell,Mov).
	
//Significa que el juez ha aceptado el movimiento  por lo que lo registramos
+valido[source(judge)]<- 
	.print("Ficha movida").	

+invalido(fueraTurno,Veces)[source(judge)].

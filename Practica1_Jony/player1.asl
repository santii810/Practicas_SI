
// Agent Player1 in project Practica1.mas2j

/* Initial beliefs and rules */
direccion(0,up).
direccion(1,down).
direccion(2,right).
direccion(3,left).

randomMov(Mov):-
	R1 = math.floor(math.random(4)) &
	R2 = math.floor(math.random(10)) &
	R3 = math.floor(math.random(10)) &
	direccion(R1,Dir) &
	Mov = moverDesdeEnDireccion(pos(R2,R3),Dir).
	
	
	
	

/* Initial goals */		
	
/* Plans */
//Si es el primer movimiento, entonces viene a partir de un correcto
+puedesMover[source(judge)]<- 
	.print("Moviendo Jugador 1");
	?randomMov(Mov);
	.print(Mov);	
	.send(judge,tell,Mov).
	
// Si devuelve un invalidod e tipo fueraTurno el jugador no puede hacer nada
+invalido(fueraTurno,Veces) [source(judge)].

//Cuando el jugador hace un movimiento invalido mas de 3 veces deja el turno
+invalido(fueraTablero,Veces) [source(judge)] : Veces > 3.
	
//Si recibe un invalido de tipo fueraTablero el jugador debe rectificar el movimiento
+invalido(fueraTablero,Veces) [source(judge)] <-
	.print("Corrigiendo movimiento");
	?randomMov(Mov);
	.print(Mov);	
	.send(judge,tell,Mov).
		
	
//Si recibe un invalido de tipo fueraTablero el jugador debe rectificar el movimiento
+invalido(mismoColor) [source(judge)] <-
	.print("Corrigiendo movimiento");
	?randomMov(Mov);
	.print(Mov);	
	.send(judge,tell,Mov).
	
	
	
//Significa que el juez ha aceptado el movimiento  por lo que lo registramos
+valido[source(judge)]<- 
	.print("Ficha movida\n\n").	

+invalido(fueraTurno,Veces)[source(judge)].

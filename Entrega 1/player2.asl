
// Agent Player2 in project Practica1.mas2j

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
//El juez les comunica el tamaño del tablero
+size(Size) [source(judge)].

//Si es el primer movimiento, entonces viene a partir de un correcto
+puedesMover[source(judge)]<- 
	.print("Moviendo Jugador 2");
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
+tryAgain [source(judge)] <-
	.print("Corrigiendo movimiento");
	?randomMov(Mov);
	.print(Mov);	
	.send(judge,tell,Mov).
	
	
	
//Significa que el juez ha aceptado el movimiento  por lo que lo registramos
+valido[source(judge)]<- 
	.print("Ficha movida\n").	

+invalido(fueraTurno,Veces)[source(judge)].

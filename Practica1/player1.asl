// Agent Player1 in project Practica1.mas2j



/* Initial beliefs and rules */



/* Initial goals */






/* Plans */



+puedesMover  [source(judge)]<- .print("Inicio Jugador 1");
	.send(judge,tell,mover(ficha,pos(3,3),pos(13,13))).
+correjir [source(A)] : A=judge <-
	.print("Corrigiendo movimiento");
	.send(judge,untell,mover(ficha,pos(3,3),pos(3,3)));
	.send(judge,tell,mover(ficha,pos(3,3),pos(4,3))).


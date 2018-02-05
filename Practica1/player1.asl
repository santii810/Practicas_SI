// Agent Player1 in project Practica1.mas2j



/* Initial beliefs and rules */

incorrectoA(mover(ficha,pos(3,3),pos(13,13))).
correcto(mover(ficha,pos(3,3),pos(4,3))).
/* Initial goals */






/* Plans */

+mueve  [source(judge)]: incorrectoA(X)<- 
	.print("Inicio Jugador 1");
	.send(judge,tell,X).
+correjir [source(judge)] : correcto(X)<-
	.print("Corrigiendo movimiento");
	?correcto(mover(_,pos(_,_),pos(D,E)));
	-+correcto(mover(A,pos(D,E),pos(D+1,E+1)));
	.send(judge,tell,X).
+movimientoCorrecto [source(judge)] <-
	.print("Ficha movida").



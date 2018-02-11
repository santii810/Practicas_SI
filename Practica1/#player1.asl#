// Agent Player1 in project Practica1.mas2j



/* Initial beliefs and rules */

correcto(mover(ficha,pos(0,0),pos(0,0))).
/* Initial goals */

/* Plans */
//Si es el primer movimiento, entonces viene a partir de un correcto
+mueve[source(judge)]: correcto(mover(ficha,pos(_,_),pos(DX,DY)))<- 
	.print("Inicio Jugador 1");
	-+movimiento(mover(ficha,pos(DX,DY),pos(math.random(15)+1,math.random(15)+1)));
	?movimiento(X);
	.send(judge,tell,X).
//Si tiene que rectificar una o varias veces significa que ha realizado algun movimiento
+correjir [source(judge)] : movimiento(X)<-
	.print("Corrigiendo movimiento");
	//Las coordenadas de destino de correcto,son las coordenadas por donde empieza el siguiente movimiento
	?correcto(mover(ficha,pos(_,_),pos(OX,OY)));
	//Almacenamos el nuevo movimiento
	-+movimiento(mover(A,pos(DX,DY),pos(math.random(15)+1,math.random(15)+1)));
	?movimiento(mover(ficha,pos(_,_),pos(DX,DY)));
	.send(judge,tell,mover(ficha,pos(OX,OY),pos(DX,DY))).
//Si se realiza un movimiento correcto
+movimientoCorrecto [source(judge)] <-
	?movimiento(X);
	//El movimiento realizado pasa a ser el movimiento correcto
	-+correcto(X);
	.print("Ficha movida").

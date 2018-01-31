// Agent Judge in project Practica1.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("hello world.").

+mover(Ficha,pos(OX,OY),pos(DX,DY))[source(A)] : 
		not(OX=DX & OY=DY) & DX >0 & DY >0    <- 
	.print("Movimiento correcto").
+mover(Ficha,pos(OX,OY),pos(DX,DY)) [source(A)]<- 
	.print("Movimiento erroneo");
	.send(A,tell,correjir).

// Agent tom in project greeting.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .send(bob,tell,hello).

+hola[source(A)] <- 
	.print("he recibido de ", A, " el mensaje hola");
	.send(bob,tell,mueve(Ficha,pos(3,4),pos(4,5))).


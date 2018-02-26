// Agent bob in project greeting.mas2j

/* Initial beliefs and rules */

/* Initial goals */

// !start.

/* Plans */

// +!start : true <- .print("hello world.").
// : A = tom es una condicion
+hello[source(A)] : A = tom <- 
	.print("I received a 'hello' from ",A);
	.send(A,tell,hola).
	
+mueve(Ficha,Pos1,Pos2) : Pos1 = pos(3,4) & (X = 3 | Y = 4) <- 
	.print("he recibido la orden de mover ",
	Ficha, " de ", Pos1, " a " , Pos2).

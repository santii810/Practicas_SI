// Agent judge in project Practica1.mas2j



/* Initial beliefs and rules */


limiteVecesFueraTablero :- veces(fueraTablero,N) & N >= 3.//Veces que esta permitido enviar un mov. fuera de tablero
//Por defecto estan a 0 las veces de fuera de tablero y fuera de turno
veces(fueraTablero,0).
veces(fueraTurno,0).
numTurno(1).//Almacena el número de turnos que se estan realizando en cada momento
maxTurnos(100).//Maximo de turnos del juego
size(10). //tamaño del tablero
//comprobación general de fuera tablero
comprobarFueraTablero(DX,DY) :- 
				size(X) &
				(DX < 0 |
				 DY < 0 |
				(X < DX) |
				(X < DY) ).
//comprobacion específica de cada uno de los movimientos deseados
fueraTablero(pos(X,Y),up) :- comprobarFueraTablero(X,Y-1).
fueraTablero(pos(X,Y),down) :- comprobarFueraTablero(X,Y+1).
fueraTablero(pos(X,Y),left) :- comprobarFueraTablero(X-1,Y).
fueraTablero(pos(X,Y),right) :- comprobarFueraTablero(X+1,Y).
//Por defecto empieza el player1
turno(player1).
//Comprobación del movimiento correcto
correcto(pos(X,Y),Dir):- not(fueraTablero(pos(X,Y),Dir)). 
/*
TODO
comprobar que las fichas sean de distinto color
*/
finTurno :- maxTurnos(Max) & numTurno(N) & Max < N.




/* Initial goals */
!start.



/* Plans */
+!start : finTurno. // Si el numero de turno es mayor al maximo de turnos finaliza el goal.

+!start : numTurno(NumTurno) & turno(X) <- 
	.print("\n\n\n");
	.print("Inicio turno ", NumTurno, " jugador " , X);
	.send(X, tell, mueve);
	.send(X,untell, mueve).

//Caso para cuando se tienen 3 veces fuera de tablero y la posición vuelve a ser fuera de tablero (3+1 <= 3)
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : limiteVecesFueraTablero & fueraTablero(pos(X,Y),Dir) <-
	?veces(fueraTablero,V);
	.print(veces(fueraTablero,V+1));
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	if(A=player1)
		{-+turno(player2);}
	else
		{-+turno(player1);};
	-+veces(fueraTablero,0);//Reiniciamos contador de veces fueraTablero
	?numTurno(N);
	-+numTurno(N+1);
	!start.

//Caso para cuando la dirección recibida sea fuera de tablero
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : fueraTablero(pos(X,Y),Dir) <-
	?veces(fueraTablero,V);
	-+veces(fueraTablero,V+1);
	.print(veces(fueraTablero,V+1));
	.send(A,tell,correjir);
	.send(A,untell,correjir);
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)].
	
//Caso para cuando el movimiento es correcto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : correcto(pos(X,Y),Dir) <-
	.print(moverDesdeEnDireccion(pos(X,Y),Dir));
	.send(A,tell,puedesMover);
	.send(A,untell,puedesMover);
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	if(A=player1)
		{
		//Para saber la posición a la cual se dirigi y almacenar el valor de "celda(X,Y,own)"
		if(Dir=up){-+celda(X,Y+1,1);}
		if(Dir=down){-+celda(X,Y-1,1);}
		if(Dir=left){-+celda(X-1,Y,1);}
		if(Dir=right){-+celda(X+1,Y,1);}
		-celda(X,Y,1);
		-+turno(player2);}
	else
		{
		//Para saber la posición a la cual se dirigi y almacenar el valor de "celda(X,Y,own)"
		if(Dir=up){-+celda(X,Y+1,1);}
		if(Dir=down){-+celda(X,Y-1,1);}
		if(Dir=left){-+celda(X-1,Y,1);}
		if(Dir=right){-+celda(X+1,Y,1);}
		-celda(X,Y,2);
		-+turno(player1);};
	?numTurno(N);
	-+numTurno(N+1);
	-+veces(fueraTablero,0);//Reiniciamos contador de veces fueraTablero
	!start.

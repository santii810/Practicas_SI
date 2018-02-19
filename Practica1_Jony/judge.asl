// Agent judge in project Practica1.mas2j



/* Initial beliefs and rules */


limiteVecesFueraTablero :- vecesFueraTablero(N) & N >= 3.//Veces que esta permitido enviar un mov. fuera de tablero
//Por defecto estan a 0 las veces de fuera de tablero y fuera de turno
vecesFueraTablero(0).
//Necesitamos almacenar las veces que ha perdido el turno cada jugador por separado (player1, player2)
vecesFueraTurno(0,0).
numTurno(1).//Almacena el n�mero de turnos que se estan realizando en cada momento
maxTurnos(15).//Maximo de turnos del juego  /*TODO cambiar esto*/
size(1). //tama�o del tablero
//comprobaci�n general de fuera tablero
comprobarFueraTablero(DX,DY) :- 
				size(X) &
				(DX < 0 | DY < 0 | X <= DX | X <= DY ).
//comprobacion espec�fica de cada uno de los movimientos deseados
fueraTablero(pos(X,Y),up) :- comprobarFueraTablero(X,Y-1).
fueraTablero(pos(X,Y),down) :- comprobarFueraTablero(X,Y+1).
fueraTablero(pos(X,Y),left) :- comprobarFueraTablero(X-1,Y).
fueraTablero(pos(X,Y),right) :- comprobarFueraTablero(X+1,Y).
//Por defecto empieza el player1
turno(player1).

//Comprobaci�n del movimiento correcto
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

// Caso para cuando el jugador que envia ha superado el limite de turnos perdidos
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : vecesFueraTurno(P1,P2) &
				( (A = player1 & P1 >= 3) | (A = player2 & P2 >= 3) )  <-
	.print("El jugador ", A, " ha superado el limite de turnos fallidos");
	?numTurno(N);
	-+numTurno(N+1);
	!start.
				
	   
	
	
//Caso para cuando se tienen 3 veces fuera de tablero y la posici�n vuelve a ser fuera de tablero (3+1 <= 3)
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : limiteVecesFueraTablero & not(correcto(pos(X,Y),Dir))  <-
	.print(3);
	//Incrementamos el numero de movimientos incorrectos en este turno
	?vecesFueraTablero(V);
	-+vecesFueraTablero(V+1);
	.print("Movimiento incorrecto ", V+1 , "� vez.");
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	if(A=player1){
		-+turno(player2);
	}else{
		-+turno(player1);
	};
	-+vecesFueraTablero(0);//Reiniciamos contador de veces fueraTablero
	
	?vecesFueraTurno(P1,P2);
	if(A = player1){
		-+vecesFueraTurno(P1+1,P2);
		.print("Fuera turno " , P2+1 , "� vez");
	}else{
		-+vecesFueraTurno(P1,P2+1);
		.print("Fuera turno " , P2+1 , "� vez");
	}
	
	
	?numTurno(N);
	-+numTurno(N+1);
	!start.





	
//Caso para cuando la direcci�n recibida sea incorrecta
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not(correcto(pos(X,Y),Dir)) & vecesFueraTablero(V) <-
	.print(2);
	//Incrementamos el numero de movimientos incorrectos en este turno
//	?vecesFueraTablero(V);
	-+vecesFueraTablero(V+1);
	.print("Movimiento incorrecto ", V+1 , "� vez.");
	.send(A,tell,correjir);
	.send(A,untell,correjir);
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)].

	
//Caso para cuando el movimiento es correcto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : correcto(pos(X,Y),Dir) <-
	.print(1);	
	.print(moverDesdeEnDireccion(pos(X,Y),Dir));
	.send(A,tell,puedesMover);
	.send(A,untell,puedesMover);
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	//Para saber la posici�n a la cual se dirigi y almacenar el valor de "celda(X,Y,own)"
	if(Dir=up){-+celda(X,Y+1,1);}
	if(Dir=down){-+celda(X,Y-1,1);}
	if(Dir=left){-+celda(X-1,Y,1);}
	if(Dir=right){-+celda(X+1,Y,1);}
	if(A=player1){
		-celda(X,Y,1);
		-+turno(player2);
	}else{
		-celda(X,Y,2);
		-+turno(player1);
	};
	?numTurno(N);
	-+numTurno(N+1);
	-+vecesFueraTablero(0);//Reiniciamos contador de veces fueraTablero
	!start.
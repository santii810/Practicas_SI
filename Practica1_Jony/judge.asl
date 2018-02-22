// Agent judge in project Practica1.mas2j



/* Initial beliefs and rules */
/* #region atributos de configuracion*/
	maxTurnos(10).//Maximo de turnos del juego
	size(3). //tamaño del tablero
	numTurno(1).//Almacena el número de turnos que se estan realizando en cada momento
	turno(player1). //Jugador que empieza el juego
	maxFueraTurno(3).
	maxFueraTablero(3).

/*	#endregion */

limiteVecesFueraTablero :- vecesFueraTablero(N) & N >= 3.//Veces que esta permitido enviar un mov. fuera de tablero
//Por defecto estan a 0 las veces de fuera de tablero y fuera de turno
vecesFueraTablero(0).
//Necesitamos almacenar las veces que ha perdido el turno cada jugador por separado (player1, player2)
vecesFueraTurno(0,0).
veces(fueraTablero,0).
veces(player1,fueraTurno,0).
veces(player2,fueraTurno,0).

//comprobación general de fuera tablero
comprobarFueraTablero(DX,DY) :- 
				size(Tam) &
				(DX < 0 | DY < 0 | DX >= Tam | DY >= Tam).
//comprobacion específica de cada uno de los movimientos deseados
fueraTablero(pos(X,Y),up) :- comprobarFueraTablero(X,Y-1).
fueraTablero(pos(X,Y),down) :- comprobarFueraTablero(X,Y+1).
fueraTablero(pos(X,Y),left) :- comprobarFueraTablero(X-1,Y).
fueraTablero(pos(X,Y),right) :- comprobarFueraTablero(X+1,Y).

eligeColor(Color):-
	.random(Random) & Color = math.floor(Random*6).

eligeColor :- 
	.random(Random) & Exp = math.floor(Random*6) & color(Exp). //escogemos color al azar


//Comprobación del movimiento correcto
correcto(pos(X,Y),Dir):- not(fueraTablero(pos(X,Y),Dir)). 
/*
TODO	comprobar que las fichas sean de distinto color
*/
finTurno :- maxTurnos(Max) & numTurno(N) & Max < N.




/* Initial goals */
!rellenar.
!start.



/* Plans */
+!rellenar: size(Size) <-
	for (.range(Y,0,Size-1)) {
		for (.range(X,0,Size-1)) {
			?eligeColor(Color);
			+tablero(ficha(in,Color),celda(X,Y,0));
		}
	}.

+!start : finTurno. // Si el numero de turno es mayor al maximo de turnos finaliza el goal.

+!start : numTurno(NumTurno) & turno(X) <- 
	.print("\n\n\n");
	.print("Inicio turno ", NumTurno, " jugador " , X);
	.send(X, tell, puedesMover);
	.send(X,untell, puedesMover).
	
// Cuando un jugador expulsado juega en su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] :turno(A) & veces(A,fueraTurno,NumFueraTurno) & maxFueraTurno(Max) & NumFueraTurno > Max <-
	.print("El jugador ", A, " ha superado el limite de turnos fallidos");
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	if(A=player1){
		-+turno(player2);
	}else{
		-+turno(player1);
	};
	!start.

// Caso para cuando el jugador que envia ha superado el limite de advertencias fueraTurno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : veces(A,fueraTurno,NumFueraTurno) & maxFueraTurno(Max) & NumFueraTurno > Max <-
	.print("El jugador ", A, " ha superado el limite de turnos fallidos");
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)]. 
	
//Cuando un jugador interactua sin ser su turno	
	+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not(turno(A)) <- 
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];	
	?veces(A,fueraTurno,V);
	-+veces(A,fueraTurno,V+1);
	.print(A, " ha intentado realizar un movimiento fuera de su turno, " ,V+1, "ª falta");
	.send(A,tell,invalido(fueraTurno,V+1));
	.send(A,untell,invalido(fueraTurno,V+1)).
			   
	
	
//Caso para cuando se tienen 3 veces fuera de tablero y la posición vuelve a ser fuera de tablero (3+1 <= 3)
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) & limiteVecesFueraTablero & not(correcto(pos(X,Y),Dir))  <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?vecesFueraTablero(V); //Incrementamos el numero de movimientos incorrectos en este turno
	-+vecesFueraTablero(V+1);
	.print("Movimiento incorrecto ", V+1 , "ª vez.");
	if(A=player1){
		-+turno(player2);
	}else{
		-+turno(player1);
	};
	-+vecesFueraTablero(0);//Reiniciamos contador de veces fueraTablero
		
	.send(A,tell,invalido(fueraTurno,NumVeces));
	.send(A,untell,invalido(fueraTurno,NumVeces));
		
	?numTurno(N);
	-+numTurno(N+1);
	!start.

	
//Caso para cuando la dirección recibida sea incorrecta
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) &  not(correcto(pos(X,Y),Dir)) & vecesFueraTablero(V) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)]	;
	//Incrementamos el numero de movimientos incorrectos en este turno
	-+vecesFueraTablero(V+1);
	.print("Movimiento incorrecto ", V+1 , "ª vez.");
	.send(A,tell,invalido(fueraTablero,V+1));
	.send(A,untell,invalido(fueraTablero,V+1)).

	
//Caso para cuando el movimiento es correcto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) &  correcto(pos(X,Y),Dir) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] ;
	.print("Movimiento correcto.");
	?numTurno(N);
	-+numTurno(N+1);
	-+vecesFueraTablero(0);//Reiniciamos contador de veces fueraTablero
	.send(A,tell,valido);
	.send(A,untell,valido);
	!start.
	
	
//Movimiento indeterminado del jugador
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	.print("Movimiento indeterminado del jugador",A).

//Movimiento indeterminado
+moverDesdeEnDireccion(pos(X,Y),Dir) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir);
	.print("Movimiento indeterminado").

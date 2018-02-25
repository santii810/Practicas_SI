// Agent judge in project Practica1.mas2j

/* Initial beliefs and rules */

/* ----------------------- #region atributos de configuracion*/
maxTurnos(11).//Maximo de turnos del juego
size(5). //tamaño del tabler
numTurno(1).//Almacena el número de turnos que se estan realizando en cada momento
turno(player1). //Jugador que empieza el juego
maxFueraTurno(3).
maxFueraTablero(3).
/*	#endregion */



/* ----------------------- #region valores iniciales*/
//Por defecto estan a 0 las veces de fuera de tablero y fuera de turno
veces(fueraTablero, 0).
veces(player1,fueraTurno,0).
veces(player2,fueraTurno,0).


/*	#endregion */



// Unifica si el numero de faltas de tipo fueraTablero es mayor al maximo de permitidas
limiteVecesFueraTablero :- maxFueraTablero(Max) & veces(fueraTablero, N) & N >= Max.


//Unifica si las coordenadas recibidas estan fuera del tablero
comprobarFueraTablero(DX,DY) :- 
				size(Tam) &
				(DX < 0 | DY < 0 | DX >= Tam | DY >= Tam).
				
//comprobacion específica de cada uno de los movimientos deseados
fueraTablero(pos(X,Y),up) :- comprobarFueraTablero(X,Y-1).
fueraTablero(pos(X,Y),down) :- comprobarFueraTablero(X,Y+1).
fueraTablero(pos(X,Y),left) :- comprobarFueraTablero(X-1,Y).
fueraTablero(pos(X,Y),right) :- comprobarFueraTablero(X+1,Y).

//Elige un color de manera aleatoria
//eligeColor(Color):-	Color = 1. //Clausula de pruebas que asigna el mismo color a todas las fichas
eligeColor(Color):-	.random(Random) & Color = math.floor(Random*6).

// Grupo de clausulas que calculan las coordenadas de destino
calcularDestino(pos(X,Y),up,pos(X,Y-1)).
calcularDestino(pos(X,Y),down,pos(X,Y+1)).
calcularDestino(pos(X,Y),right,pos(X+1,Y)).
calcularDestino(pos(X,Y),left,pos(X-1,Y)).

// Unifica si el movimiento enviado tiene las fichas de origen y destino con el mismo color
mismoColor(pos(OX,OY),Dir):- 
	calcularDestino(pos(OX,OY),Dir,pos(DX,DY))
	& tablero(ficha(_, Color), celda(OX, OY, _)) 
	& tablero(ficha(_, Color), celda(DX, DY, _)).

//Unifica si el movimiento es movimientoCorrecto
//movimientoCorrecto(pos(X,Y),Dir):- not(fueraTablero(pos(X,Y),Dir)). //Version antigua, nueva sin probar
movimientoCorrecto(Mov):- not(fueraTablero(Mov)) & not(mismoColor(Mov)). 

// Unifica si el turno actual es mayor al maximo de turnos configurado
finTurno :- (maxTurnos(Max) & numTurno(N) & Max < N).

//Unifica si el jugador A supera el numero maximo configurado de faltas de tipo fueraTurno
superarLimiteFueraTurno(A) :- veces(A,fueraTurno,NumFueraTurno) & maxFueraTurno(Max) & NumFueraTurno > Max.

//Unifica si Numero es par
par(Numero) :- 0 = Numero mod 2.


cambiarTurno(player1, player2).
cambiarTurno(player2, player1).

/* Initial goals */
!start.


/* Plans */
+!start<-
	!comprobarTurnos;
	!rellenar;
	!ordenarMovimiento.
+!comprobarTurnos: maxTurnos(N) & par(N).
+!comprobarTurnos: maxTurnos(N) <-
	-+maxTurnos(N-1).

+!rellenar: size(Size) <-
	for (.range(Y,0,Size-1)) {
		for (.range(X,0,Size-1)) {
			?eligeColor(Color);
			+tablero(ficha(in, Color), celda(X, Y, 0));
		}
	};
	?maxTurnos(Max);
	if(par(Max)){
		-+turnosPlayer1(Max/2);
		-+turnosPlayer2(Max/2);
	}
	else{
		-+turnosPlayer1(math.ceil(Max/2));
		-+turnosPlayer2(math.floor(Max/2));
	};
	!ordenarMovimiento.

+!ordenarMovimiento : finTurno. // Si el numero de turno es mayor al maximo de turnos finaliza el goal.
//Si se expulsa a un jugador el que quede tendra que realizar los turnos asignados
+!ordenarMovimiento : superarLimiteFueraTurno(player2) & numTurno(N) & turnosPlayer1(N-1).
+!ordenarMovimiento : superarLimiteFueraTurno(player1) & numTurno(N) & turnosPlayer2(N-1).

+!ordenarMovimiento : numTurno(NumTurno) & turno(X) <- 
	//.print("\n\n\n");
	.print("Inicio turno ", NumTurno, " jugador " , X);
	.send(X, tell, puedesMover);
	.send(X,untell, puedesMover).

	
	/*
	Orden para moverDesdeEnDireccion:
	Limite de turnos superado
	
	*/
// Cuando un jugador expulsado juega en su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] :turno(A) & superarLimiteFueraTurno(A) <-
	.print("El jugador ", A, " ha superado el limite de turnos fallidos, su turno queda deshabilitado\n\n");
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?cambiarTurno(A,B);
	-+turno(B);

	!ordenarMovimiento.

// Caso para cuando el jugador que envia ha superado el limite de advertencias fueraTurno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not(turno(A)) & veces(A,fueraTurno,NumFueraTurno) & NumFueraTurno >= 3 <-
	.print("El jugador ", A, " ha superado el limite de turnos fallidos\n\n");
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?veces(A,fueraTurno,V);
	-+veces(A,fueraTurno,V+1);
	.send(A,tell,invalido(fueraTurno,V+1));
	.send(A,untell,invalido(fueraTurno,V+1)).
	
//Cuando un jugador interactua sin ser su turno	
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not(turno(A)) <- 
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];	
	?veces(A,fueraTurno,V);
	-+veces(A,fueraTurno,V+1);
	.print(A, " ha intentado realizar un movimiento fuera de su turno, " ,V+1, "ª falta");
	.send(A,tell,invalido(fueraTurno,V+1));
	.send(A,untell,invalido(fueraTurno,V+1)).
			   
	
	
//Caso para cuando se tienen 3 veces fuera de tablero y la posición vuelve a ser fuera de tablero (3+1 <= 3)
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) & limiteVecesFueraTablero & not(movimientoCorrecto(pos(X,Y),Dir))  <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?veces(fueraTablero, V); //Incrementamos el numero de movimientos inmovimientoCorrectos en este turno
	-+veces(fueraTablero, V+1);
	.print("Movimiento inmovimientoCorrecto ", V+1 , "ª vez.\n\n");
	if(superarLimiteFueraTurno(player1) | superarLimiteFueraTurno(player2))	{
		if(superarLimiteFueraTurno(player1)){
			-+turno(player2);
		} else {
			-+turno(player1);
		};	
	}else{
		?cambiarTurno(A,B);
		-+turno(B);
	};
	-+veces(fueraTablero, 0);//Reiniciamos contador de veces fueraTablero
		
	?numTurno(N);
	-+numTurno(N+1);
	.send(A,tell,invalido(fueraTurno,NumVeces));
	.send(A,untell,invalido(fueraTurno,NumVeces));
	!ordenarMovimiento.

	
//Caso para cuando la dirección recibida sea incorrecta
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) & not(movimientoCorrecto(pos(X,Y),Dir)) & veces(fueraTablero, V) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)]	;
	//Incrementamos el numero de movimientos inmovimientoCorrectos en este turno
	-+veces(fueraTablero, V+1);
	.print("Movimiento inmovimientoCorrecto ", V+1 , "ª vez.");
	.send(A,tell,invalido(fueraTablero,V+1));
	.send(A,untell,invalido(fueraTablero,V+1)).

	
//Caso para cuando las fichas son del mismo color
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) & mismoColor(pos(X,Y),Dir) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)]	;
	//Incrementamos el numero de movimientos inmovimientoCorrectos en este turno
	.print("Movimiento inmovimientoCorrecto , fichas del mismo color");
	.send(A,tell,invalido(mismoColor));
	.send(A,untell,invalido(mismoColor)).
	

	
//Caso para cuando el movimiento es movimientoCorrecto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : turno(A) & movimientoCorrecto(pos(X,Y),Dir) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	.print("Movimiento movimientoCorrecto");
	?numTurno(N);
	-+numTurno(N+1);
	-+veces(fueraTablero, 0);//Reiniciamos contador de veces fueraTablero
	if(superarLimiteFueraTurno(player1) | superarLimiteFueraTurno(player2))	{
		if(superarLimiteFueraTurno(player1)){
			-+turno(player2);
		} else {
			-+turno(player1);
		};	
	}else{
		?cambiarTurno(A,B);
		-+turno(B);
	};
	.send(A,tell,valido);
	.send(A,untell,valido);
	!ordenarMovimiento.
	
	
//Movimiento indeterminado del jugador
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	.print("Movimiento indeterminado del jugador",A).

//Movimiento indeterminado
+moverDesdeEnDireccion(pos(X,Y),Dir) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir);
	.print("Movimiento indeterminado").

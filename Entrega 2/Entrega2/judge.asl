// Agent judge in project ESEI_SAGA.mas2j
/* ----- Initial beliefs and rules ------ */
//Recopilar datos de posicion y color de una ficha
datos(X,Y,Color):- tablero(celda(X,Y,_),ficha(Color,_)).
datos(X,Y,Color,Tipo,Prop):- tablero(celda(X,Y,Prop),ficha(Color,Tipo)).
//Para que queden los obstaculos repartidos
obstaculosContiguos(X,Y):-datos(X-1,Y,-1) | datos(X+1,Y,-1) | datos(X,Y-1,-1) | datos(X,Y+1,-1).
//Comprobacion de obstaculo
esObstaculo(X,Y):-tablero(celda(X,Y,_),ficha(-1,_)).
moveObstaculo(X,Y,Dir):-(nextMove(X,Y,DX,DY,Dir) & esObstaculo(DX,DY)) | esObstaculo(X,Y).
numObs(0).
maxObstaculos(6).
dir("left").
//Unifica si la ficha posicionada en la celda X,Y pertenece a alguna agrupacion
hayAgrupacion(X,Y,C):- grupo3Fil(X,Y,C)|grupo3Col(X,Y,C)|grupo4FilA(X,Y,C)|grupo4FilB(X,Y,C)|grupo4ColA(X,Y,C)|grupo4ColB(X,Y,C)| 
					  grupo4SquareA(X,Y,C)|grupo4SquareB(X,Y,C)|grupo4SquareC(X,Y,C)|grupo4SquareD(X,Y,C)|grupo5Fil(X,Y,C)|grupo5Col(X,Y,C)|
					  grupo5TN(X,Y,C)|grupo5TI(X,Y,C)|grupo5TR(X,Y,C)|grupo5TL(X,Y,C).

//Agrupaciones de 3
grupo3Fil(X,Y,C) :- // #_#
	size(N) & X-1 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C).
grupo3Col(X,Y,C) :- // #_# (ficha desde medio)
		size(N) & Y-1 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y,C) & datos(X,Y+1,C).


//Agrupaciones de 4
grupo4FilA(X,Y,C) :- // #_##
	size(N) & X-1 >= 0 & X+2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X+2,Y,C).
grupo4FilB(X,Y,C) :- // ##_#
	size(N) & X-2 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,C) & datos(X+1,Y,C).	
grupo4ColA(X,Y,C) :- // #_## (Vertical)
	size(N) & Y-1 >= 0 & Y+2 < N & datos(X,Y-1,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C).
grupo4ColB(X,Y,C) :- // ##_# (Vertical)
	size(N) & Y-2 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y-2,C) & datos(X,Y,C) & datos(X,Y+1,C).

//Cuadrado	
grupo4SquareA(X,Y,C) :- // hueco arriba-izquierda
	size(N) & X+1 < N & Y+1 < N & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X+1,Y+1,C).
grupo4SquareB(X,Y,C) :- // hueco arriba-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,C) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C).
grupo4SquareC(X,Y,C) :- // hueco abajo-izquierda
	size(N) & X+1 < N & Y-1 >= 0 & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X+1,Y-1,C).
grupo4SquareD(X,Y,C) :- // hueco abajo-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,C) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C).	

//Agrupación de 5
//##_##
grupo5Fil(X,Y,C) :- size(N) & X+2 < N & X-2 >= 0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,C) & datos(X-1,Y,C) & datos(X-2,Y,C).
//(Medio vertical)##_##
grupo5Col(X,Y,C) :- size(N) & Y+2 < N & Y-2 >= 0 & datos(X,Y+1,C) & datos(X,Y+2,C) & datos(X,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C).

//Agrupación 5 en T
grupo5TN(X,Y,C) :- size(N) & X-1 >=0 & X+1 < N & Y+2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C).
grupo5TI(X,Y,C) :- size(N) & X-1 >=0 & X+1 < N & Y-2 < N & datos(X-1,Y,C) & datos(X,Y,C) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C).
grupo5TR(X,Y,C) :- size(N) & X-2 >=0 & Y+1 < N & Y-1 >=0 & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y-1,C).
grupo5TL(X,Y,C) :- size(N) & X+1 < N & Y+1 < N & Y-1 >=0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,C) & datos(X,Y+1,C) & datos(X,Y-1,C).

//Para elegir la agrupacion prioritaria
grupo3(X,Y,C):- grupo3Fil(X,Y,C) | grupo3Col(X,Y,C).	
grupo4(X,Y,C):- grupo4FilA(X,Y,C) | grupo4FilB(X,Y,C) | grupo4ColA(X,Y,C) | grupo4ColB(X,Y,C).
grupoCuadrado(X,Y,C):- grupo4SquareA(X,Y,C) | grupo4SquareB(X,Y,C) | grupo4SquareC(X,Y,C) | grupo4SquareD(X,Y,C).
grupoT(X,Y,C):- grupo5TN(X,Y,C) | grupo5TI(X,Y,C) | grupo5TR(X,Y,C) | grupo5TL(X,Y,C).
grupo5(X,Y,C):- grupo5Fil(X,Y,C) | grupo5Col(X,Y,C).


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
size(10).
jugadasRestantes(20).
jugadasPlayer(player1,0).
jugadasPlayer(player2,0).
turnoActual(player1).
turnoActivado(0).
fueraTablero(0).
fueraTurno(player1,0).
fueraTurno(player2,0).
nivel(2).
jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).
grupoEnUltimaEjecucion(1).
rodada(0).
posRodar(-1).


//(Añadida) color real y color en base 16 
color(-1,4).
color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.
eligeColor(Real,Color):- 
	.random(Random) &
	Real = math.floor(Random*6) & 
	not(colorLleno(Real)) &
	color(Real,Color).
eligeColor(Real,Color):- eligeColor(Real,Color).

numVecesColor(0,0).
numVecesColor(1,0).
numVecesColor(2,0).
numVecesColor(3,0).
numVecesColor(4,0).
numVecesColor(5,0).
colorLleno(Color):- size(N) & numVecesColor(Color,Veces) & Veces >= math.floor((N*N)/6)+1.

repetirColor(Color,Nuevo):- Color+1 < 6 & Nuevo = Color+1.
repetirColor(Color,Nuevo):- Color-1 >= 0 & Nuevo = Color-1.

//Comprobacion completa de las condiciones de un movimiento correcto: Seleccion, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen) & not moveObstaculo(X,Y,Dir).
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
mismoColor(COrigen,CDestino) :- COrigen=CDestino.

//Comprobacion de Movimiento
direccionCorrecta(pos(X,Y),Dir):- tablero(celda(X,Y,_),_) & movimiento(X,Y,Dir).
movimiento(X,Y,"up") :- tablero(celda(X,Y-1,_),_).
movimiento(X,Y,"down") :- tablero(celda(X,Y+1,_),_).
movimiento(X,Y,"left") :- tablero(celda(X-1,Y,_),_).
movimiento(X,Y,"right") :- tablero(celda(X+1,Y,_),_).

//Comprobacion de Color
colorFichasDistintos(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).

//Parte de la generacion aleatoria del tipo de ficha
randomFicha(Rand,Ficha):-
	(Rand == 0 & Ficha = ip) | (Rand == 1 & Ficha = in) | (Rand == 2 & Ficha = ct) | (Rand == 3 & Ficha = gs)
	| (Rand == 4 & Ficha = co).

//Duenho de la jugada
plNumb(player1,1).
plNumb(player2,2).

//Calculo de coordenadas para un movimiento
nextMove(P1,P2,P1,P2-1,"up").
nextMove(P1,P2,P1,P2+1,"down").
nextMove(P1,P2,P1+1,P2,"right").
nextMove(P1,P2,P1-1,P2,"left").
////Puntuacion//////////
player1Puntos(0).
player2Puntos(0).

puntosMov(0).

fin(1).

/* ----- Initial goals ----- */

!startGame.


/* ----- Plans ----- */


/* COMIENZO INTOCABLE */

//Comienzo del turno de un jugador.
+!comienzoTurno : jugadorDescalificado(player1,1) & jugadorDescalificado(player2,1) <-
			.print("FIN DE LA PARTIDA: Ambos jugadores han sido descalificados. TRAMPOSOS!!!").

+!comienzoTurno : turnoActual(P) & jugadasRestantes(N) & N>0 & jugadasPlayer(P,J) & J<50 <-
	.print("Turno de: ",P,"!");
	-+turnoActivado(1);
	.print(P,", puedes mover");
	.send(P,tell,puedesMover);
	.send(P,untell,puedesMover);
	.wait(1000);.

+!comienzoTurno : jugadasRestantes(N) & N=0 <- .print("FIN DE LA PARTIDA: Se ha realizado el numero maximo de jugadas");
	!ganador.//////////////////////


+!comienzoTurno : turnoActual(P) & jugadasPlayer(P,J) & J>=50 <- .print("FIN DE LA PARTIDA: ",P," ha realizado el maximo de jugadas por jugador (50)").


+!comienzoTurno <- .print("DEBUG: Error en +!comienzoTurno"). //Salvaguarda

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & movimientoValido(pos(X,Y),Dir) & turnoActivado(1) <-
			-+turnoActivado(0);
			-moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)];
			.print("Jugada valida!")
			.send(P,tell,valido);
			.send(P,untell,valido);
			+intercambiarFichas(X,Y,Dir,P);
			-intercambiarFichas(X,Y,Dir,P);
			
			-+dir(Dir);
			-+grupoEnUltimaEjecucion(1);
			
			+eliminarGrupos;	
			-eliminarGrupos;
			
			-+turnoTerminado(P);
			!comienzoTurno.

//Movimiento Incorrecto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & not movimientoValido(pos(X,Y),Dir) & turnoActivado(1)<-
			-+turnoActivado(0);
			+movimientoInvalido(pos(X,Y),Dir,P).

//Movimiento realizado por un jugador que tiene el turno pero el juez aun no le ha ordenado mover
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	turnoActual(P) & turnoActivado(0) <-
			.print("Agente ",P,", espera mi orden para realizar el siguiente movimiento. No intentes mover mas de una vez.").


//Movimiento realizado por un jugador fuera de su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	not turnoActual(P) & fueraTurno(P,N) <-
		.print(P," Has intentado realizar un movimiento fuera de tu turno. ", N+1," aviso");
		.send(P,tell,invalido(fueraTurno,N+1));
		.send(P,untell,invalido(fueraTurno,N+1));
		-fueraTurno(P,N);
		+fueraTurno(P,N+1).

//Descalificacion de un jugador
+fueraTurno(P,N) : N>3 <-
		-jugadorDescalificado(P,0);
		+jugadorDescalificado(P,1);
		.print("AVISO: ",P," ha sido descalificado por tramposo!!!").



//Deteccion de un agente externo a la partida (distinto a player1 y player 2) que esta intentando jugar.
// Esta regla la podeis adecuar a vuestras necesidades

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : 
	not turnoActual(P) & not fueraTurno(P,N) <- // --- TODO ---
		.print("El agente ",P," externo a la partida está intentando jugar.").

// Esta regla la podeis adecuar a vuestras necesidades
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <- 
	.print("DEBUG: Error en +moverDesdeEnDireccion. Source", P). //Salvaguarda

//Comprobacion de la falta cometida por mover una ficha hacia una posicion fuera del tablero, intentar mover una ficha de una posicion inexistente, o realizar un tipo de movimiento desconocido
+movimientoInvalido(pos(X,Y),Dir,P):
	fueraTablero(V) & not direccionCorrecta(pos(X,Y),Dir)  <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado mover una ficha fuera del tablero");
		.send(P,tell,invalido(fueraTablero,V+1));
		.send(P,untell,invalido(fueraTablero,V+1));
		-+turnoActivado(1);
		-+fueraTablero(V+1).

//Comprobacion de la falta cometida por intercambiar dos fichas del mismo color
+movimientoInvalido(pos(X,Y),Dir,P) : 
	not colorFichasDistintos(pos(X,Y),Dir) | moveObstaculo(X,Y,Dir) <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado  intercambiar dos fichas del mismo color");
		-+turnoActivado(1);
		.print("Intentalo de nuevo!");
		.send(P,tell,tryAgain);
		.send(P,untell,tryAgain).

// Esta regla la podeis adecuar a vuestras necesidades
+movimientoInvalido(pos(X,Y),Dir,P): moveObstaculo(X,Y,Dir) <- 
	?datos(X,Y,Color);
	
	.print("DEBUG: Error en +movimientoInvalido------------------------------------------------------------------------------------------").


//Recepcion del aviso de que un jugador pasa turno por haber realizado un movimiento fuera del tablero mas de 3 veces
+pasoTurno[source(P)] : turnoActual(P) <-
		-+fueraTablero(0);
		.print(P," ha pasado turno");
		+cambioTurno(P);
		!comienzoTurno.
			
			

/* FIN INTOCABLE */



+!startGame <- +generacionTablero;
				-generacionTablero;
				.print("Tablero de juego generado!");
				+mostrarTablero(player1);
				-mostrarTablero(player1);
				+mostrarTablero(player2);
				-mostrarTablero(player2);
				?nivel(Nivel);
				-+puntos(player1,Nivel,0);
				-+puntos(player2,Nivel,0);
				
				// ToDo Iniciar puntuacion
				.print("EMPIEZA EL JUEGO!")
				.wait(2000);
				!comienzoTurno.

//Generacion aleatoria del tablero y fichas.
+generacionTablero : size(N) & nivel(1) <-
	-generacionTablero;
	for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				?eligeColor(Real,Color);
				-numVecesColor(Real,Veces);
				+numVecesColor(Real,Veces+1);
				+tablero(celda(J,I,0),ficha(Real,in));
				put(J,I,Color,in);
		};
	};
	 //+eliminarGrupos;	
	 //-eliminarGrupos;
	 //+prioridadAgrupaciones;
	 //-prioridadAgrupaciones
	 +quitarAgrupacionesIniciales;
	 -quitarAgrupacionesIniciales;
	 .

+generacionTablero : size(N) & nivel(L) & L > 1 <-
	-generacionTablero;
	for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				.random(Random);
				RND = math.floor(Random*(10));
				?numObs(Cant);
				?maxObstaculos(Max)
				//Generar como maximo "Max" Obstaculos y repartirlos de manera que no esten contiguos
				if(RND = 6 & not(obstaculosContiguos(J,I)) & Cant < Max){
					-+numObs(Cant+1);
					+tablero(celda(J,I,0),ficha(-1,in));
					put(J,I,4,in);
				}else{
					?eligeColor(Real,Color);
					-numVecesColor(Real,Veces);
					+numVecesColor(Real,Veces+1);
					+tablero(celda(J,I,0),ficha(Real,in));
					put(J,I,Color,in);
				}
		};
	};
	
	 //+eliminarGrupos;	
	// -eliminarGrupos;
	//elimina por prioridad(Busca la mas prioritaria y luego la elimina asi hasta eliminarlos todos)
	 //+prioridadAgrupaciones;
	 //-prioridadAgrupaciones
	 +quitarAgrupacionesIniciales;
	 -quitarAgrupacionesIniciales;
	 .	 

+quitarAgrupacionesIniciales:size(Size) & fin(1) <-
	.print("hola");
	.wait(2000);
	-quitarAgrupacionesIniciales;
	-+fin(0);
	for(.range(X,0,Size-1)){
		for(.range(Y,0,Size-1)){
			if(datos(X,Y,Color) & hayAgrupacion(X,Y,Color)){
				deleteSteak(Color,X,Y);
				-tablero(celda(X,Y,_),_);
				?repetirColor(Color,Nuevo);
				+tablero(celda(X,Y,0),ficha(Nuevo,in));
				?color(Nuevo,C1);
				put(X,Y,C1,in);
				-+fin(1);
			}
		}
	}
	+quitarAgrupacionesIniciales;
	-quitarAgrupacionesIniciales;
	.
+quitarAgrupacionesIniciales <- .print("Tablero listo");-+fin(1).

	 
	 
+prioridadAgrupaciones:size(Size) <-
	-prioridadAgrupaciones;
	
	-grupos5(_,_,_);
	-gruposT(_,_,_);
	-grupos4(_,_,_);
	-gruposCuadrado(_,_,_);
	-grupos3(_,_,_);

	for(.range(X,0,Size-1)){
		for(.range(Y,Size-1,0,-1)){
			if(datos(X,Y,C)){
				if(grupo5(X,Y,C) | grupoT(X,Y,C)){
					if(grupo5(X,Y,C)){
						-+grupos5(X,Y,C);
					}else{
						-+gruposT(X,Y,C);
					}
				}else{
					if(grupoCuadrado(X,Y,C) | grupo4(X,Y,C)){
						if(grupoCuadrado(X,Y,C)){
							-+gruposCuadrado(X,Y,C);
						}else{
							-+grupos4(X,Y,C);
						}
					}else{
						if(grupo3(X,Y,C)){
							-+grupos3(X,Y,C);
						}
					}
				}
			}
		}
	}                 
	
	+eliminarPrioritario;
	-eliminarPrioritario.	
	
//Metodo de localizar las agrupaciones prioritarias
+eliminarPrioritario:grupos5(X,Y,C) <-	 
	-eliminarPrioritario;
	-grupos5(X,Y,C);
	+findGroups(X,Y,C);
	-findGroups(X,Y,C);
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
+eliminarPrioritario:gruposT(X,Y,C) <-	 
	-eliminarPrioritario;
	-gruposT(X,Y,C);
	+findGroups(X,Y,C);
	-findGroups(X,Y,C);
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
+eliminarPrioritario:grupos4(X,Y,C) <-
	-eliminarPrioritario;
	-grupos4(X,Y,C);
	+findGroups(X,Y,C);
	-findGroups(X,Y,C);
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
+eliminarPrioritario:gruposCuadrado(X,Y,C) <-
	-eliminarPrioritario;
	+findGroups(X,Y,C);
	-findGroups(X,Y,C);
	-gruposCuadrado(X,Y,C);
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
+eliminarPrioritario:grupos3(X,Y,C) <-
	-eliminarPrioritario;
	-grupos3(X,Y,C);
	+findGroups(X,Y,C);
	-findGroups(X,Y,C);
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
+eliminarPrioritario <- .print("Se acabaron las agrupaciones----------------------").
	
/*+eliminarGrupos: size(N) & grupoEnUltimaEjecucion(1) <- 
	-+grupoEnUltimaEjecucion(0);
	for ( .range(I,0,N-1) ) {
		for ( .range(J,(N-1),0,-1) ) {
			if(hayAgrupacion(I,J,Color)){
				-+grupoEnUltimaEjecucion(1);
				+findGroups(I,J,Color);
				-findGroups(I,J,Color);
			}	
		}
		+downToken;
		-downToken;
	};
	
	.wait(200);
	+eliminarGrupos;
	-eliminarGrupos;
	.

+eliminarGrupos.*/
	
/*	
//baja una columna 
+downToken : size(Size) <-
	
	for(.range(X,0,Size-1)){
		for(.range(Y,-1,Size-2)){
			+bajarColumna(X,Y);
			-bajarColumna(X,Y);
		}
	};
	//+eliminarGrupos;
	//-eliminarGrupos;
	.wait(100);
	.
*/	

+downToken : size(Size) <-
	
	for(.range(X,0,Size-1)){
		for(.range(Y,-1,Size-2)){
			+bajarColumna(X,Y);
			-bajarColumna(X,Y);
		}
	};
	+prioridadAgrupaciones;
	-prioridadAgrupaciones;
	.wait(100);
	.
	
+bajarColumna(X,Y) : not datos(X,Y+1,M1) & Y<0 <-
	+colocarFichaArriba(X);
	-colocarFichaArriba(X).
			
+bajarColumna(X,Y): not esObstaculo(X,Y) & not datos(X,Y+1,M1) & datos(X,Y,M2) <-
	-bajarColumna(X,Y);
	-+posRodar(-1);
	-+rodada(0);
	//.print("Bajando columna");
	for(.range(I,Y,0,-1)){
		.wait(100);
		+bajarFicha(X,I);
		-bajarFicha(X,I);
		?rodada(Num)
		//Comprobamos que no ha rodado ninguna ficha cuando "asienta" cada ficha en la columna
		if(Num=0 & not datos(X-1,I+1,_) & datos(X,I+2,_)){
			-+posRodar(I+1);
			-+rodada(1);
		}
	};
	+colocarFichaArriba(X);
	-colocarFichaArriba(X);
	?posRodar(Pos);
	if(Pos >= 0){
		if(datos(X,Pos,_)){
		+rodar(X,Pos);
		-rodar(X,Pos);
		
		}else{
			+bajarColumna(X,Pos-1);
			-bajarColumna(X,Pos-1);
		}
	}    
	
	.
	
+rodar(X,Y): size(Size) & not datos(X-1,Y,M1) & not esObstaculo(X,Y) & X-1 >=0 <-
	-rodar(X,Y);
	//.print("Rodando");
	//pasamos ficha ala izquierda
	-tablero(celda(X,Y,Own),ficha(Real,Tipo));
	+tablero(celda(X-1,Y,Own),ficha(Real,Tipo));
	?color(Real,Color);
	deleteSteak(Color,X,Y);
	put(X-1,Y,Color,Tipo);
	.wait(300);
	//bajamos la columna
	//+bajarColumna(X-1,Y);
	//-bajarColumna(X-1,Y);
	+bajarRodada(X-1,Y);
	-bajarRodada(X-1,Y);
	if(not datos(X,Y-1)){
		+colocarFichaArriba(X);
		-colocarFichaArriba(X);
	}
	+bajarColumna(X,Y-1);
	-bajarColumna(X,Y-1);
.
+rodar(X,Y).

+bajarRodada(X,Y):size(Size) & not datos(X,Y+1,_) & Y < Size <-
	-bajarRodada(X,Y);
	+bajarColumna(X,Y);
	-bajarColumna(X,Y);
	+bajarRodada(X,Y+1);
	-bajarRodada(X,Y+1).
+bajarRodada(X,Y).
	
+bajarFicha(X,Y): not datos(X,Y,M1) <- 	
	//.print("Bajando ficha si no hay");
	+colocarFichaArriba(X);
	-colocarFichaArriba(X);
	+bajarFicha(X,Y);
	-bajarFicha(X,Y);
.

+bajarFicha(X,Y): not esObstaculo(X,Y) & not datos(X,Y+1,M1) & datos(X,Y,M2) <-	

	//.print("Bajando ficha si no es obstaculo");
	-tablero(celda(X,Y,Own),ficha(Real,Tipo));
	+tablero(celda(X,Y+1,Own),ficha(Real,Tipo));
	?color(Real,Color);
	deleteSteak(Color,X,Y);
	put(X,Y+1,Color,Tipo);	
.
+bajarFicha(X,Y).

+colocarFichaArriba(X):size(Size) & not datos(X,0,M1) <-
	.print("Colocando ficha arriba");
	.random(Random);
	Real1 = math.floor(Random*6);
	//Real1 = 3;
	?color(Real1,Color1);
	put(X,0,Color1,in);
	+tablero(celda(X,0,0),ficha(Real1,in));
.
	
+colocarFichaArriba(X).

//Caida normal sin rodar
+caida(X,Y): not esObstaculo(X,Y) & not datos(X,Y+1,M1) & not datos(X,0,M2) <-
	+colocarFichaArriba(X);
	-colocarFichaArriba(X);
	.
	

+caida(X,Y): not esObstaculo(X,Y) & not datos(X,Y+1,M1) & datos(X,Y,M2) <-
	for(.range(I,Y,0,-1)){
		.wait(100);
		+bajarFicha(X,I);
		-bajarFicha(X,I);
	};
	+colocarFichaArriba(X);
	-colocarFichaArriba(X);
	.


+agrupacionesFila(X):size(Size) <-	

	for(.range(I,Size-1,0,-1)){
		if(datos(X,I,Color)){
			+findGroups(X,I,Color);
			-findGroups(X,I,Color);
		}
	}.
	
+crearCeldaTablero(I,J,Color,Ficha) :  randomFicha(Ficha, TipoFicha) <-
		+tablero(celda(I,J,0),ficha(Color,TipoFicha)).

	
 //Comunicacion del tablero al jugador indicado.
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
	-mostrarTablero(P);	
	
	for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 };
		 .send(P,tell,size(N)).



//Cambio de turno de un jugador a otro
+cambioTurno(P) : jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurno(P);
				+cambioTurno(P,N,J).


+cambioTurno(P,N,J) : P = player1 | jugadorDescalificado(player1,1) <-
					-cambioTurno(P,N,J);
					-+turnoActual(player2);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player1,J);
					+jugadasPlayer(player1,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").


+cambioTurno(P,N,J) : P = player2 <-
					-cambioTurno(P,N,J);
					-+turnoActual(player1);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player2,J);
					+jugadasPlayer(player2,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").


//Cambio de turno cuando hay un jugador descalificado
+cambioTurnoMismoJugador(P):jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurnoMismoJugador(P);
				+cambioTurnoMismoJugador(P,N,J).
+cambioTurnoMismoJugador(P,N,J) <-
					-cambioTurnoMismoJugador(P,N,J);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(P,J);
					+jugadasPlayer(P,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]").



//Analisis del movimiento solicitado por un jugador
//Movimiento correcto

+turnoTerminado(P): jugadorDescalificado(J,B) & B=1 <- +cambioTurnoMismoJugador(P).
+turnoTerminado(P) <- +cambioTurno(P).

+intercambiarFichas(X,Y,Dir,P) : nextMove(X,Y,NX,NY,Dir) & plNumb(P,PlNumb) <-
	-tablero(celda(X,Y,Own1),ficha(Color1,Tipo1));
	-tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2));
	.send(player1,untell,tablero(celda(X,Y,Own1),ficha(Color1,Tipo1)));
	.send(player1,untell,tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2)));
	.send(player2,untell,tablero(celda(X,Y,Own1),ficha(Color1,Tipo1)));
	.send(player2,untell,tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2)));
	
	//+tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1));
	//+tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2));
	
	+tablero(celda(NX,NY,Own1),ficha(Color1,Tipo1));
	+tablero(celda(X,Y,Own2),ficha(Color2,Tipo2));
	
	.send(player1,tell,tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1)));
	.send(player1,tell,tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2)));
	.send(player2,tell,tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1)));
	.send(player2,tell,tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2)));
	//Pasamos color de 0-5 a escala binaria
	?color(Color1,C1);
	?color(Color2,C2);
	//exchange(C1,X,NX,C2,Y,NY,Tipo1,Tipo2);
	//Para no perder las etiquetas
	deleteSteak(C1,X,Y);
	deleteSteak(C2,NX,NY);
	put(X,Y,C2,Tipo2);
	put(NX,NY,C1,Tipo1);
	.print("Se han intercambiado las fichas entre las posiciones (",X,",",Y,") y (",NX,",",NY,")");
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
	
	/*+findGroups(X,Y,Color2);
	+findGroups(X,Y,Color2);
	-findGroups(NX,NY,Color1);
	-findGroups(NX,NY,Color1);*/
	
	
//Grupo 5 
//por filas
+findGroups(OX,OY,Color): grupo5Fil(OX,OY,Color) <- .print("Agrupacion de 5 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-2,OX+2,OY);-detectarEspecialesHorizontal(OX-2,OX+2,OY);
	+clearNhorizontal(OX-2,OX+2,OY);-clearNhorizontal(OX-2,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ct));?color(Color,C1);put(OX,OY,C1,ct);
	-+puntosMov(8);
	!actualizarPuntos;
	+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
//por columnas
+findGroups(OX,OY,Color): grupo5Col(OX,OY,Color) <- .print("Agrupacion de 5 en Columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-2,OY+2,OX);-detectarEspecialesVertical(OY-2,OY+2,OX);
	+clearNvertical(OY-2,OY+2,OX);-clearNvertical(OY-2,OY+2,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ct));?color(Color,C1);put(OX,OY,C1,ct);
	-+puntosMov(8);
	!actualizarPuntos;
	+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
//Grupo 5 T
+findGroups(OX,OY,Color): grupo5TN(OX,OY,Color)<-.print("Agrupacion de 5 en T normal en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY+1,OY+2,OX);-detectarEspecialesVertical(OY+1,OY+2,OX);
	+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+clearNvertical(OY+1,OY+2,OX);-clearNvertical(OY+1,OY+2,OX);+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY);-caida(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1);
	+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo5TI(OX,OY,Color)<-.print("Agrupacion de 5 en T invertida en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-2,OY-1,OX);-detectarEspecialesVertical(OY-2,OY-1,OX);
	+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+clearNvertical(OY-2,OY-1,OX);-clearNvertical(OY-2,OY-1,OX);+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);
	+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo5TR(OX,OY,Color)<-.print("Agrupacion de 5 en T derecha en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	+detectarEspecialesHorizontal(OX-2,OX-1,OY);-detectarEspecialesHorizontal(OX-2,OX-1,OY);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);+clearNhorizontal(OX-2,OX-1,OY);-clearNhorizontal(OX-2,OX-1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY-2);-caida(OX,OY-2);
	+bajarColumna(OX,OY);-bajarColumna(OX,OY).
+findGroups(OX,OY,Color): grupo5TL(OX,OY,Color)<-.print("Agrupacion de 5 en T izquierda en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	+detectarEspecialesHorizontal(OX+1,OX+2,OY);-detectarEspecialesHorizontal(OX+1,OX+2,OY);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);+clearNhorizontal(OX+1,OX+2,OY);-clearNhorizontal(OX+1,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);
	+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
//Grupo 4 por filas
//A
+findGroups(OX,OY,Color): grupo4FilA(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-1,OX+2,OY);-detectarEspecialesHorizontal(OX-1,OX+2,OY);
	+clearNhorizontal(OX-1,OX+2,OY);-clearNhorizontal(OX-1,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
//B
+findGroups(OX,OY,Color): grupo4FilB(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-2,OX+1,OY);-detectarEspecialesHorizontal(OX-2,OX+1,OY);
	+clearNhorizontal(OX-2,OX+1,OY);-clearNhorizontal(OX-2,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
//Grupo 4 por columnas
//A
+findGroups(OX,OY,Color): grupo4ColA(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-1,OY+2,OX);-detectarEspecialesVertical(OY-1,OY+2,OX);
	+clearNvertical(OY-1,OY+2,OX);-clearNvertical(OY-1,OY+2,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caida(OX,OY-2);-caida(OX,OY-2);+caida(OX,OY);-caida(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
//B
+findGroups(OX,OY,Color): grupo4ColB(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-2,OY+1,OX);-detectarEspecialesVertical(OY-2,OY+1,OX);
	+clearNvertical(OY-2,OY+1,OX);-clearNvertical(OY-2,OY+1,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
//Grupo 4 Cuadrado
+findGroups(OX,OY,Color): grupo4SquareA(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX,OX+1,OY);-detectarEspecialesHorizontal(OX,OX+1,OY);
	+detectarEspecialesHorizontal(OX,OX+1,OY+1);-detectarEspecialesHorizontal(OX,OX+1,OY+1);
	+clearNhorizontal(OX,OX+1,OY);-clearNhorizontal(OX,OX+1,OY);+clearNhorizontal(OX,OX+1,OY+1);-clearNhorizontal(OX,OX+1,OY+1);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+bajarColumna(OX,OY);-bajarColumna(OX,OY);+caida(OX+1,OY-1);-caida(OX+1,OY-1);+bajarColumna(OX+1,OY);-bajarColumna(OX+1,OY).
+findGroups(OX,OY,Color): grupo4SquareB(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-1,OX,OY);-detectarEspecialesHorizontal(OX-1,OX,OY);
	+detectarEspecialesHorizontal(OX-1,OX,OY+1);-detectarEspecialesHorizontal(OX-1,OX,OY+1);
	+clearNhorizontal(OX-1,OX,OY);-clearNhorizontal(OX-1,OX,OY);+clearNhorizontal(OX-1,OX,OY+1);-clearNhorizontal(OX-1,OX,OY+1);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caida(OX-1,OY-1);-caida(OX-1,OY-1);+bajarColumna(OX-1,OY);-bajarColumna(OX-1,OY);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
+findGroups(OX,OY,Color): grupo4SquareC(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX,OX+1,OY-1);-detectarEspecialesHorizontal(OX,OX+1,OY-1);
	+detectarEspecialesHorizontal(OX,OX+1,OY);-detectarEspecialesHorizontal(OX,OX+1,OY);
	+clearNhorizontal(OX,OX+1,OY-1);-clearNhorizontal(OX,OX+1,OY-1);+clearNhorizontal(OX,OX+1,OY);-clearNhorizontal(OX,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+bajarColumna(OX,OY-2);-bajarColumna(OX,OY-2);+caida(OX+1,OY-2);-caida(OX+1,OY-2);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo4SquareD(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-1,OX,OY-1);-detectarEspecialesHorizontal(OX-1,OX,OY-1);
	+detectarEspecialesHorizontal(OX-1,OX,OY);-detectarEspecialesHorizontal(OX-1,OX,OY);
	+clearNhorizontal(OX-1,OX,OY-1);-clearNhorizontal(OX-1,OX,OY-1);+clearNhorizontal(OX-1,OX,OY);-clearNhorizontal(OX-1,OX,OY);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caida(OX-1,OY-2);-caida(OX-1,OY-2);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX,OY-2);-bajarColumna(OX,OY-2).
//Grupo 3 por filas
+findGroups(OX,OY,Color): grupo3Fil(OX,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX,OY-1);-bajarColumna(OX,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo3Fil(OX+1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY+1);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal((OX+1)-1,(OX+1)+1,OY);-detectarEspecialesHorizontal((OX+1)-1,(OX+1)+1,OY);
	+clearNhorizontal((OX+1)-1,(OX+1)+1,OY);-clearNhorizontal((OX+1)-1,(OX+1)+1,OY);
	+bajarColumna((OX+1)-1,OY-1);-bajarColumna((OX+1)-1,OY-1);+bajarColumna((OX+1),OY-1);-bajarColumna((OX+1),OY-1);+bajarColumna((OX+1)+1,OY-1);-bajarColumna((OX+1)+1,OY-1).
+findGroups(OX,OY,Color): grupo3Fil(OX-1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY-1);
	-findGroups(OX,OY,Color);
	+detectarEspecialesHorizontal((OX-1)-1,(OX-1)+1,OY);-detectarEspecialesHorizontal((OX-1)-1,(OX-1)+1,OY);
	+clearNhorizontal((OX-1)-1,(OX-1)+1,OY);-clearNhorizontal((OX-1)-1,(OX-1)+1,OY);
	+bajarColumna((OX-1)-1,OY-1);-bajarColumna((OX-1)-1,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna((OX-1)+1,OY-1);-bajarColumna((OX-1)+1,OY-1).
//Grupo 3 por columnas
+findGroups(OX,OY,Color): grupo3Col(OX,OY,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);
	+caida(OX,OY-2);-caida(OX,OY-2);+caida(OX,OY-1);-caida(OX,OY-1);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
+findGroups(OX,OY,Color): grupo3Col(OX,OY+1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY+1);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical((OY+1)-1,(OY+1)+1,OX);-detectarEspecialesVertical((OY+1)-1,(OY+1)+1,OX);
	+downToken;-downToken;
	+clearNvertical((OY+1)-1,(OY+1)+1,OX);-clearNvertical((OY+1)-1,(OY+1)+1,OX);
	+caida(OX,(OY+1)-2);-caida(OX,(OY+1)-2);+caida(OX,(OY+1)-1);-caida(OX,(OY+1)-1);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
+findGroups(OX,OY,Color): grupo3Col(OX,OY-1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY-1);
	-findGroups(OX,OY,Color);
	+detectarEspecialesVertical((OY-1)-1,(OY-1)+1,OX);-detectarEspecialesVertical((OY-1)-1,(OY-1)+1,OX);
	+clearNvertical((OY-1)-1,(OY-1)+1,OX);-clearNvertical((OY-1)-1,(OY-1)+1,OX);
	+caida(OX,(OY-1)-2);-caida(OX,(OY-1)-2);+caida(OX,(OY-1)-1);-caida(OX,(OY-1)-1);+bajarColumna(OX,OY-1);-bajarColumna(OX,OY-1).	
	
+findGroups(OX,OY,Color)<- .print("No hay ninguna agrupación").

//Borrar en vertical desde un rango
+clearNvertical(Inicio,Fin,Col):turnoActual(P) & nivel(Nivel) <-
	-clearNvertical(Inicio,Fin,Col);
	
	for (.range(I,Inicio,Fin)) {
		if (datos(Col,I,Color,Tipo,Prop)) {
			-tablero(celda(Col,I,_),_);
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			?color(Color,C);
			deleteSteak(C,Col,I);
			if(Tipo=ct){
				//-+puntos(P,Nivel,Puntos+8);
				-+puntosMov(8);
				!actualizarPuntos;
			}
			if(Tipo=co){
				//-+puntos(P,Nivel,Puntos+6);
				-+puntosMov(6);
				!actualizarPuntos;
			}
			if(Tipo=gs){
				//-+puntos(P,Nivel,Puntos+4);
				-+puntosMov(4);
				!actualizarPuntos;
			}
			if(Tipo=ip){
				//-+puntos(P,Nivel,Puntos+2);
				-+puntosMov(2);
				!actualizarPuntos;
			}else{
				//-+puntos(P,Nivel,Puntos+1);
				-+puntosMov(1);
				!actualizarPuntos;
			}
		};
	};
	.wait(15);
.
	
//Borrar en horizontal desde un rando
+clearNhorizontal(Inicio,Fin,Fil):turnoActual(P) & nivel(Nivel) <-
	-clearNhorizontal(Inicio,Fin,Fil);
	
	for (.range(I,Inicio,Fin)) {
		if (datos(I,Fil,Color,Tipo,Prop)) {	
			-tablero(celda(I,Fil,_),_);
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			?color(Color,C);
			deleteSteak(C,I,Fil);
			
			if(Tipo=ct){
				//-+puntos(P,Nivel,Puntos+8);
				-+puntosMov(8);
				!actualizarPuntos;
			}
			if(Tipo=co){
				//-+puntos(P,Nivel,Puntos+6);
				-+puntosMov(6);
				!actualizarPuntos;
			}
			if(Tipo=gs){
				//-+puntos(P,Nivel,Puntos+4);
				-+puntosMov(4);
				!actualizarPuntos;
			}
			if(Tipo=ip){
				//-+puntos(P,Nivel,Puntos+2);
				-+puntosMov(2);
				!actualizarPuntos;
			}else{
				//-+puntos(P,Nivel,Puntos+1);
				-+puntosMov(1);
				!actualizarPuntos;
			}
		};
	};
	.wait(15);
.

+detectarEspecialesHorizontal(Inicio,Fin,Fil):size(Size) <-
	-detectarEspecialesHorizontal(Inicio,Fin,Fil);
	for (.range(I,Inicio,Fin)) {
		if (datos(I,Fil,Color,Tipo,Prop)){
			if(Tipo=ip){
				?dir(D);
				if(D="left" | D="right"){
					+clearNhorizontal(0,Size-1,I);
					-clearNhorizontal(0,Size-1,I);
					+downToken;-downToken;
				}else{
					+clearNvertical(0,Size-1,I);
					-clearNvertical(0,Size-1,I);
					+downToken;-downToken;
				}
			}else{
				if(Tipo=ct){
					+eliminacionMismoColor(Color);
					-eliminacionMismoColor(Color);
					+downToken;-downToken;
				}else{
					if(Tipo=gs){
						+buscarGs(I,Fil);
						-buscarGs(I,Fil);
						if(fichaGs(A,B,Cor)){
							-fichaGs(A,B,Cor);
							-tablero(celda(A,B,_),_);
							?color(Cor,C1);
							deleteSteak(C1,A,B);
							+bajarColumna(A,B-1);
							-bajarColumna(A,B-1);
							+downToken;-downToken;
						};
					}else{
						if(Tipo=co){
							+clearNhorizontal(Fil-1,Fil+1,I-1);
							-clearNhorizontal(Fil-1,Fil+1,I-1);
							+clearNhorizontal(Fil-1,Fil+1,I);
							-clearNhorizontal(Fil-1,Fil+1,I);
							+clearNhorizontal(Fil-1,Fil+1,I+1);
							-clearNhorizontal(Fil-1,Fil+1,I+1);
							+downToken;-downToken;
						}
					}
				}
			}
		}
	}.

+detectarEspecialesVertical(Inicio,Fin,Col):size(Size) <-
	-detectarEspecialesVertical(Inicio,Fin,Col);
	
	for (.range(I,Inicio,Fin)) {
		if (datos(Col,I,Color,Tipo,Prop)){
			if(Tipo=ip){
				?dir(D);
				if(D="left" | D="right"){
					+clearNhorizontal(0,Size-1,I);
					-clearNhorizontal(0,Size-1,I);
					+downToken;-downToken;
				}else{
					+clearNvertical(0,Size-1,Col);
					-clearNvertical(0,Size-1,Col);
					+downToken;-downToken;
				}
			}else{
				if(Tipo=ct){
					+eliminacionMismoColor(Color);
					-eliminacionMismoColor(Color);
					+downToken;-downToken;
				}else{
					if(Tipo=gs){
						+buscarGs(Col,I);
						-buscarGs(Col,I);
						+downToken;-downToken;
						if(fichaGs(A,B,Cor)){
							-fichaGs(A,B,Cor);
							-tablero(celda(A,B,_),_);
							?color(Cor,C1);
							deleteSteak(C1,A,B);
							+bajarColumna(A,B-1);
							-bajarColumna(A,B-1);
							+downToken;-downToken;
						};
						
					}else{
						if(Tipo=co){
							+clearNhorizontal(Col-1,Col+1,I+1);
							-clearNhorizontal(Col-1,Col+1,I+1);
							+clearNhorizontal(Col-1,Col+1,I);
							-clearNhorizontal(Col-1,Col+1,I);
							+clearNhorizontal(Col-1,Col+1,I-1);
							-clearNhorizontal(Col-1,Col+1,I-1);
							+downToken;-downToken;
						}
					}
				}
			}
		}
	}.
	
+eliminacionMismoColor(Color):size(N) <-
	-eliminacionMismoColor(Color);
	?color(Color,C1);
	for (.range(I,N-1,0,-1) ) {
		for ( .range(J,0,N-1) ) {
			if(datos(I,J,Color)){
				-tablero(celda(I,J,_),_);
				deleteSteak(C1,I,J);
				//+bajarColumna(I,J-1);
				//-bajarColumna(I,J-1);
			}
		}
	}
	.

+buscarGs(X,Y):size(N) <-
	-buscarGs;
	-fichaGs(_,_,_);
	for ( .range(I,0,N-1) ) {
		for ( .range(J,(N-1),0,-1) ) {
			if(datos(I,J,Color,gs,_) & not(X=I & Y=J)){
				-+fichaGs(I,J,Color);
			}
		}
	}
	.
+!actualizarPuntos: turnoActual(P) & nivel(L) & puntosMov(Puntos) <- 
	.print("actualizando..");
	.wait(150);
	if(P=player1){
		?player1Puntos(P1);
		-+player1Puntos(P1+Puntos);
		.print(P,"PUNTOS: ",Puntos+P1);
	}else{
		?player2Puntos(P2);
		-+player2Puntos(P2+Puntos);
		.print(P,"PUNTOS: ",Puntos+P2);
	}
	.wait(1000);
	//.send(P,tell,totalPoints(T));
	-+puntosMov(0).
	
+!ganador:nivel(L) & L>=3 <-
	.wait(3000);
	?player1Puntos(P1);
	?player2Puntos(P2);
	.print("player1 Puntos:",P1);
	.print("player2 Puntos:",P2)
	if(P1=P2){
		.print("Empate");
	}else{
		if(P1>P2){
			.print("Ganador del nivel ",L," player1");
		}else{
			.print("Ganador del nivel ",L," player2");
		}
	}
	.

+!ganador:nivel(L) <-
	.print("Recopilando Puntos...");
	.wait(3000);
	?player1Puntos(P1);
	?player2Puntos(P2);
	.print("player1 Puntos:",P1);
	.print("player2 Puntos:",P2);
	-+puntosPlayer1(L,P1);
	-+puntosPlayer2(L,P2);
	if(P1=P2){
		.print("Empate");
	}else{
		if(P1>P2){
			.print("Ganador del nivel ",L," player1");
		}else{
			.print("Ganador del nivel ",L," player2");
		}
	}
	-+player1Puntos(0);
	-+player2Puntos(0);
	.wait(1000);
	-+nivel(L+1);
	-+jugadasRestantes(10);
	-numVecesColor(0,_);
	-numVecesColor(1,_);
	-numVecesColor(2,_);
	-numVecesColor(3,_);
	-numVecesColor(4,_);
	-numVecesColor(5,_);
	+numVecesColor(0,0);
	+numVecesColor(1,0);
	+numVecesColor(2,0);
	+numVecesColor(3,0);
	+numVecesColor(4,0);
	+numVecesColor(5,0);
	-jugadasPlayer(player2,_);
	+jugadasPlayer(player2,0);
	-jugadasPlayer(player1,_);
	+jugadasPlayer(player1,0);
	
	-+numObs(0);
	+borrarTablero;
	-borrarTablero;
	!startGame;
	.
+borrarTablero:size(N) <-
	-borrarTablero;
	for (.range(I,0,N-1) ) {
		for ( .range(J,0,N-1) ) {
			if(datos(I,J,Color)){
				-tablero(celda(I,J,_),_);
				?color(Color,C1);
				deleteSteak(C1,I,J);
			}
		}
	}
	.
	
+Default[source(A)]: not A=self  <- .print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


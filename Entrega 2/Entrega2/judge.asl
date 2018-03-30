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
verificado(1).
caido(0).

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
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,C) & datos(X-1,Y,C) & datos(X,Y-1,C) & datos(X-1,Y-1,C).	

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
nivel(1).
jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

grupoEnUltimaEjecucion(1).
rodada(0).
posRodar(-1).
comprobarCT(1).

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
	+mostrarTablero(player1);
	-mostrarTablero(player1);
	+mostrarTablero(player2);
	-mostrarTablero(player2);
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
	.print("Preparando...");
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

+borrarFlags <-
	-borrarFlags;
	.findall(grupos5(A1,B1,Cor1),grupos5(A1,B1,Cor1),L1);for ( .member(K1,L1) ) {-K1;};
	.findall(gruposT(A2,B2,Cor2),gruposT(A2,B2,Cor2),L2);for ( .member(K2,L2) ) {-K2;};
	.findall(grupos4(A3,B3,Cor3),grupos4(A3,B3,Cor3),L3);for ( .member(K3,L3) ) {-K3;};
	.findall(gruposCuadrado(A4,B4,Cor4),gruposCuadrado(A4,B4,Cor4),L4);for ( .member(K4,L4) ) {-K4;};
	.findall(grupos3(A5,B5,Cor5),grupos3(A5,B5,Cor5),L5);for ( .member(K5,L5) ) {-K5;};
	.
	 
+prioridadAgrupaciones:size(Size) <-
	-prioridadAgrupaciones;
	
	+borrarFlags;
	-borrarFlags;
	
	/*-grupos5(_,_,_);
	-gruposT(_,_,_);
	-grupos4(_,_,_);
	-gruposCuadrado(_,_,_);
	-grupos3(_,_,_);*/

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
	.wait(300);
	deleteSteak(C2,NX,NY);
	.wait(300);
	put(X,Y,C2,Tipo2);
	.wait(300);
	put(NX,NY,C1,Tipo1);
	.print("Se han intercambiado las fichas entre las posiciones (",X,",",Y,") y (",NX,",",NY,")");
	+prioridadAgrupaciones;
	-prioridadAgrupaciones.
	
	
//Grupo 5 
//por filas
+findGroups(OX,OY,Color): grupo5Fil(OX,OY,Color) <- .print("Agrupacion de 5 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-2,OX+2,OY);-detectarEspecialesHorizontal(OX-2,OX+2,OY);
	+agrupacionesContiguas(-1,-1,-1,OX-2,OX+2,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-2,OX+2,OY);
	+clearNhorizontal(OX-2,OX+2,OY);-clearNhorizontal(OX-2,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ct));?color(Color,C1);put(OX,OY,C1,ct);
	-+puntosMov(8);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
//por columnas
+findGroups(OX,OY,Color): grupo5Col(OX,OY,Color) <- .print("Agrupacion de 5 en Columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-2,OY+2,OX);-detectarEspecialesVertical(OY-2,OY+2,OX);
	+agrupacionesContiguas(OY-2,OY+2,OX,-1,-1,-1);
	+agrupacionesContiguas(OY-2,OY+2,OX,-1,-1,-1);
	+clearNvertical(OY-2,OY+2,OX);-clearNvertical(OY-2,OY+2,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ct));?color(Color,C1);put(OX,OY,C1,ct);
	-+puntosMov(8);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
	
//Grupo 5 T
+findGroups(OX,OY,Color): grupo5TN(OX,OY,Color)<-.print("Agrupacion de 5 en T normal en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY+1,OY+2,OX);-detectarEspecialesVertical(OY+1,OY+2,OX);
	//+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+agrupacionesContiguas(OY,OY+2,OX,OX-1,OX+1,OY);
	-agrupacionesContiguas(OY,OY+2,OX,OX-1,OX+1,OY);
	+clearNvertical(OY,OY+2,OX);-clearNvertical(OY,OY+2,OX);+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas;
	//+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY);-caida(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1);
	//+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
	.
+findGroups(OX,OY,Color): grupo5TI(OX,OY,Color)<-.print("Agrupacion de 5 en T invertida en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-2,OY-1,OX);-detectarEspecialesVertical(OY-2,OY-1,OX);
	//+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+agrupacionesContiguas(OY-2,OY,OX,OX-1,OX+1,OY);
	-agrupacionesContiguas(OY-2,OY,OX,OX-1,OX+1,OY);
	+clearNvertical(OY-2,OY,OX);-clearNvertical(OY-2,OY,OX);+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);
	//+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo5TR(OX,OY,Color)<-.print("Agrupacion de 5 en T derecha en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	//+detectarEspecialesHorizontal(OX-2,OX-1,OY);-detectarEspecialesHorizontal(OX-2,OX-1,OY);
	+agrupacionesContiguas(OY-1,OY+1,OX,OX-2,OX,OY);
	-agrupacionesContiguas(OY-1,OY+1,OX,OX-2,OX,OY);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);+clearNhorizontal(OX-2,OX,OY);-clearNhorizontal(OX-2,OX,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	//+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+caida(OX,OY-2);-caida(OX,OY-2);
	//+bajarColumna(OX,OY);-bajarColumna(OX,OY).
	+caidaFichas;
	-caidaFichas.
+findGroups(OX,OY,Color): grupo5TL(OX,OY,Color)<-.print("Agrupacion de 5 en T izquierda en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	//+detectarEspecialesHorizontal(OX+1,OX+2,OY);-detectarEspecialesHorizontal(OX+1,OX+2,OY);
	+agrupacionesContiguas(OY-1,OY+1,OX,OX,OX+2,OY);
	-agrupacionesContiguas(OY-1,OY+1,OX,OX,OX+2,OY);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);+clearNhorizontal(OX,OX+2,OY);-clearNhorizontal(OX,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,co));?color(Color,C1);put(OX,OY,C1,co);
	-+puntosMov(6);
	!actualizarPuntos;
	//+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);
	//+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
	+caidaFichas;
	-caidaFichas.
//Grupo 4 por filas
//A
+findGroups(OX,OY,Color): grupo4FilA(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-1,OX+2,OY);-detectarEspecialesHorizontal(OX-1,OX+2,OY);
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX+2,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX+2,OY);
	+clearNhorizontal(OX-1,OX+2,OY);-clearNhorizontal(OX-1,OX+2,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1);+bajarColumna(OX+2,OY-1);-bajarColumna(OX+2,OY-1).
//B
+findGroups(OX,OY,Color): grupo4FilB(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-2,OX+1,OY);-detectarEspecialesHorizontal(OX-2,OX+1,OY);
	+agrupacionesContiguas(-1,-1,-1,OX-2,OX+1,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-2,OX+1,OY);
	+clearNhorizontal(OX-2,OX+1,OY);-clearNhorizontal(OX-2,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX-2,OY-1);-bajarColumna(OX-2,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
//Grupo 4 por columnas
//A
+findGroups(OX,OY,Color): grupo4ColA(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-1,OY+2,OX);-detectarEspecialesVertical(OY-1,OY+2,OX);
	+agrupacionesContiguas(OY-1,OY+2,OX,-1,-1,-1);
	-agrupacionesContiguas(OY-1,OY+2,OX,-1,-1,-1);
	+clearNvertical(OY-1,OY+2,OX);-clearNvertical(OY-1,OY+2,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+caida(OX,OY-2);-caida(OX,OY-2);+caida(OX,OY);-caida(OX,OY);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
//B
+findGroups(OX,OY,Color): grupo4ColB(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-2,OY+1,OX);-detectarEspecialesVertical(OY-2,OY+1,OX);
	+agrupacionesContiguas(OY-2,OY+1,OX,-1,-1,-1);
	-agrupacionesContiguas(OY-2,OY+1,OX,-1,-1,-1);
	+clearNvertical(OY-2,OY+1,OX);-clearNvertical(OY-2,OY+1,OX);
	+tablero(celda(OX,OY,0),ficha(Color,ip));?color(Color,C1);put(OX,OY,C1,ip);
	-+puntosMov(2);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+caida(OX,OY-3);-caida(OX,OY-3);+caida(OX,OY-2);-caida(OX,OY-2);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
//Grupo 4 Cuadrado
+findGroups(OX,OY,Color): grupo4SquareA(OX,OY,Color)<-.print("Agrupacion de 4A en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX,OX+1,OY);-detectarEspecialesHorizontal(OX,OX+1,OY);
	//+detectarEspecialesHorizontal(OX,OX+1,OY+1);-detectarEspecialesHorizontal(OX,OX+1,OY+1);
	+agrupacionesContiguasSquare(OX,OX+1,OY,OX,OX+1,OY+1);
	-agrupacionesContiguasSquare(OX,OX+1,OY,OX,OX+1,OY+1);
	/*
	+agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY);
	-agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY);
	+agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY+1);
	-agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY+1);
	*/
	+clearNhorizontal(OX,OX+1,OY);-clearNhorizontal(OX,OX+1,OY);+clearNhorizontal(OX,OX+1,OY+1);-clearNhorizontal(OX,OX+1,OY+1);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX,OY);-bajarColumna(OX,OY);+caida(OX+1,OY-1);-caida(OX+1,OY-1);+bajarColumna(OX+1,OY);-bajarColumna(OX+1,OY).
+findGroups(OX,OY,Color): grupo4SquareB(OX,OY,Color)<-.print("Agrupacion de 4B en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-1,OX,OY);-detectarEspecialesHorizontal(OX-1,OX,OY);
	//+detectarEspecialesHorizontal(OX-1,OX,OY+1);-detectarEspecialesHorizontal(OX-1,OX,OY+1);
	+agrupacionesContiguasSquare(OX-1,OX,OY,OX-1,OX,OY+1);
	-agrupacionesContiguasSquare(OX-1,OX,OY,OX-1,OX,OY+1);
	/*
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY);
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY+1);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY+1);
	*/

	+clearNhorizontal(OX-1,OX,OY);-clearNhorizontal(OX-1,OX,OY);+clearNhorizontal(OX-1,OX,OY+1);-clearNhorizontal(OX-1,OX,OY+1);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+caida(OX-1,OY-1);-caida(OX-1,OY-1);+bajarColumna(OX-1,OY);-bajarColumna(OX-1,OY);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
+findGroups(OX,OY,Color): grupo4SquareC(OX,OY,Color)<-.print("Agrupacion de 4C en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX,OX+1,OY-1);-detectarEspecialesHorizontal(OX,OX+1,OY-1);
	//+detectarEspecialesHorizontal(OX,OX+1,OY);-detectarEspecialesHorizontal(OX,OX+1,OY);
	+agrupacionesContiguasSquare(OX,OX+1,OY-1,OX,OX+1,OY);
	-agrupacionesContiguasSquare(OX,OX+1,OY-1,OX,OX+1,OY);
	/*
	+agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY-1);
	-agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY-1);
	+agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY);
	-agrupacionesContiguas(-1,-1,-1,OX,OX+1,OY);
	*/
	+clearNhorizontal(OX,OX+1,OY-1);-clearNhorizontal(OX,OX+1,OY-1);+clearNhorizontal(OX,OX+1,OY);-clearNhorizontal(OX,OX+1,OY);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX,OY-2);-bajarColumna(OX,OY-2);+caida(OX+1,OY-2);-caida(OX+1,OY-2);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo4SquareD(OX,OY,Color)<-.print("Agrupacion de 4D en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-1,OX,OY-1);-detectarEspecialesHorizontal(OX-1,OX,OY-1);
	//+detectarEspecialesHorizontal(OX-1,OX,OY);-detectarEspecialesHorizontal(OX-1,OX,OY);
	+agrupacionesContiguasSquare(OX-1,OX,OY-1,OX-1,OX,OY);
	-agrupacionesContiguasSquare(OX-1,OX,OY-1,OX-1,OX,OY);
	/*
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY-1);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY-1);
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX,OY);
	*/
	+clearNhorizontal(OX-1,OX,OY-1);-clearNhorizontal(OX-1,OX,OY-1);+clearNhorizontal(OX-1,OX,OY);-clearNhorizontal(OX-1,OX,OY);
	+tablero(celda(OX,OY,0),ficha(Color,gs));?color(Color,C1);put(OX,OY,C1,gs);
	-+puntosMov(4);
	!actualizarPuntos;
	+caidaFichas;
	-caidaFichas.
	//+caida(OX-1,OY-2);-caida(OX-1,OY-2);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX,OY-2);-bajarColumna(OX,OY-2).
//Grupo 3 por filas
+findGroups(OX,OY,Color): grupo3Fil(OX,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal(OX-1,OX+1,OY);-detectarEspecialesHorizontal(OX-1,OX+1,OY);
	+agrupacionesContiguas(-1,-1,-1,OX-1,OX+1,OY);
	-agrupacionesContiguas(-1,-1,-1,OX-1,OX+1,OY);
	+clearNhorizontal(OX-1,OX+1,OY);-clearNhorizontal(OX-1,OX+1,OY);
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna(OX,OY-1);-bajarColumna(OX,OY-1);+bajarColumna(OX+1,OY-1);-bajarColumna(OX+1,OY-1).
+findGroups(OX,OY,Color): grupo3Fil(OX+1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY+1);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal((OX+1)-1,(OX+1)+1,OY);-detectarEspecialesHorizontal((OX+1)-1,(OX+1)+1,OY);
	+agrupacionesContiguas(-1,-1,-1,(OX+1)-1,(OX+1)+1,OY);
	-agrupacionesContiguas(-1,-1,-1,(OX+1)-1,(OX+1)+1,OY);
	+clearNhorizontal((OX+1)-1,(OX+1)+1,OY);-clearNhorizontal((OX+1)-1,(OX+1)+1,OY);
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna((OX+1)-1,OY-1);-bajarColumna((OX+1)-1,OY-1);+bajarColumna((OX+1),OY-1);-bajarColumna((OX+1),OY-1);+bajarColumna((OX+1)+1,OY-1);-bajarColumna((OX+1)+1,OY-1).
+findGroups(OX,OY,Color): grupo3Fil(OX-1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY-1);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesHorizontal((OX-1)-1,(OX-1)+1,OY);-detectarEspecialesHorizontal((OX-1)-1,(OX-1)+1,OY);
	+agrupacionesContiguas(-1,-1,-1,(OX-1)-1,(OX-1)+1,OY);
	-agrupacionesContiguas(-1,-1,-1,(OX-1)-1,(OX-1)+1,OY);
	+clearNhorizontal((OX-1)-1,(OX-1)+1,OY);-clearNhorizontal((OX-1)-1,(OX-1)+1,OY);
	+caidaFichas;
	-caidaFichas.
	//+bajarColumna((OX-1)-1,OY-1);-bajarColumna((OX-1)-1,OY-1);+bajarColumna(OX-1,OY-1);-bajarColumna(OX-1,OY-1);+bajarColumna((OX-1)+1,OY-1);-bajarColumna((OX-1)+1,OY-1).
//Grupo 3 por columnas
+findGroups(OX,OY,Color): grupo3Col(OX,OY,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical(OY-1,OY+1,OX);-detectarEspecialesVertical(OY-1,OY+1,OX);
	+agrupacionesContiguas(OY-1,OY+1,OX,-1,-1,-1);
	-agrupacionesContiguas(OY-1,OY+1,OX,-1,-1,-1);
	+clearNvertical(OY-1,OY+1,OX);-clearNvertical(OY-1,OY+1,OX);
	+caidaFichas;
	-caidaFichas.
	//+caida(OX,OY-2);-caida(OX,OY-2);+caida(OX,OY-1);-caida(OX,OY-1);+bajarColumna(OX,OY);-bajarColumna(OX,OY).
+findGroups(OX,OY,Color): grupo3Col(OX,OY+1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY+1);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical((OY+1)-1,(OY+1)+1,OX);-detectarEspecialesVertical((OY+1)-1,(OY+1)+1,OX);
	//+caida(OX,(OY+1)-2);-caida(OX,(OY+1)-2);+caida(OX,(OY+1)-1);-caida(OX,(OY+1)-1);+bajarColumna(OX,OY+1);-bajarColumna(OX,OY+1).
	+agrupacionesContiguas((OY+1)-1,(OY+1)+1,OX,-1,-1,-1);
	-agrupacionesContiguas((OY+1)-1,(OY+1)+1,OX,-1,-1,-1);
	+clearNvertical((OY+1)-1,(OY+1)+1,OX);-clearNvertical((OY+1)-1,(OY+1)+1,OX);
	+caidaFichas;
	-caidaFichas.
+findGroups(OX,OY,Color): grupo3Col(OX,OY-1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY-1);
	-findGroups(OX,OY,Color);
	//+detectarEspecialesVertical((OY-1)-1,(OY-1)+1,OX);-detectarEspecialesVertical((OY-1)-1,(OY-1)+1,OX);
	+agrupacionesContiguas((OY-1)-1,(OY-1)+1,OX,-1,-1,-1);
	-agrupacionesContiguas((OY-1)-1,(OY-1)+1,OX,-1,-1,-1);
	+clearNvertical((OY-1)-1,(OY-1)+1,OX);-clearNvertical((OY-1)-1,(OY-1)+1,OX);
	+caidaFichas;
	-caidaFichas.
	//+caida(OX,(OY-1)-2);-caida(OX,(OY-1)-2);+caida(OX,(OY-1)-1);-caida(OX,(OY-1)-1);+bajarColumna(OX,OY-1);-bajarColumna(OX,OY-1).	
	
+findGroups(OX,OY,Color)<- .print("No hay ninguna agrupación").

//Borrar en vertical desde un rango
+clearNvertical(Inicio,Fin,Col):turnoActual(P) & nivel(Nivel) <-
	-clearNvertical(Inicio,Fin,Col);
	
	for (.range(I,Inicio,Fin)) {
		if (datos(Col,I,Color,Tipo,Prop) & not esObstaculo(Col,I)) {
			
			-tablero(celda(Col,I,_),_);
			?color(Color,C);
			deleteSteak(C,Col,I);
			if(Tipo=ct){
				//-+puntos(P,Nivel,Puntos+8);
				+explosionCT(Color);
				-explosionCT(Color);
				-+puntosMov(8);
				!actualizarPuntos;
			}
			if(Tipo=co){
				//-+puntos(P,Nivel,Puntos+6);
				+explosionCO(Col,I);
				-explosionCO(Col,I);
				-+puntosMov(6);
				!actualizarPuntos;
			}
			if(Tipo=gs){
				//-+puntos(P,Nivel,Puntos+4);
				+explosionGS;
				-explosionGS;
				-+puntosMov(4);
				!actualizarPuntos;
			}
			if(Tipo=ip){
				//-+puntos(P,Nivel,Puntos+2);
				+explosionIP(Col,I);
				-explosionIP(Col,I);
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
		if (datos(I,Fil,Color,Tipo,Prop) & not esObstaculo(I,Fil)) {	
			-tablero(celda(I,Fil,_),_);
			?color(Color,C);
			deleteSteak(C,I,Fil);
			-+verificado(1);
			if(Tipo=ct){
				//-+puntos(P,Nivel,Puntos+8);
				+explosionCT(Color);
				-explosionCT(Color);
				-+puntosMov(8);
				!actualizarPuntos;
			}
			if(Tipo=co){
				//-+puntos(P,Nivel,Puntos+6);
				+explosionCO(I,Fil);
				-explosionCO(I,Fil);
				-+puntosMov(6);
				!actualizarPuntos;
			}
			if(Tipo=gs){
				//-+puntos(P,Nivel,Puntos+4);
				+explosionGS;
				-explosionGS;
				-+puntosMov(4);
				!actualizarPuntos;
			}
			if(Tipo=ip){
				//-+puntos(P,Nivel,Puntos+2);
				+explosionIP(I,Fil);
				-explosionIP(I,Fil);
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
+agrupacionesContiguasSquare(InicioH1,FinH1,Fil1,InicioH2,FinH2,Fil2) <-
	-agrupacionesContiguasSquare(InicioH1,FinH1,Fil1,InicioH2,FinH2,Fil2);

		for(.range(X1,InicioH1,FinH1)){
			if(datos(X1,Fil1,C)){
				if(grupo5Fil(X1,Fil1,C)){+grupoFil1(X1,Fil1,C);}
				if(grupo5Col(X1,Fil1,C)){+grupoCol1(X1,Fil1,C);}
				
				if(grupo5TN(X1,Fil1,C)){+grupo5TN1(X1,Fil1,C);}	
				if(grupo5TI(X1,Fil1,C)){+grupo5TI1(X1,Fil1,C);}
				if(grupo5TR(X1,Fil1,C)){+grupo5TR1(X1,Fil1,C);}
				if(grupo5TL(X1,Fil1,C)){+grupo5TL1(X1,Fil1,C);}
				
				if(grupo4FilA(X1,Fil1,C)){+grupo4FilA1(X1,Fil1,C);}
				if(grupo4FilA(X1+1,Fil1,C)){+grupo4FilA1(X1+1,Fil1,C);}
				if(grupo4FilA(X1-1,Fil1,C)){+grupo4FilA1(X1-1,Fil1,C);}
				
				if(grupo4FilB(X1,Fil1,C)){+grupo4FilB1(X1,Fil1,C);}
				if(grupo4FilB(X1+1,Fil1,C)){+grupo4FilB1(X1+1,Fil1,C);}
				if(grupo4FilB(X1-1,Fil1,C)){+grupo4FilB1(X1-1,Fil1,C);}
				
				if(grupo4ColA(X1,Fil1,C)){+grupo4ColA1(X1,Fil1,C);}
				if(grupo4ColA(X1,Fil1+1,C)){+grupo4ColA1(X1,Fil1+1,C);}
				if(grupo4ColA(X1,Fil1-1,C)){+grupo4ColA1(X1,Fil1-1,C);}
				
				if(grupo4ColB(X1,Fil1,C)){+grupo4ColB1(X1,Fil1,C);}
				if(grupo4ColB(X1,Fil1+1,C)){+grupo4ColB1(X1,Fil1+1,C);}
				if(grupo4ColB(X1,Fil1-1,C)){+grupo4ColB1(X1,Fil1-1,C);}
				
				if(grupo4SquareA(X1,Fil1,C)){+grupoSquareA1(X1,Fil1,C);}
				if(grupo4SquareB(X1,Fil1,C)){+grupoSquareB1(X1,Fil1,C);}
				if(grupo4SquareC(X1,Fil1,C)){+grupoSquareC1(X1,Fil1,C);}
				if(grupo4SquareD(X1,Fil1,C)){+grupoSquareD1(X1,Fil1,C);}
				
				if(grupo3Fil(X1,Fil1,C)){+grupo3Fil1(X1,Fil1,C);}
				if(grupo3Fil(X1+1,Fil1,C)){+grupo3Fil1(X1+1,Fil1,C);}
				if(grupo3Fil(X1-1,Fil1,C)){+grupo3Fil1(X1-1,Fil1,C);}
				
				if(grupo3Col(X1,Fil1,C)){+grupo3Col1(X1,Fil1,C);}
				if(grupo3Col(X1,Fil1+1,C)){+grupo3Col1(X1,Fil1+1,C);}
				if(grupo3Col(X1,Fil1-1,C)){+grupo3Col1(X1,Fil1-1,C);}
			}
		}
	
		for(.range(X2,InicioH2,FinH2)){
			if(datos(X2,Fil2,C)){
				if(grupo5Fil(X2,Fil2,C)){+grupoFil1(X2,Fil2,C);}
				if(grupo5Col(X2,Fil2,C)){+grupoCol1(X2,Fil2,C);}
				
				if(grupo5TN(X2,Fil2,C)){+grupo5TN1(X2,Fil2,C);}	
				if(grupo5TI(X2,Fil2,C)){+grupo5TI1(X2,Fil2,C);}
				if(grupo5TR(X2,Fil2,C)){+grupo5TR1(X2,Fil2,C);}
				if(grupo5TL(X2,Fil2,C)){+grupo5TL1(X2,Fil2,C);}
				
				if(grupo4FilA(X2,Fil2,C)){+grupo4FilA1(X2,Fil2,C);}
				if(grupo4FilA(X2+1,Fil2,C)){+grupo4FilA1(X2+1,Fil2,C);}
				if(grupo4FilA(X2-1,Fil2,C)){+grupo4FilA1(X2-1,Fil2,C);}
				
				if(grupo4FilB(X2,Fil2,C)){+grupo4FilB1(X2,Fil2,C);}
				if(grupo4FilB(X2+1,Fil2,C)){+grupo4FilB1(X2+1,Fil2,C);}
				if(grupo4FilB(X2-1,Fil2,C)){+grupo4FilB1(X2-1,Fil2,C);}
				
				if(grupo4ColA(X2,Fil2,C)){+grupo4ColA1(X2,Fil2,C);}
				if(grupo4ColA(X2,Fil2-1,C)){+grupo4ColA1(X2,Fil2-1,C);}
				if(grupo4ColA(X2,Fil2+1,C)){+grupo4ColA1(X2,Fil2+1,C);}
				
				if(grupo4ColB(X2,Fil2,C)){+grupo4ColB1(X2,Fil2,C);}
				if(grupo4ColB(X2,Fil2-1,C)){+grupo4ColB1(X2,Fil2-1,C);}
				if(grupo4ColB(X2,Fil2+1,C)){+grupo4ColB1(X2,Fil2+1,C);}
				
				if(grupo4SquareA(X2,Fil2,C)){+grupoSquareA1(X2,Fil2,C);}
				if(grupo4SquareB(X2,Fil2,C)){+grupoSquareB1(X2,Fil2,C);}
				if(grupo4SquareC(X2,Fil2,C)){+grupoSquareC1(X2,Fil2,C);}
				if(grupo4SquareD(X2,Fil2,C)){+grupoSquareD1(X2,Fil2,C);}
				
				
				if(grupo3Fil(X2,Fil2,C)){+grupo3Fil1(X2,Fil2,C);}
				if(grupo3Fil(X2+1,Fil2,C)){+grupo3Fil1(X2+1,Fil2,C);}
				if(grupo3Fil(X2-1,Fil2,C)){+grupo3Fil1(X2-1,Fil2,C);}
				
				if(grupo3Col(X2,Fil2,C)){+grupo3Col1(X2,Fil2,C);}
				if(grupo3Col(X2,Fil2+1,C)){+grupo3Col1(X2,Fil2+1,C);}
				if(grupo3Col(X2,Fil2-1,C)){+grupo3Col1(X2,Fil2-1,C);}
			}
		}
		
	.findall(eliminarGrupo5Fil(A1,B1,Cor1),grupoFil1(A1,B1,Cor1),L1);for ( .member(K1,L1) ) {+K1;-K1;};
	.findall(eliminarGrupo5Col(A2,B2,Cor2),grupoCol1(A2,B2,Cor2),L2);for ( .member(K2,L2) ) {+K2;-K2;};
	
	.findall(eliminarGrupo5TN(A3,B3,Cor3),grupo5TN1(A3,B3,Cor3),L3);for ( .member(K3,L3) ) {+K3;-K3;};
	.findall(eliminarGrupo5TI(A4,B4,Cor4),grupo5TI1(A4,B4,Cor4),L4);for ( .member(K4,L4) ) {+K4;-K4;};
	.findall(eliminarGrupo5TR(A5,B5,Cor5),grupo5TR1(A5,B5,Cor5),L5);for ( .member(K5,L5) ) {+K5;-K5;};
	.findall(eliminarGrupo5TL(A6,B6,Cor6),grupo5TL1(A6,B6,Cor6),L6);for ( .member(K6,L6) ) {+K6;-K6;};
	
	.findall(eliminarGrupo4FilA(A7,B7,Cor7),grupo4FilA1(A7,B7,Cor7),L7);for ( .member(K7,L7) ) {+K7;-K7;};
	.findall(eliminarGrupo4FilB(A8,B8,Cor8),grupo4FilB1(A8,B8,Cor8),L8);for ( .member(K8,L8) ) {+K8;-K8;};
	.findall(eliminarGrupo4ColA(A9,B9,Cor9),grupo4ColA1(A9,B9,Cor9),L9);for ( .member(K9,L9) ) {+K9;-K9;};
	.findall(eliminarGrupo4ColB(A10,B10,Cor10),grupo4ColB1(A10,B10,Cor10),L10);for ( .member(K10,L10) ) {+K10;-K10;};
		
	.findall(eliminarGrupoSquareA(A11,B11,Cor11),grupoSquareA1(A11,B11,Cor11),L11);for ( .member(K11,L11) ) {+K11;-K11;};
	.findall(eliminarGrupoSquareB(A12,B12,Cor12),grupoSquareB1(A12,B12,Cor12),L12);for ( .member(K12,L12) ) {+K12;-K12;};
	.findall(eliminarGrupoSquareC(A13,B13,Cor13),grupoSquareC1(A13,B13,Cor13),L13);for ( .member(K13,L13) ) {+K13;-K13;};
	.findall(eliminarGrupoSquareD(A14,B14,Cor14),grupoSquareD1(A14,B14,Cor14),L14);for ( .member(K14,L14) ) {+K14;-K14;};
	
	.findall(eliminarGrupo3Fil(A15,B15,Cor15),grupo3Fil1(A15,B15,Cor15),L15);for ( .member(K15,L15) ) {+K15;-K15;};
	.findall(eliminarGrupo3Col(A16,B16,Cor16),grupo3Col1(A16,B16,Cor16),L16);for ( .member(K16,L16) ) {+K16;-K16;};
	
	+borrarBanderas;
	-borrarBanderas.

+agrupacionesContiguas(InicioV,FinV,Col,InicioH,FinH,Fil):size(Size) <-
	-agrupacionesContiguas(InicioV,FinV,Col,InicioH,FinH,Fil);
	//-g5(_,_,_);-gt(_,_,_);-gc(_,_,_);-g4(_,_,_);-g3(_,_,_);
	.print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
	if(InicioV > 0){
		for(.range(Y,InicioV,FinV)){
			if(datos(Col,Y,C)){
				
				if(grupo5Fil(Col,Y,C)){+grupoFil1(Col,Y,C);}
				if(grupo5Col(Col,Y,C)){+grupoCol1(Col,Y,C);}
				
				if(grupo5TN(Col,Y,C)){+grupo5TN1(Col,Y,C);}	
				if(grupo5TI(Col,Y,C)){+grupo5TI1(Col,Y,C);}
				if(grupo5TR(Col,Y,C)){+grupo5TR1(Col,Y,C);}
				if(grupo5TL(Col,Y,C)){+grupo5TL1(Col,Y,C);}
				
				if(grupo4FilA(Col,Y,C)){+grupo4FilA1(Col,Y,C);}
				if(grupo4FilA(Col+1,Y,C)){+grupo4FilA1(Col+1,Y,C);}
				if(grupo4FilA(Col-1,Y,C)){+grupo4FilA1(Col-1,Y,C);}
				
				if(grupo4FilB(Col,Y,C)){+grupo4FilB1(Col,Y,C);}
				if(grupo4FilB(Col+1,Y,C)){+grupo4FilB1(Col+1,Y,C);}
				if(grupo4FilB(Col-1,Y,C)){+grupo4FilB1(Col-1,Y,C);}
				
				if(grupo4ColA(Col,Y,C)){+grupo4ColA1(Col,Y,C);}
				if(grupo4ColA(Col,Y+1,C)){+grupo4ColA1(Col,Y+1,C);}
				if(grupo4ColA(Col,Y-1,C)){+grupo4ColA1(Col,Y-1,C);}
				
				if(grupo4ColB(Col,Y,C)){+grupo4ColB1(Col,Y,C);}
				if(grupo4ColB(Col,Y+1,C)){+grupo4ColB1(Col,Y+1,C);}
				if(grupo4ColB(Col,Y-1,C)){+grupo4ColB1(Col,Y-1,C);}
				
				if(grupo4SquareA(Col,Y,C)){+grupoSquareA1(Col,Y,C);}
				if(grupo4SquareB(Col,Y,C)){+grupoSquareB1(Col,Y,C);}
				if(grupo4SquareC(Col,Y,C)){+grupoSquareC1(Col,Y,C);}
				if(grupo4SquareD(Col,Y,C)){+grupoSquareD1(Col,Y,C);}
				
				
				if(grupo3Fil(Col,Y,C)){+grupo3Fil1(Col,Y,C);}
				if(grupo3Fil(Col+1,Y,C)){+grupo3Fil1(Col+1,Y,C);}
				if(grupo3Fil(Col-1,Y,C)){+grupo3Fil1(Col-1,Y,C);}
				
				if(grupo3Col(Col,Y,C)){+grupo3Col1(Col,Y,C);}
				if(grupo3Col(Col,Y+1,C)){+grupo3Col1(Col,Y+1,C);}
				if(grupo3Col(Col,Y-1,C)){+grupo3Col1(Col,Y-1,C);}
				
			}
		}
	}
	if(InicioH > 0){
		for(.range(X,InicioH,FinH)){
			if(datos(X,Fil,C)){
				if(grupo5Fil(X,Fil,C)){+grupoFil1(X,Fil,C);}
				if(grupo5Col(X,Fil,C)){+grupoCol1(X,Fil,C);}
				
				if(grupo5TN(X,Fil,C)){+grupo5TN1(X,Fil,C);}	
				if(grupo5TI(X,Fil,C)){+grupo5TI1(X,Fil,C);}
				if(grupo5TR(X,Fil,C)){+grupo5TR1(X,Fil,C);}
				if(grupo5TL(X,Fil,C)){+grupo5TL1(X,Fil,C);}
				
				if(grupo4FilA(X,Fil,C)){+grupo4FilA1(X,Fil,C);}
				if(grupo4FilA(X+1,Fil,C)){+grupo4FilA1(X+1,Fil,C);}
				if(grupo4FilA(X-1,Fil,C)){+grupo4FilA1(X-1,Fil,C);}
				
				if(grupo4FilB(X,Fil,C)){+grupo4FilB1(X,Fil,C);}
				if(grupo4FilB(X+1,Fil,C)){+grupo4FilB1(X+1,Fil,C);}
				if(grupo4FilB(X-1,Fil,C)){+grupo4FilB1(X-1,Fil,C);}
				
				if(grupo4ColA(X,Fil,C)){+grupo4ColA1(X,Fil,C);}
				if(grupo4ColA(X,Fil+1,C)){+grupo4ColA1(X,Fil+1,C);}
				if(grupo4ColA(X,Fil-1,C)){+grupo4ColA1(X,Fil-1,C);}
				
				if(grupo4ColB(X,Fil,C)){+grupo4ColB1(X,Fil,C);}
				if(grupo4ColB(X,Fil+1,C)){+grupo4ColB1(X,Fil+1,C);}
				if(grupo4ColB(X,Fil-1,C)){+grupo4ColB1(X,Fil-1,C);}
				
				if(grupo4SquareA(X,Fil,C)){+grupoSquareA1(X,Fil,C);}
				if(grupo4SquareB(X,Fil,C)){+grupoSquareB1(X,Fil,C);}
				if(grupo4SquareC(X,Fil,C)){+grupoSquareC1(X,Fil,C);}
				if(grupo4SquareD(X,Fil,C)){+grupoSquareD1(X,Fil,C);}
				
				
				if(grupo3Fil(X,Fil,C)){+grupo3Fil1(X,Fil,C);}
				if(grupo3Fil(X+1,Fil,C)){+grupo3Fil1(X+1,Fil,C);}
				if(grupo3Fil(X-1,Fil,C)){+grupo3Fil1(X-1,Fil,C);}
				
				if(grupo3Col(X,Fil,C)){+grupo3Col1(X,Fil,C);}
				if(grupo3Col(X,Fil+1,C)){+grupo3Col1(X,Fil+1,C);}
				if(grupo3Col(X,Fil-1,C)){+grupo3Col1(X,Fil-1,C);}
			}
		}
	}
	
	.findall(eliminarGrupo5Fil(A1,B1,Cor1),grupoFil1(A1,B1,Cor1),L1);for ( .member(K1,L1) ) {+K1;-K1;};
	.findall(eliminarGrupo5Col(A2,B2,Cor2),grupoCol1(A2,B2,Cor2),L2);for ( .member(K2,L2) ) {+K2;-K2;};
	
	.findall(eliminarGrupo5TN(A3,B3,Cor3),grupo5TN1(A3,B3,Cor3),L3);for ( .member(K3,L3) ) {+K3;-K3;};
	.findall(eliminarGrupo5TI(A4,B4,Cor4),grupo5TI1(A4,B4,Cor4),L4);for ( .member(K4,L4) ) {+K4;-K4;};
	.findall(eliminarGrupo5TR(A5,B5,Cor5),grupo5TR1(A5,B5,Cor5),L5);for ( .member(K5,L5) ) {+K5;-K5;};
	.findall(eliminarGrupo5TL(A6,B6,Cor6),grupo5TL1(A6,B6,Cor6),L6);for ( .member(K6,L6) ) {+K6;-K6;};
	
	.findall(eliminarGrupo4FilA(A7,B7,Cor7),grupo4FilA1(A7,B7,Cor7),L7);for ( .member(K7,L7) ) {+K7;-K7;};
	.findall(eliminarGrupo4FilB(A8,B8,Cor8),grupo4FilB1(A8,B8,Cor8),L8);for ( .member(K8,L8) ) {+K8;-K8;};
	.findall(eliminarGrupo4ColA(A9,B9,Cor9),grupo4ColA1(A9,B9,Cor9),L9);for ( .member(K9,L9) ) {+K9;-K9;};
	.findall(eliminarGrupo4ColB(A10,B10,Cor10),grupo4ColB1(A10,B10,Cor10),L10);for ( .member(K10,L10) ) {+K10;-K10;};
	
	.findall(eliminarGrupoSquareA(A11,B11,Cor11),grupoSquareA1(A11,B11,Cor11),L11);for ( .member(K11,L11) ) {+K11;-K11;};
	.findall(eliminarGrupoSquareB(A12,B12,Cor12),grupoSquareB1(A12,B12,Cor12),L12);for ( .member(K12,L12) ) {+K12;-K12;};
	.findall(eliminarGrupoSquareC(A13,B13,Cor13),grupoSquareC1(A13,B13,Cor13),L13);for ( .member(K13,L13) ) {+K13;-K13;};
	.findall(eliminarGrupoSquareD(A14,B14,Cor14),grupoSquareD1(A14,B14,Cor14),L14);for ( .member(K14,L14) ) {+K14;-K14;};
	
	.findall(eliminarGrupo3Fil(A15,B15,Cor15),grupo3Fil1(A15,B15,Cor15),L15);for ( .member(K15,L15) ) {+K15;-K15;};
	.findall(eliminarGrupo3Col(A16,B16,Cor16),grupo3Col1(A16,B16,Cor16),L16);for ( .member(K16,L16) ) {+K16;-K16;};
	
	+borrarBanderas;
	-borrarBanderas;
	
	/*-grupoFil1(_,_,_);-grupoCol1(_,_,_);
	-grupo5TN1(_,_,_);-grupo5TI1(_,_,_);-grupo5TR1(_,_,_);-grupo5TL1(_,_,_);
	-grupo4FilA1(_,_,_);-grupo4FilB1(_,_,_);-grupo4ColA1(_,_,_);-grupo4ColB1(_,_,_);
	-grupoSquareA1(_,_,_);-grupoSquareB1(_,_,_);-grupoSquareC1(_,_,_);-grupoSquareD1(_,_,_);
	-grupo3Fil1(_,_,_);-grupo3Col1(_,_,_);*/
	.	

+borrarBanderas <-
	-borrarBanderas;
	.findall(grupoFil1(A1,B1,Cor1),grupoFil1(A1,B1,Cor1),L1);for ( .member(K1,L1) ) {-K1;};
	.findall(grupoCol1(A2,B2,Cor2),grupoCol1(A1,B2,Cor2),L2);for ( .member(K2,L2) ) {-K2;};
	
	.findall(grupo5TN1(A3,B3,Cor3),grupo5TN1(A3,B3,Cor3),L3);for ( .member(K3,L3) ) {-K3;};
	.findall(grupo5TI1(A4,B4,Cor4),grupo5TI1(A4,B4,Cor4),L4);for ( .member(K4,L4) ) {-K4;};
	.findall(grupo5TR1(A5,B5,Cor5),grupo5TR1(A5,B5,Cor5),L5);for ( .member(K5,L5) ) {-K5;};
	.findall(grupo5TL1(A6,B6,Cor6),grupo5TL1(A6,B6,Cor6),L6);for ( .member(K6,L6) ) {-K6;};
	
	.findall(grupo4FilA1(A7,B7,Cor7),grupo4FilA1(A7,B7,Cor7),L7);for ( .member(K7,L7) ) {-K7;};
	.findall(grupo4FilB1(A8,B8,Cor8),grupo4FilB1(A8,B8,Cor8),L8);for ( .member(K8,L8) ) {-K8;};
	.findall(grupo4ColA1(A9,B9,Cor9),grupo4ColA1(A9,B9,Cor9),L9);for ( .member(K9,L9) ) {-K9;};
	.findall(grupo4ColB1(A10,B10,Cor10),grupo4ColB1(A10,B10,Cor10),L10);for ( .member(K10,L10) ) {-K10;};
	
	
	.findall(grupoSquareA1(A11,B11,Cor11),grupoSquareA1(A11,B11,Cor11),L11);for ( .member(K11,L11) ) {-K11;};
	.findall(grupoSquareB1(A12,B12,Cor12),grupoSquareB1(A12,B12,Cor12),L12);for ( .member(K12,L12) ) {-K12;};
	.findall(grupoSquareC1(A13,B13,Cor13),grupoSquareC1(A13,B13,Cor13),L13);for ( .member(K13,L13) ) {-K13;};
	.findall(grupoSquareD1(A14,B14,Cor14),grupoSquareD1(A14,B14,Cor14),L14);for ( .member(K14,L14) ) {-K14;};
	
	.findall(grupo3Fil1(A15,B15,Cor15),grupo3Fil1(A15,B15,Cor15),L15);for ( .member(K15,L15) ) {-K15;};
	.findall(grupo3Col1(A16,B16,Cor16),grupo3Col1(A16,B16,Cor16),L16);for ( .member(K16,L16) ) {-K16;};
	.

	
+eliminarGrupo5Fil(X,Y,C) <- -eliminarGrupo5Fil(X,Y,C);+clearNhorizontal(X-2,X+2,Y);-clearNhorizontal(X-2,X+2,Y).
+eliminarGrupo5Col(X,Y,C) <- -eliminarGrupo5Col(X,Y,C);+clearNvertical(Y-2,Y+2,X);-clearNvertical(Y-2,Y+2,X).

+eliminarGrupo5TN(X,Y,C) <- -eliminarGrupo5TN(X,Y,C);+clearNvertical(Y,Y+2,X);-clearNvertical(Y,Y+2,X);+clearNhorizontal(X-1,X+1,Y);-clearNhorizontal(X-1,X+1,Y).
+eliminarGrupo5TI(X,Y,C) <- -eliminarGrupo5TI(X,Y,C);+clearNvertical(Y-2,Y-1,X);-clearNvertical(Y-2,Y-1,X);+clearNhorizontal(X-1,X+1,Y);-clearNhorizontal(X-1,X+1,Y).
+eliminarGrupo5TR(X,Y,C) <- -eliminarGrupo5TR(X,Y,C);+clearNvertical(Y-1,Y+1,X);-clearNvertical(Y-1,Y+1,X);+clearNhorizontal(X-2,X-1,Y);-clearNhorizontal(X-2,X-1,Y).
+eliminarGrupo5TL(X,Y,C) <- -eliminarGrupo5TL(X,Y,C);+clearNvertical(Y-1,Y+1,X);-clearNvertical(Y-1,Y+1,X);+clearNhorizontal(X+1,X+2,Y);-clearNhorizontal(X+1,X+2,Y).

+eliminarGrupo4FilA(X,Y,C) <- -eliminarGrupo4FilA(X,Y,C);+clearNhorizontal(X-1,X+2,Y);-clearNhorizontal(X-1,X+2,Y).
+eliminarGrupo4FilB(X,Y,C) <- -eliminarGrupo4FilB(X,Y,C);+clearNhorizontal(X-2,X+1,Y);-clearNhorizontal(X-2,X+1,Y).
+eliminarGrupo4ColA(X,Y,C) <- -eliminarGrupo4ColA(X,Y,C);+clearNvertical(Y-1,Y+2,X);-clearNvertical(Y-1,Y+2,X).
+eliminarGrupo4ColB(X,Y,C) <- -eliminarGrupo4ColB(X,Y,C);+clearNvertical(Y-2,Y+1,X);-clearNvertical(Y-2,Y+1,X);.

+eliminarGrupoSquareA(X,Y,C) <- -eliminarGrupoSquareA(X,Y,C);+clearNhorizontal(X,X+1,Y);-clearNhorizontal(X,X+1,Y);+clearNhorizontal(X,X+1,Y+1);-clearNhorizontal(X,X+1,Y+1).
+eliminarGrupoSquareB(X,Y,C) <- -eliminarGrupoSquareB(X,Y,C);+clearNhorizontal(X-1,X,Y);-clearNhorizontal(X-1,X,Y);+clearNhorizontal(X-1,X,Y+1);-clearNhorizontal(X-1,X,Y+1).
+eliminarGrupoSquareC(X,Y,C) <- -eliminarGrupoSquareC(X,Y,C);+clearNhorizontal(X,X+1,Y-1);-clearNhorizontal(X,X+1,Y-1);+clearNhorizontal(X,X+1,Y);-clearNhorizontal(X,X+1,Y).
+eliminarGrupoSquareD(X,Y,C) <- -eliminarGrupoSquareD(X,Y,C);+clearNhorizontal(X-1,X,Y-1);-clearNhorizontal(X-1,X,Y-1);+clearNhorizontal(X-1,X,Y);-clearNhorizontal(X-1,X,Y).

+eliminarGrupo3Fil(X,Y,C) <- -eliminarGrupo3Fil(X,Y,C);+clearNhorizontal(X-1,X+1,Y);-clearNhorizontal(X-1,X+1,Y).
+eliminarGrupo3Col(X,Y,C) <- -eliminarGrupo3Col(X,Y,C);+clearNvertical(Y-1,Y+1,X);-clearNvertical(Y-1,Y+1,X).

	
+explosionIP(X,Y):size(Size) <-
	-explosionIP(X,Y);
	?dir(D);
	if(D="left" | D="right"){
		+clearNhorizontal(0,Size-1,Y);
		-clearNhorizontal(0,Size-1,Y);
	}else{
		+clearNvertical(0,Size-1,X);
		-clearNvertical(0,Size-1,X);
	}.

+explosionCT(Color) <-
	-explosionCT(Color);
	+eliminacionMismoColor(Color);
	-eliminacionMismoColor(Color).

+explosionCO(X,Y) <-
	-explosionCO(X,Y);
	+clearNhorizontal(X-1,X+1,Y-1);
	-clearNhorizontal(X-1,X+1,Y-1);
	+clearNhorizontal(X-1,X+1,Y);
	-clearNhorizontal(X-1,X+1,Y);
	+clearNhorizontal(X-1,X+1,Y+1);
	-clearNhorizontal(X-1,X+1,Y+1).

+explosionGS <-
	-explosionGS;
	+buscarGs;
	-buscarGs;
	if(fichaGs(A,B,Cor)){
		-fichaGs(A,B,Cor);
		-tablero(celda(A,B,_),_);
		?color(Cor,C1);
		deleteSteak(C1,A,B);
	}.

+buscarGs:size(N) <-
	-buscarGs;
	-fichaGs(_,_,_);
	for ( .range(I,0,N-1) ) {
		for ( .range(J,(N-1),0,-1) ) {
			if(datos(I,J,Color,gs,_)){
				-+fichaGs(I,J,Color);
			}
		}
	}
	.
	
+eliminacionMismoColor(Color):size(N) <-
	-eliminacionMismoColor(Color);
	?color(Color,C1);
	for (.range(I,N-1,0,-1) ) {
		for ( .range(J,0,N-1) ) {
			if(datos(I,J,Color)){
				-tablero(celda(I,J,_),_);
				deleteSteak(C1,I,J);
				-+puntosMov(8);
				!actualizarPuntos;
			}
		}
	}
	.

+caidaFichas:size(Size) <-
	-caidaFichas;
	for(.range(X,0,Size-1)){
		for(.range(Y,Size-2,0,-1)){
			+caidaLibre(X,Y);
			-caidaLibre(X,Y);
		}
	}.

	
+caidaLibre(X,Y): size(Size) & datos(X,Y,_) & not esObstaculo(X,Y) & not datos(X,Y+1,_) & Y < Size-1 <-
	-caidaLibre(X,Y);
	-+caido(1);
	.print("caso1------------------");
	-tablero(celda(X,Y,Own),ficha(Real,Tipo));
	+tablero(celda(X,Y+1,Own),ficha(Real,Tipo));
	?color(Real,Color);
	deleteSteak(Color,X,Y);
	.wait(10);
	put(X,Y+1,Color,Tipo);
	+caidaLibre(X,Y+1);
	-caidaLibre(X,Y+1);
	.	
	
+caidaLibre(X,Y):caido(1) & size(Size) & (not datos(X,Y-1,_) | esObstaculo(X,Y-1) ) & datos(X,Y,_) & (datos(X,Y+1,_) | Y = Size-1) & not esObstaculo(X,Y) <-
	-caidaLibre(X,Y);
	.print("caso2------------------");
	if(not datos(X,0,_) & not datos(X-1,Y,_)){
		+colocarFichaArriba(X);
		-colocarFichaArriba(X);
	}
	+rodar2(X,Y);
	-rodar2(X,Y);
	
	+caidaLibre(X,Y-1);
	-caidaLibre(X,Y-1)
	.

+caidaLibre(X,Y): size(Size) & Y = 0 & not datos(X,Y,_) <-
	-caidaLibre(X,Y);
	+colocarFichaArriba(X);
	-colocarFichaArriba(X);
	+caidaLibre(X,Y);
	-caidaLibre(X,Y).
	
+caidaLibre(X,Y):size(Size) & Y >= 0 <-
	-caidaLibre(X,Y);
	+caidaLibre(X,Y-1);
	-caidaLibre(X,Y-1).
	
+caidaLibre(X,Y) <- -+caido(0).

+rodar2(X,Y): size(Size) & not datos(X-1,Y,M1) & not esObstaculo(X,Y) & X-1 >=0 <-
	-rodar2(X,Y);
	-tablero(celda(X,Y,Own),ficha(Real,Tipo));
	+tablero(celda(X-1,Y,Own),ficha(Real,Tipo));
	?color(Real,Color);
	deleteSteak(Color,X,Y);
	put(X-1,Y,Color,Tipo);
	.wait(300);
	+caidaLibre(X-1,Y);
	-caidaLibre(X-1,Y);
.
+rodar2(X,Y).

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


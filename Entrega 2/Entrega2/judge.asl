// Agent judge in project ESEI_SAGA.mas2j

/* ----- Initial beliefs and rules ------ */
//Recopilar datos de posicion y color de una ficha
datos(X,Y,Color):- tablero(celda(X,Y,_),ficha(Color,_)).
datos(X,Y,Color,Tipo,Prop):- tablero(celda(X,Y,Prop),ficha(Color,Tipo)).

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

size(10).
jugadasRestantes(100).

jugadasPlayer(player1,0).
jugadasPlayer(player2,0).

turnoActual(player1).

turnoActivado(0).

fueraTablero(0).

fueraTurno(player1,0).
fueraTurno(player2,0).

jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

//(Añadida) color real y color en base 16 
color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.
eligeColor(Real,Color):- .random(Random) & Real = math.floor(Random*6) & color(Real,Color).

numVecesColor(0,0).
numVecesColor(1,0).
numVecesColor(2,0).
numVecesColor(3,0).
numVecesColor(4,0).
numVecesColor(5,0).
colorLleno(Color):- size(N) & numVecesColor(Color,Veces) & Veces >= math.floor((N*N)/6).
otroColor(0):- not colorLleno(0).
otroColor(1):- not colorLleno(1).
otroColor(2):- not colorLleno(2).
otroColor(3):- not colorLleno(3).
otroColor(4):- not colorLleno(4).
otroColor(5):- not colorLleno(5).

repetirColor(Color,Nuevo):- Color+1 < 6 & Nuevo = Color+1.
repetirColor(Color,Nuevo):- Color-1 >= 0 & Nuevo = Color-1.

//Comprobacion completa de las condiciones de un movimiento correcto: Seleccion, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).
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


color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.


//Calculo de coordenadas para un movimiento
nextMove(P1,P2,P1,P2-1,"up").
nextMove(P1,P2,P1,P2+1,"down").
nextMove(P1,P2,P1+1,P2,"right").
nextMove(P1,P2,P1-1,P2,"left").


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
	.send(P,untell,puedesMover).

+!comienzoTurno : jugadasRestantes(N) & N=0 <- .print("FIN DE LA PARTIDA: Se ha realizado el numero maximo de jugadas").

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
	not colorFichasDistintos(pos(X,Y),Dir) <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado  intercambiar dos fichas del mismo color");
		-+turnoActivado(1);
		.print("Intentalo de nuevo!");
		.send(P,tell,tryAgain);
		.send(P,untell,tryAgain).

// Esta regla la podeis adecuar a vuestras necesidades
+movimientoInvalido(pos(X,Y),Dir,P) <- 
	.print("DEBUG: Error en +movimientoInvalido").


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
				.print("EMPIEZA EL JUEGO!")
				!comienzoTurno.

//Generacion aleatoria del tablero y fichas.
+generacionTablero : size(N)<-
	for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				?eligeColor(Real,Color);
				.print(Real,"-------,",Veces);
					+tablero(celda(J,I,0),ficha(Real,ip));
					//Añade una ficha al tablero gráfico
					put(J,I,Color,ip);
				
			};
		 };
		 !eliminarGrupos.
		 
+!eliminarGrupos: size(N) <- 
	for ( .range(I,0,(N-1)) ) {
			for ( .range(J,0,(N-1)) ) {
				?datos(J,I,Color,Tipo,Prop);
				if(hayAgrupacion(J,I,Color)){
					?repetirColor(Color,Nuevo);
					?color(Color,C1);
					?color(Nuevo,N1);
					-tablero(celda(J,I,0),ficha(Color,ip));
					+tablero(celda(J,I,0),ficha(Nuevo,ip));
					.print("he detectado una agrupacion y procedo a eliminarla");
					deleteSteak(C1,J,I,Prop,Tipo);
					put(J,I,N1,Tipo);
				}
			}
	};
	.wait(300000).

+crearCeldaTablero(I,J,Color,Ficha) :  randomFicha(Ficha, TipoFicha) <-
		+tablero(celda(I,J,0),ficha(Color,TipoFicha)).

 //Comunicacion del tablero al jugador indicado.
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
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
	exchange(C1,X,NX,C2,Y,NY,Tipo1,Tipo2);
	.print("Se han intercambiado las fichas entre las posiciones (",X,",",Y,") y (",NX,",",NY,")");
	!findGroups(X,Y,Color2);
	.print("X-Y: ",X," ",Y," ",Color2);
	.print("NX-NY: ",NX," ",NY," ",Color1);
	!findGroups(NX,NY,Color1);
	.wait(200).
	
//Grupo 5 
//por filas
+!findGroups(OX,OY,Color): grupo5Fil(OX,OY,Color)<-.print("Agrupacion de 5 en fila en ",OX,OY);!clearNhorizontal(OX-2,OX+2,OY).
//por columnas
+!findGroups(OX,OY,Color): grupo5Col(OX,OY,Color)<-.print("Agrupacion de 5 en Columna en ",OX,OY);!clearNvertical(OY-2,OY+2,OX).
//Grupo 5 T
+!findGroups(OX,OY,Color): grupo5TN(OX,OY,Color)<-.print("Agrupacion de 5 en T normal en ",OX,OY);!clearNvertical(OY+1,OY+2,OX);!clearNhorizontal(OX-1,OX+1,OY).
+!findGroups(OX,OY,Color): grupo5TI(OX,OY,Color)<-.print("Agrupacion de 5 en T invertida en ",OX,OY);!clearNvertical(OY-2,OY-1,OX);!clearNhorizontal(OX-1,OX+1,OY).
+!findGroups(OX,OY,Color): grupo5TR(OX,OY,Color)<-.print("Agrupacion de 5 en T derecha en ",OX,OY);!clearNvertical(OY-1,OY+1,OX);!clearNhorizontal(OX-2,OX-1,OY).
+!findGroups(OX,OY,Color): grupo5TL(OX,OY,Color)<-.print("Agrupacion de 5 en T izquierda en ",OX,OY);!clearNvertical(OY-1,OY+1,OX);!clearNhorizontal(OX+1,OX+2,OY).
//Grupo 4 por filas
//A
+!findGroups(OX,OY,Color): grupo4FilA(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX-1,OX+2,OY).
+!findGroups(OX,OY,Color): grupo4FilA(OX-1,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX-1)-1,(OX-1)+2,OY).
+!findGroups(OX,OY,Color): grupo4FilA(OX+1,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX+1)-1,(OX+1)+2,OY).
+!findGroups(OX,OY,Color): grupo4FilA(OX+2,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX+2)-1,(OX+2)+2,OY).
//B
+!findGroups(OX,OY,Color): grupo4FilB(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX-2,OX+1,OY).
+!findGroups(OX,OY,Color): grupo4FilB(OX-1,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX-1)-2,(OX-1)+1,OY).
+!findGroups(OX,OY,Color): grupo4FilB(OX-2,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX-2)-2,(OX-2)+1,OY).
+!findGroups(OX,OY,Color): grupo4FilB(OX+1,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal((OX+1)-2,(OX+1)+1,OY).
//Grupo 4 Cuadrado
+!findGroups(OX,OY,Color): grupo4SquareA(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX,OX+1,OY);!clearNhorizontal(OX,OX+1,OY+1).
+!findGroups(OX,OY,Color): grupo4SquareB(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX-1,OX,OY);!clearNhorizontal(OX-1,OX,OY+1).
+!findGroups(OX,OY,Color): grupo4SquareC(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX,OX+1,OY);!clearNhorizontal(OX,OX+1,OY-1).
+!findGroups(OX,OY,Color): grupo4SquareD(OX,OY,Color)<-.print("Agrupacion de 4 en fila en ",OX,OY);!clearNhorizontal(OX-1,OX,OY);!clearNhorizontal(OX-1,OX,OY-1).
//Grupo 4 por columnas
//A
+!findGroups(OX,OY,Color): grupo4ColA(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical(OY-1,OY+2,OX).
+!findGroups(OX,OY,Color): grupo4ColA(OX,OY-1,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY-1)-1,(OY-1)+2,OX).
+!findGroups(OX,OY,Color): grupo4ColA(OX,OY+1,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY+1)-1,(OY+1)+2,OX).
+!findGroups(OX,OY,Color): grupo4ColA(OX,OY+2,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY+2)-1,(OY+2)+2,OX).
//B
+!findGroups(OX,OY,Color): grupo4ColB(OX,OY,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical(OY-2,OY+1,OX).
+!findGroups(OX,OY,Color): grupo4ColB(OX,OY-1,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY-1)-2,(OY-1)+1,OX).
+!findGroups(OX,OY,Color): grupo4ColB(OX,OY-2,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY-2)-2,(OY-2)+1,OX).
+!findGroups(OX,OY,Color): grupo4ColB(OX,OY+1,Color)<-.print("Agrupacion de 4 en columna en ",OX,OY);!clearNvertical((OY+1)-2,(OY+1)+1,OX).
//Grupo 3 por filas
+!findGroups(OX,OY,Color): grupo3Fil(OX,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY);!clearNhorizontal(OX-1,OX+1,OY).
+!findGroups(OX,OY,Color): grupo3Fil(OX+1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY+1);!clearNhorizontal((OX+1)-1,(OX+1)+1,OY).
+!findGroups(OX,OY,Color): grupo3Fil(OX-1,OY,Color)<-.print("Agrupacion de 3 en fila en ",OX,OY-1);!clearNhorizontal((OX-1)-1,(OX-1)+1,OY).
//Grupo 3 por columnas
+!findGroups(OX,OY,Color): grupo3Col(OX,OY,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY);!clearNvertical(OY-1,OY+1,OX).
+!findGroups(OX,OY,Color): grupo3Col(OX,OY+1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY+1);!clearNvertical((OY+1)-1,(OY+1)+1,OX).
+!findGroups(OX,OY,Color): grupo3Col(OX,OY-1,Color)<-.print("Agrupacion de 3 en columna en ",OX,OY-1);!clearNvertical((OY-1)-1,(OY-1)+1,OX).

+!findGroups(OX,OY,Color)<- .print("No hay ninguna agrupación").

//Borrar en vertical desde un rango
+!clearNvertical(Inicio,Fin,Col) <-
	for (.range(I,Inicio,Fin)) {
		if (datos(Col,I,Color,Tipo,Prop)) {
			-tablero(celda(Col,I,Prop),ficha(Color,Tipo));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.print("Ficha(",Col,"-",I,")color: ",Color,"-------------------------");
			?color(Color,C);
			deleteSteak(C,Col,I,Prop,Tipo);
		};
	//put(Col,I,1024," ");
	}.
//Borrar en horizontal desde un rando
+!clearNhorizontal(Inicio,Fin,Fil) <-
	for (.range(I,Inicio,Fin)) {
		if (datos(I,Fil,Color,Tipo,Prop)) {	
			-tablero(celda(I,Fil,Prop),ficha(Color,Tipo));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.send(player1,untell,tablero(celda(Col,I,Prop),ficha(Color,Tipo)));
			.print("Ficha(",I,"-",Fil,")color: ",Color,"-------------------------");
			?color(Color,C);
			deleteSteak(C,I,Fil,Prop,Tipo);
		};
	//put(I,Fil,1024," ");
	}.
//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  <- .print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


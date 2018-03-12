// Agent judge in project ESEI_SAGA.mas2j
//Roi Pérez López, Martín Puga Egea
/* ----- Initial beliefs and rules ------ */

size(10).

jugadasRestantes(100).

jugadasPlayer(player1,0).
jugadasPlayer(player2,0).

turnoActual(player1).

turnoActivado(0).

fueraTablero(0).


color(0,16).
color(N,C) :- color(N-1,C1) & C = C1*2.

fueraTurno(player1,0).
fueraTurno(player2,0).

jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

//Comprobacion completa de las condiciones de un movimiento correcto: Seleccion, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
mismoColor(X,X). //TODO cambiar esta mierda

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



/* ----- Initial goals ----- */

!startGame.


/* ----- Plans ----- */


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
				.random(Color,10);
				.random(Ficha,10);
				+crearCeldaTablero(I,J,math.round(5*Color),math.round(4*Ficha));
				-crearCeldaTablero(I,J,math.round(5*Color),math.round(4*Ficha));
			};
		 }.
+crearCeldaTablero(I,J,Color,Ficha) :  randomFicha(Ficha, TipoFicha) <-
		+tablero(celda(I,J,0),ficha(Color,TipoFicha)).

 //Comunicacion del tablero al jugador indicado.
+mostrarTablero(P) : size(N) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
		for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 };
		 .send(P,tell,size(N)).


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
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : turnoActual(P) & movimientoValido(pos(X,Y),Dir) & turnoActivado(1)<-
												-+turnoActivado(0);
												-moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)];
												.print("Jugada valida!")
												.send(P,tell,valido);
												.send(P,untell,valido);
												+intercambiarFichas(X,Y,Dir,P);
												-intercambiarFichas(X,Y,Dir,P);
												-+turnoTerminado(P);
												!comienzoTurno.

+turnoTerminado(P): jugadorDescalificado(J,B) & B=1 <- +cambioTurnoMismoJugador(P).
+turnoTerminado(P) <- +cambioTurno(P).

+intercambiarFichas(X,Y,Dir,P) : nextMove(X,Y,NX,NY,Dir) & plNumb(P,PlNumb) <-
								-tablero(celda(X,Y,Own1),ficha(Color1,Tipo1));
								-tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2));
								.send(player1,untell,tablero(celda(X,Y,Own1),ficha(Color1,Tipo1)));
								.send(player1,untell,tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2)));
								.send(player2,untell,tablero(celda(X,Y,Own1),ficha(Color1,Tipo1)));
								.send(player2,untell,tablero(celda(NX,NY,Own2),ficha(Color2,Tipo2)));
								+tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1));
								+tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2));
								.send(player1,tell,tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1)));
								.send(player1,tell,tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2)));
								.send(player2,tell,tablero(celda(NX,NY,PlNumb),ficha(Color1,Tipo1)));
								.send(player2,tell,tablero(celda(X,Y,PlNumb),ficha(Color2,Tipo2)));
								
								?color(Color1,C1);
								?color(Color2,C2);
								exchange(C1,X,NX,C2,Y,NY);
								
								
								.print("Se han intercambiado las fichas entre las posiciones (",X,",",Y,") y (",NX,",",NY,")").

//Movimiento Incorrecto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : turnoActual(P) & not movimientoValido(pos(X,Y),Dir) & turnoActivado(1)<-
												-+turnoActivado(0);
												+movimientoInvalido(pos(X,Y),Dir,P).

//Movimiento realizado por un jugador que tiene el turno pero el juez aun no le ha ordenado mover
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : turnoActual(P) & turnoActivado(0) <-
												.print("Agente ",P,", espera mi orden para realizar el siguiente movimiento. No intentes mover mas de una vez.").


//Movimiento realizado por un jugador fuera de su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : not turnoActual(P) & fueraTurno(P,N) <-
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
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] : not turnoActual(P) & not fueraTurno(P,N) <- // --- TODO ---
												.print("El agente ",P," externo a la partida está intentando jugar.").



+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <- .print("DEBUG: Error en +moverDesdeEnDireccion. Source", P). //Salvaguarda




//Comprobacion de la falta cometida por mover una ficha hacia una posicion fuera del tablero, intentar mover una ficha de una posicion inexistente, o realizar un tipo de movimiento desconocido
+movimientoInvalido(pos(X,Y),Dir,P) :fueraTablero(V) & not direccionCorrecta(pos(X,Y),Dir)  <-
													-movimientoInvalido(pos(X,Y),Dir,P);
													.print("Movimiento Invalido. Has intentado mover una ficha fuera del tablero");
													.send(P,tell,invalido(fueraTablero,V+1));
													.send(P,untell,invalido(fueraTablero,V+1));
													-+turnoActivado(1);
													-+fueraTablero(V+1).

//Comprobacion de la falta cometida por intercambiar dos fichas del mismo color
+movimientoInvalido(pos(X,Y),Dir,P) : not colorFichasDistintos(pos(X,Y),Dir) <-
										-movimientoInvalido(pos(X,Y),Dir,P);
										.print("Movimiento Invalido. Has intentado  intercambiar dos fichas del mismo color");
										-+turnoActivado(1);
										.print("Intentalo de nuevo!");
										.send(P,tell,tryAgain);
										.send(P,untell,tryAgain).

+movimientoInvalido(pos(X,Y),Dir,P) <- .print("DEBUG: Error en +movimientoInvalido").


//Recepcion del aviso de que un jugador pasa turno por haber realizado un movimiento fuera del tablero mas de 3 veces
+pasoTurno[source(P)] : turnoActual(P) <-
						-+fueraTablero(0);
						.print(P," ha pasado turno");
						+cambioTurno(P);
						!comienzoTurno.

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  <- .print("El agente ",A," se comunica conmigo, pero no lo entiendo!").


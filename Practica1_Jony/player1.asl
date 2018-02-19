
// Agent Player1 in project Practica1.mas2j



/* Initial beliefs and rules */

//movimiento(moverDesdeEnDireccion(pos(0,0),down)).
correcto(moverDesdeEnDireccion(pos(0,0),down)).
/* Initial goals */

/* Plans */
//Si es el primer movimiento, entonces viene a partir de un correcto
+mueve[source(judge)]: correcto(moverDesdeEnDireccion(pos(X,Y),Dir))<- 
	R = math.random(4);
	if(R < 1){-+direccion(up);}
	if(R >= 1 & R < 2){-+direccion(down);}
	if(R >= 2 & R < 3){-+direccion(left);}
	if(R >= 3){-+direccion(right);}
	
	?direccion(D);
	-+movimiento(moverDesdeEnDireccion(pos(X,Y),D));


	.print("Inicio Jugador 1");
	//-+movimiento(moverDesdeEnDireccion(pos(DX,DY),D));
	?movimiento(Mov);
	.print("Movimiento a realizar",Mov);
	.send(judge,tell,Mov).
//Si tiene que rectificar una o varias veces significa que ha realizado algún movimiento
+correjir [source(judge)] : movimiento(X)<-
	.print("Corrigiendo movimiento");
	//Las coordenadas de destino de correcto,son las coordenadas por donde empieza el siguiente movimiento
	?correcto(moverDesdeEnDireccion(pos(OX,OY),Dir));
	//Metodo de movimiento dinamico
	R = math.random(4);
	if(R < 1){-+direccion(up);}
	if(R >= 1 & R < 2){-+direccion(down);}
	if(R >= 2 & R < 3){-+direccion(left);}
	if(R >= 3){-+direccion(right);}
	?direccion(D);
	if(Dir=up){-+movimiento(moverDesdeEnDireccion(pos(OX,OY+1),D));}
	if(Dir=down){-+movimiento(moverDesdeEnDireccion(pos(OX,OY-1),D));}
	if(Dir=left){-+movimiento(moverDesdeEnDireccion(pos(OX-1,OY),D));}
	if(Dir=right){-+movimiento(moverDesdeEnDireccion(pos(OX+1,OY),D));}
	//Almacenamos el nuevo movimiento
	?movimiento(Mov);
	.print(Mov);
	.send(judge,tell,Mov).
//Si se realiza un movimiento correcto
+puedesMover [source(judge)] <-
	?movimiento(X);
	//El movimiento realizado pasa a ser el movimiento correcto
	-+correcto(X);
	.print("Ficha movida").




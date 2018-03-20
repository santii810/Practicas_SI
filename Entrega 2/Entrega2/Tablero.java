// Environment code for project player.mas2j

import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.util.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;

public class Tablero extends Environment {

    public static final int GSize = 10; // grid size
<<<<<<< HEAD
    public static final int STEAK  = 16; // steak code in grid model
	public static final int REDSTEAK  = 32; // steak code in grid model
	public static final int GREENSTEAK  = 64; // steak code in grid model
	public static final int BLACKSTEAK  = 128; // steak code in grid model
	public static final int ORANGESTEAK  = 256; // steak code in grid model
	public static final int MAGENTASTEAK  = 512; // steak code in grid model
=======
    public static final int FICHABLUE  = 16; // steak code in grid model
	public static final int FICHARED  = 32; // steak code in grid model
	public static final int FICHAGREEN  = 64; // steak code in grid model
	public static final int FICHABLACK  = 128; // steak code in grid model
	public static final int FICHAORANGE  = 256; // steak code in grid model
	public static final int FICHAMAGENTA  = 512; // steak code in grid model
>>>>>>> Jony
	

    private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

    private TableroModel model;
    private TableroView  view;
    
<<<<<<< HEAD
	String label = "  ";
=======
	String label = "";
>>>>>>> Jony
    /** Called before the MAS execution with the args informed in .mas2j */
    @Override
    public void init(String[] args) {
        model = new TableroModel();
        view  = new TableroView(model);
        model.setView(view);
        super.init(args);
<<<<<<< HEAD
		addPercept("judge",Literal.parseLiteral("sizeof(" + (GSize - 1) + ")"));
=======
		//addPercept("judge",Literal.parseLiteral("sizeof(" + (GSize - 1) + ")"));
>>>>>>> Jony
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
        logger.info(ag+" doing: "+ action);
        try {
             if (ag.equals("judge")) {
				 if (action.getFunctor().equals("put")) {
					 int x = (int)((NumberTerm)action.getTerm(0)).solve();
					 int y = (int)((NumberTerm)action.getTerm(1)).solve();
					 int c = (int)((NumberTerm)action.getTerm(2)).solve();
<<<<<<< HEAD
					 int steak = (int)((NumberTerm)action.getTerm(3)).solve();
=======
					 String l = action.getTerm(3).toString();
					 
					 /*int steak = (int)((NumberTerm)action.getTerm(3)).solve();
>>>>>>> Jony
					 if (steak == 0) { label = "  ";} else
					 if (steak == 1) { label = "ip";} else
					 if (steak == 2) { label = "ct";} else
					 if (steak == 3) { label = "gs";} else
					 if (steak == 4) { label = "co";} else
<<<<<<< HEAD
					 {label = "TT";};
					 //model.put(x,y,c);
					 model.put(x,y,c,label);
=======
					 {label = "TT";};*/
					 
					//solo para pruebas
					switch (c) {
					case 0: c=16;  break;
					case 1: c=32;  break;
					case 2: c=64;  break;
					case 3: c=128;  break;
					case 4: c=256;  break;
					case 5: c=512;  break;
					}
					 
					 
					 //model.put(x,y,c);
					 model.put(x,y,c,l);
>>>>>>> Jony
				 } else if(action.getFunctor().equals("exchange")){
					 int c1 = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x1 = (int)((NumberTerm)action.getTerm(1)).solve();
					 int x2 = (int)((NumberTerm)action.getTerm(2)).solve();
					 int c2 = (int)((NumberTerm)action.getTerm(3)).solve();
					 int y1 = (int)((NumberTerm)action.getTerm(4)).solve();
					 int y2 = (int)((NumberTerm)action.getTerm(5)).solve();
<<<<<<< HEAD
					 model.exchange(c1,x1,x2,c2,y1,y2);
=======
					 String label1 = action.getTerm(6).toString();
					 String label2 = action.getTerm(7).toString();
					 model.exchange(c1,x1,x2,c2,y1,y2,label1,label2);
>>>>>>> Jony
				 } else if(action.getFunctor().equals("deleteSteak")){
					 int c = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x = (int)((NumberTerm)action.getTerm(1)).solve();
					 int y = (int)((NumberTerm)action.getTerm(2)).solve();
<<<<<<< HEAD
					 model.deleteSteak(c,x,y);
=======
					 int o = (int)((NumberTerm)action.getTerm(3)).solve();
					 String l = action.getTerm(4).toString();
					 
					 
					 model.deleteSteak(c,x,y,o,l);
>>>>>>> Jony
				 } else if(action.getFunctor().equals("moveSteaks")){
					 model.moveSteaks();
				 }
			} else {
				logger.info("Recibido una peticion ilegal. "+ag+" no puede realizar la accion: "+ action);
				Literal ilegal = Literal.parseLiteral("accionIlegal(" + ag + ")");
			addPercept("judge",ilegal);}
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        updatePercepts();

        try {
<<<<<<< HEAD
            Thread.sleep(100);
=======
            Thread.sleep(1);
>>>>>>> Jony
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

    /** creates the agents perception based on the MarsModel */
    void updatePercepts() {
        //Location r1Loc = model.getAgPos(0);
        Literal newMov = Literal.parseLiteral("done");
		addPercept("judge",newMov);    
    }

    class TableroModel extends GridWorldModel {
        
        Random random = new Random(System.currentTimeMillis());
		
		String label = "";

        private TableroModel() {
            super(GSize, GSize, 3);
<<<<<<< HEAD
			//String label = label;
            // initial location of agents
=======

>>>>>>> Jony
            try {
                setAgPos(0, 0, 0);
            } catch (Exception e) {
                e.printStackTrace();
            }
<<<<<<< HEAD
			//set(4,GSize/2,GSize/2);
			int color = 16;
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
					add(color,i,j);
					addPercept("judge",Literal.parseLiteral("cell(" + color + ", pos(" + i + "," + j + "), in, 0)"));
					if (color < 512) {color = color * 2;}
					else {color = 16;};
				};
				if (color < 512) {color = color * 2;}
				else {color = 16;};
			};
			addPercept("judge",Literal.parseLiteral("start"));
        }

		void put(int x, int y, int c, String steak) throws Exception {
			removePerceptsByUnif("judge",Literal.parseLiteral("cell(Color, pos(" + x + "," + y + "), Type, Own)"));
			if (isFreeOfObstacle(x,y)) {
				set(c,x,y);
				label = steak;
				logger.info(" Percepcion eliminada..................................."+label+"...."+steak);				
				if (steak == "  "){
					addPercept("judge",Literal.parseLiteral("cell(" + c + ", pos(" + x + "," + y + "), in, 0)"));
					logger.info(" Entro por aquiiiiiiiiiii...................");}
				else {	
				addPercept("judge",Literal.parseLiteral("cell(" + c + ", pos(" + x + "," + y + "),"+label+", 0)"));};
				//addPercept("judge",Literal.parseLiteral("steak(" + c + "," + x + "," + y + ")"));
			};
        }
		
		void exchange(int c1, int x1, int x2, int c2, int y1, int y2) throws Exception {
			remove(c1,new Location(x1,y1));
		//	removePercept("judge",Literal.parseLiteral("steak("+ c1 +"," + x1 + "," + y1 + ")"));
			remove(c2,new Location(x2,y2));
		//	removePercept("judge",Literal.parseLiteral("steak(" + c2 + "," + x2 + "," + y2 + ")"));

			set(c2,x1,y1);
		//	addPercept("judge",Literal.parseLiteral("steak("+ c2 +"," + x1 + "," + y1 + ")"));
			set(c1,x2,y2);
		//	addPercept("judge",Literal.parseLiteral("steak(" + c1 + "," + x2 + "," + y2 + ")"));
		}
		
		void deleteSteak(int c,int x, int y) throws Exception {
			remove(c,new Location(x,y));
			removePercept("judge",Literal.parseLiteral("steak("+ c +"," + x + "," + y + ")"));
=======
        }
		
		String getLabel(){
			return label;
		}
		
		void put(int x, int y, int c) throws Exception {
				set(c,x,y);
        }
		
		void put(int x, int y, int c, String l) throws Exception {
			if (isFreeOfObstacle(x,y)) {
				set(c,x,y);
				label = l;
			};
        }
		
		int conversor(int color){
			int n = 0;
			if(color == 16){
				return n;	
			}else{
				n++;
				n += conversor(color/2);
			}
			return n;
		}
		
		void exchange(int c1, int x1, int x2, int c2, int y1, int y2, String label1, String label2) throws Exception {
			remove(c1,new Location(x1,y1));
			//removePercept("judge",Literal.parseLiteral("tablero(celda("+ x1 +"," + y1 + "," + 0 + "),ficha(" + conversor(c1) + "," + label1 + "))"));
			remove(c2,new Location(x2,y2));
			//removePercept("judge",Literal.parseLiteral("tablero(celda("+ x2 +"," + y2 + "," + 0 + "),ficha(" + conversor(c2) + "," + label2 + "))"));
			Thread.sleep(500);
			set(c2,x1,y1);
			//addPercept("judge",Literal.parseLiteral("tablero(celda("+ x2 +"," + y1 + "," + 0 + "),ficha(" + conversor(c2) + "," + label2 + "))"));
			set(c1,x2,y2);
			//addPercept("judge",Literal.parseLiteral("tablero(celda("+ x1 +"," + y2 + "," + 0 + "),ficha(" + conversor(c1) + "," + label1 + "))"));
		}
		
		void deleteSteak(int c,int x, int y,int o,String l) throws Exception {
			remove(c,new Location(x,y));
			//removePercept("judge",Literal.parseLiteral("tablero(celda("+ x +"," + y + "," + o + "),ficha(" + conversor(c) + "," + l + "))"));
>>>>>>> Jony
		}
		
		void moveSteaks()throws Exception {
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
<<<<<<< HEAD
					if(	!(hasObject(STEAK,i,j) || hasObject(REDSTEAK,i,j) ||
						hasObject(GREENSTEAK,i,j) || hasObject(BLACKSTEAK,i,j) ||
			        	hasObject(ORANGESTEAK,i,j) || hasObject(MAGENTASTEAK,i,j))){
						for(int k = j - 1; k >= 0;k--){
							int c = 0;
							if(hasObject(STEAK,i,k)){
								c = STEAK;
							}else if(hasObject(REDSTEAK,i,k)){
								c = REDSTEAK;
							}else if(hasObject(GREENSTEAK,i,k)){
								c = GREENSTEAK;
							}else if(hasObject(BLACKSTEAK,i,k)){
								c = BLACKSTEAK;
							}else if(hasObject(ORANGESTEAK,i,k)){
								c = ORANGESTEAK;
							}else if(hasObject(MAGENTASTEAK,i,k)){
								c = MAGENTASTEAK;
=======
					if(	!(hasObject(FICHABLUE,i,j) || hasObject(FICHARED,i,j) ||
						hasObject(FICHAGREEN,i,j) || hasObject(FICHABLACK,i,j) ||
			        	hasObject(FICHAORANGE,i,j) || hasObject(FICHAMAGENTA,i,j))){
						for(int k = j - 1; k >= 0;k--){
							int c = 0;
							if(hasObject(FICHABLUE,i,k)){
								c = FICHABLUE;
							}else if(hasObject(FICHARED,i,k)){
								c = FICHARED;
							}else if(hasObject(FICHAGREEN,i,k)){
								c = FICHAGREEN;
							}else if(hasObject(FICHABLACK,i,k)){
								c = FICHABLACK;
							}else if(hasObject(FICHAORANGE,i,k)){
								c = FICHAORANGE;
							}else if(hasObject(FICHAMAGENTA,i,k)){
								c = FICHAMAGENTA;
>>>>>>> Jony
							}
							if(c != 0){
								remove(c,new Location(i,k));
								removePercept("judge",Literal.parseLiteral("steak("+ c +"," + i + "," + k + ")"));
								
								add(c,new Location(i,k + 1));
								addPercept("judge",Literal.parseLiteral("steak(" + c + "," + i + "," + (k + 1) + ")"));
							}
							
						}	
					}
				} 
			} 
		
		}
        
    }
    
    class TableroView extends GridWorldView {
		
        public TableroView(TableroModel model) {
            super(model, "Tablero", 400);
            defaultFont = new Font("Arial", Font.BOLD, 18); // change default font
            setVisible(true);
<<<<<<< HEAD
			String label = model.label;
=======
			String label = model.getLabel();
			
		//	logger.info(" -----la etiqueta que debo dibujar es: "+ model.getLabel());
>>>>>>> Jony
			/*
			if (model.label == "CO" | model.label =="PP"){
				logger.info(" la etiqueta que debo dibujar es: "+ label+" o quiza: "+model.label);		
			};			
            *///repaint();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
			if (label == "CO" | label =="PP"){
				logger.info(" la etiqueta que debo dibujar es: "+ label);		
<<<<<<< HEAD
			};
            switch (object) {
                case Tablero.STEAK: drawSTEAK(g, x, y, Color.blue, label);  break;
				case Tablero.REDSTEAK: drawSTEAK(g, x, y, Color.red, label);  break;
				case Tablero.GREENSTEAK: drawSTEAK(g, x, y, Color.green, label);  break;
				case Tablero.BLACKSTEAK: drawSTEAK(g, x, y, Color.lightGray, label);  break;
				case Tablero.ORANGESTEAK: drawSTEAK(g, x, y, Color.orange, label);  break;
				case Tablero.MAGENTASTEAK: drawSTEAK(g, x, y, Color.magenta, label);  break;
=======
			};	
            switch (object) {
                case Tablero.FICHABLUE: drawFICHA(g, x, y, Color.blue, label);  break;
				case Tablero.FICHARED: drawFICHA(g, x, y, Color.red, label);  break;
				case Tablero.FICHAGREEN: drawFICHA(g, x, y, Color.green, label);  break;
				case Tablero.FICHABLACK: drawFICHA(g, x, y, Color.lightGray, label);  break;
				case Tablero.FICHAORANGE: drawFICHA(g, x, y, Color.orange, label);  break;
				case Tablero.FICHAMAGENTA: drawFICHA(g, x, y, Color.magenta, label);  break;
>>>>>>> Jony
            };
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            //String label = "R"+(id+1);
            c = Color.white;
            //super.drawAgent(g, x, y, c, -1);
			//drawGarb(g, x, y);
<<<<<<< HEAD
		}
		
		public void drawSTEAK(Graphics g, int x, int y, Color c, String label) {
			g.setColor(c);
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
			g.setColor(Color.black);
			drawString(g,x,y,defaultFont,label);
		}

        public void drawGarb(Graphics g, int x, int y) {
            super.drawObstacle(g, x, y);
            g.setColor(Color.blue);
            drawString(g, x, y, defaultFont, "G");
        }

=======
			logger.info("drawAgent");
		}
		
		public void drawFICHA(Graphics g, int x, int y, Color c, String label) {
			g.setColor(c);
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
			g.setColor(Color.black);
		//	logger.info(" la etiqueta que debo dibujar es: "+ label);
			drawString(g,x,y,defaultFont,label);
		}
>>>>>>> Jony
    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}


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
    public static final int FICHABLUE  = 16; // steak code in grid model
	public static final int FICHARED  = 32; // steak code in grid model
	public static final int FICHAGREEN  = 64; // steak code in grid model
	public static final int FICHABLACK  = 128; // steak code in grid model
	public static final int FICHAORANGE  = 256; // steak code in grid model
	public static final int FICHAMAGENTA  = 512; // steak code in grid model
	

    private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

    private TableroModel model;
    private TableroView  view;
    
	String label = "";
    /** Called before the MAS execution with the args informed in .mas2j */
    @Override
    public void init(String[] args) {
        model = new TableroModel();
        view  = new TableroView(model);
        model.setView(view);
        super.init(args);
		addPercept("judge",Literal.parseLiteral("sizeof(" + (GSize - 1) + ")"));
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
					 String l = action.getTerm(3).toString();
					 
					 if(l.equals("in")){
						label="";
					}else{
						label=l;
					}
					 model.put(x,y,c,l);
				 } else if(action.getFunctor().equals("exchange")){
					 int c1 = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x1 = (int)((NumberTerm)action.getTerm(1)).solve();
					 int x2 = (int)((NumberTerm)action.getTerm(2)).solve();
					 int c2 = (int)((NumberTerm)action.getTerm(3)).solve();
					 int y1 = (int)((NumberTerm)action.getTerm(4)).solve();
					 int y2 = (int)((NumberTerm)action.getTerm(5)).solve();
					 String label1 = action.getTerm(6).toString();
					 String label2 = action.getTerm(7).toString();
					 //model.exchange(c1,x1,x2,c2,y1,y2,label1,label2);
				 } else if(action.getFunctor().equals("deleteSteak")){
					 int c = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x = (int)((NumberTerm)action.getTerm(1)).solve();
					 int y = (int)((NumberTerm)action.getTerm(2)).solve();
					 
					 model.deleteSteak(c,x,y);
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
            Thread.sleep(50);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

    /** creates the agents perception based on the MarsModel */
    void updatePercepts() {
        Literal newMov = Literal.parseLiteral("done");
		addPercept("judge",newMov);    
    }

    class TableroModel extends GridWorldModel {
        Random random = new Random(System.currentTimeMillis());
		String label = "";
        private TableroModel() {
            super(GSize, GSize, 3);
            try {
                setAgPos(0, 0, 0);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
		
		void deleteSteak(int c,int x, int y) throws Exception {
			remove(c,new Location(x,y));
		}
		
		void moveSteaks()throws Exception {
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
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
			String label = model.getLabel();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
			if (label == "CO" | label =="PP"){
				logger.info(" la etiqueta que debo dibujar es: "+ label);		
			};	
            switch (object) {
                case Tablero.FICHABLUE: drawFICHA(g, x, y, Color.blue, label);  break;
				case Tablero.FICHARED: drawFICHA(g, x, y, Color.red, label);  break;
				case Tablero.FICHAGREEN: drawFICHA(g, x, y, Color.green, label);  break;
				case Tablero.FICHABLACK: drawFICHA(g, x, y, Color.lightGray, label);  break;
				case Tablero.FICHAORANGE: drawFICHA(g, x, y, Color.orange, label);  break;
				case Tablero.FICHAMAGENTA: drawFICHA(g, x, y, Color.magenta, label);  break;
            };
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            c = Color.white;
		}
		
		public void drawFICHA(Graphics g, int x, int y, Color c, String label) {
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
    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}


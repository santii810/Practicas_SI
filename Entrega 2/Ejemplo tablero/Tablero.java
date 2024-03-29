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
    public static final int STEAK  = 16; // steak code in grid model
	public static final int REDSTEAK  = 32; // steak code in grid model
	public static final int GREENSTEAK  = 64; // steak code in grid model
	public static final int BLACKSTEAK  = 128; // steak code in grid model
	public static final int ORANGESTEAK  = 256; // steak code in grid model
	public static final int MAGENTASTEAK  = 512; // steak code in grid model
	

    private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

    private TableroModel model;
    private TableroView  view;
    
	String label = "  ";
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
					 int steak = (int)((NumberTerm)action.getTerm(3)).solve();
					 if (steak == 0) { label = "  ";} else
					 if (steak == 1) { label = "ip";} else
					 if (steak == 2) { label = "ct";} else
					 if (steak == 3) { label = "gs";} else
					 if (steak == 4) { label = "co";} else
					 {label = "TT";};
					 //model.put(x,y,c);
					 model.put(x,y,c,label);
				 } else if(action.getFunctor().equals("exchange")){
					 int c1 = (int)((NumberTerm)action.getTerm(0)).solve();
					 int x1 = (int)((NumberTerm)action.getTerm(1)).solve();
					 int x2 = (int)((NumberTerm)action.getTerm(2)).solve();
					 int c2 = (int)((NumberTerm)action.getTerm(3)).solve();
					 int y1 = (int)((NumberTerm)action.getTerm(4)).solve();
					 int y2 = (int)((NumberTerm)action.getTerm(5)).solve();
					 model.exchange(c1,x1,x2,c2,y1,y2);
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
            Thread.sleep(100);
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
			//String label = label;
            // initial location of agents
            try {
                setAgPos(0, 0, 0);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
			removePercept("judge",Literal.parseLiteral("steak("+ c1 +"," + x1 + "," + y1 + ")"));
			remove(c2,new Location(x2,y2));
			removePercept("judge",Literal.parseLiteral("steak(" + c2 + "," + x2 + "," + y2 + ")"));

			set(c2,x1,y1);
			addPercept("judge",Literal.parseLiteral("steak("+ c2 +"," + x1 + "," + y1 + ")"));
			set(c1,x2,y2);
			addPercept("judge",Literal.parseLiteral("steak(" + c1 + "," + x2 + "," + y2 + ")"));
		}
		
		void deleteSteak(int c,int x, int y) throws Exception {
			remove(c,new Location(x,y));
			removePercept("judge",Literal.parseLiteral("steak("+ c +"," + x + "," + y + ")"));
		}
		
		void moveSteaks()throws Exception {
			for(int i = 0; i < GSize; i++){
				for(int j = 0; j < GSize; j++){
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
			String label = model.label;
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
			};
            switch (object) {
                case Tablero.STEAK: drawSTEAK(g, x, y, Color.blue, label);  break;
				case Tablero.REDSTEAK: drawSTEAK(g, x, y, Color.red, label);  break;
				case Tablero.GREENSTEAK: drawSTEAK(g, x, y, Color.green, label);  break;
				case Tablero.BLACKSTEAK: drawSTEAK(g, x, y, Color.lightGray, label);  break;
				case Tablero.ORANGESTEAK: drawSTEAK(g, x, y, Color.orange, label);  break;
				case Tablero.MAGENTASTEAK: drawSTEAK(g, x, y, Color.magenta, label);  break;
            };
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            //String label = "R"+(id+1);
            c = Color.white;
            //super.drawAgent(g, x, y, c, -1);
			//drawGarb(g, x, y);
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

    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}


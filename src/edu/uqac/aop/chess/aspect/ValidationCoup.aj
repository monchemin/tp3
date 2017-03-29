package edu.uqac.aop.chess.aspect;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.*;
import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.piece.*;


//Aspect de validation des coups

public aspect ValidationCoup {
	pointcut mkmoovHP(Move mv) : call(* *.makeMove(Move)) && args(mv);
	pointcut movePiece(Move mv, Spot[][] grid) : execution(* Board.movePiece(Move, Spot[][])) && args(mv, grid);

	//Gestion auto-attaque : les pieces peuvent s'attaquer elles mêmes (mouvement g6g6 par ex.).
	//L'aspect interdit ces mouvements 
	boolean around(Move mv) : mkmoovHP(mv){

		
		String depart = mv.toString().substring(0, 2);
		String fin = mv.toString().substring(2, 4);
		
		if(depart.equals(fin)){
			
			System.out.println("coup invalide : auto-attaque");
			
			return false;
			
		}else{
			
			return proceed(mv);
		}
	
	}
	
	void around(Move mv, Spot[][] grid):movePiece(mv, grid){
	
		Piece piece = grid[mv.xI][mv.yI].getPiece();
		String type = piece.toString();	
		
		switch(type){
			case "p" : case "P": 
				if(((mv.xF-mv.xI)!=0)&& !grid[mv.xF][mv.yF].isOccupied()){
					System.out.println("Coup interdit : deplacement diagonal interdit hors attaque");
				}
				break;
			case "t" : case "T": 
				int x = mv.xF - mv.xI;
				int y = mv.yF - mv.yI;
				
				for (int i = 1; i < x; i++) {
					if(grid[mv.xI+i][mv.yI].isOccupied()){
						System.out.println("coup interdit : " + grid[mv.xI+i][mv.yI].getPiece().toString()+ " bloque la trajectoire");
					}
				}
				for (int i = 1; i < y; i++) {
					if(grid[mv.xI][mv.yI+i].isOccupied()){
						System.out.println("coup interdit : " + grid[mv.xI+i][mv.yI].getPiece().toString()+ " bloque la trajectoire");
					}
				}
				break;
			case "b": case "B":
				x = mv.xF - mv.xI;
				y = mv.yF - mv.yI;
				
				boolean descent = (y>0);
				boolean droite = (x>0);
				
					if(droite&&descent){
						System.out.println("descent droite [x,y] [" + x + ","+y + "]");
						for(int i = 1; i<x;i++){
							if(grid[mv.xI+i][mv.yI+i].isOccupied()){
								System.out.println("coup interdit : " + grid[mv.xI+i][mv.yI+i].getPiece().toString()+ " bloque la trajectoire");	
							}
						}
					}else if(!droite&&descent){
						for(int i = 1; i<y;i++){
							if(grid[mv.xI-i][mv.yI+i].isOccupied()){
								System.out.println("coup interdit : " + grid[mv.xI-i][mv.yI+i].getPiece().toString()+ " bloque la trajectoire");	
							}
						}
					}else if(droite&&!descent){
						for(int i = 1; i<x;i++){
							if(grid[mv.xI+i][mv.yI-i].isOccupied()){
								System.out.println("coup interdit : " + grid[mv.xI+i][mv.yI-i].getPiece().toString()+ " bloque la trajectoire");	
							}
						}
					}else if(!droite&&!descent){
						for(int i = 1; i<Math.abs(y);i++){
							if(grid[mv.xI-i][mv.yI-i].isOccupied()){
								System.out.println("coup interdit : " + grid[mv.xI-i][mv.yI-i].getPiece().toString()+ " bloque la trajectoire");	
							}
						}
					}
				
				break;
			default :
				
				break;
		}
		
		proceed(mv, grid);
	}
	
}

package edu.uqac.aop.chess.aspect;

import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.*;


//Aspect de validation des coups

public aspect ValidationCoup {
	pointcut mkmoovHP(Move mv) : call(* *.makeMove(Move)) && args(mv);
	
	boolean around(Move mv) : mkmoovHP(mv){
		//Gestion auto-attaque
		
		
		String depart = mv.toString().substring(0, 2);
		String fin = mv.toString().substring(2, 4);
		
		if(depart.equals(fin)){
			
			System.out.println("coup invalide : auto-attaque");
			
			return false;
			
		}else{
			
			return proceed(mv);
		}
	
	}

}

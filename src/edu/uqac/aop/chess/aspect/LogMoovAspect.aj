package edu.uqac.aop.chess.aspect;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Calendar;

import org.aspectj.lang.annotation.Pointcut;

import edu.uqac.aop.chess.agent.*;


public aspect LogMoovAspect {
	PrintWriter logCoup;
	pointcut hlire() : execution(char HumanPlayer.Lire(..)); //lecture de chaque caractère saisi
	pointcut vider() : execution(* HumanPlayer.ViderBuffer(..)); //vider le coup
	pointcut makeMoovHP(Move mv) : execution(* HumanPlayer.makeMove(Move)) && args(mv);
	pointcut makeMoovAP() : execution(Move AiPlayer.makeMove());
	
	String coup ="";
	
	
	 after() returning(char c) : hlire()
	{
		coup += c;
	}
	 
	after() : vider()
	{
		try { // logger du coup réel 
			logCoup = new PrintWriter(new FileWriter("logCoup.txt", true));
			logCoup.println(Calendar.getInstance().getTime() + " | " + " coup(joue) H : " + coup );
			coup = "";
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {logCoup.close();}
	}
	
	before(Move mv) : makeMoovHP(mv)
	{
		try { // logger du coup inscrit
			logCoup = new PrintWriter(new FileWriter("logCoup.txt", true));
			logCoup.println(Calendar.getInstance().getTime() + " | " + " coup(inscrit) H : " + mv.toString() );
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		finally {logCoup.close();};
		
	}
	

	
	//after() returning(char c) : hlire()
	after() returning(Move mv) : makeMoovAP()
	{
		try { //logger du coup machine 
			logCoup = new PrintWriter(new FileWriter("logCoup.txt", true));
			logCoup.println( Calendar.getInstance().getTime() + " | " + " coup M : " + mv );
			

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {logCoup.close();}
		
	}

}


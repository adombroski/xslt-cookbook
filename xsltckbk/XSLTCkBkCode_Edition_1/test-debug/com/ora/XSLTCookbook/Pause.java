package com.ora.XSLTCookbook;

public class Pause {

	public static void pause() throws java.io.IOException {
     System.out.flush() ;
     System.err.flush() ;
     byte [] b = new byte [3] ;
     System.in.read(b,0,1) ;
	}
}

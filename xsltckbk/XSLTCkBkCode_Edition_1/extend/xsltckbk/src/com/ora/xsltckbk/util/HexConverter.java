package com.ora.xsltckbk.util;

public class HexConverter
{

  public static String toHex(String intString)
  {
    try
    {
 	    Integer temp = new Integer(intString) ;
	    return new String("0x").concat(Integer.toHexString(temp.intValue())) ;
 	  }
	  catch (Exception e)
    {
	    return new String("0x0") ;
	  }
  }
}


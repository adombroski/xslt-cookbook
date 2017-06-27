package com.ora.xsltckbk.util ;
import java.awt.* ;
import java.awt.geom.* ;
import java.lang.System ;

public class FontMetrics
{
  public FontMetrics(String fontName, int size)
  {
    //Any concrete component will do
    Label component = new Label() ;
    m_metrics
      = component.getFontMetrics(
           new Font(fontName, Font.PLAIN, size)) ;
    m_graphics = component.getGraphics() ;
  }

  public FontMetrics(String fontName, int size, boolean bold, boolean italic)
  {
    //Any concrete component will do
    Label component = new Label() ;
    m_metrics
      = component.getFontMetrics(
           new Font(fontName, style(bold,italic) , size)) ;
    m_graphics = component.getGraphics() ;
  }

  //Simple, but less accurate on some fonts
  public int stringWidth(String str)
  {
    return  m_metrics.stringWidth(str) ;
  }

  //Better accuracy on most fonts
  public double stringWidthImproved(String str)
  {
    Rectangle2D rect = m_metrics.getStringBounds(str, m_graphics) ;
    return rect.getWidth() ;
  }

  static private int style(boolean bold, boolean italic)
  {
    int style = Font.PLAIN ;
    if (bold) { style |= Font.BOLD;}
    if (italic) { style |= Font.ITALIC;}
    return style ;
  }

  private java.awt.FontMetrics m_metrics = null;
  private java.awt.Graphics m_graphics = null ;
}


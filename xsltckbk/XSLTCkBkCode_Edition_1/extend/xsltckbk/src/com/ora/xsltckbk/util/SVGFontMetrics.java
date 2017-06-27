package com.ora.xsltckbk.util ;
import java.awt.* ;
import java.awt.geom.* ;
import java.awt.font.* ;
import java.awt.image.*;

public class SVGFontMetrics
{
  public SVGFontMetrics(String fontName, int size)
  {
    m_font = new Font(fontName, Font.PLAIN, size) ;
    BufferedImage bi
        = new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB);
    m_graphics2D = bi.createGraphics() ;
  }

  public SVGFontMetrics(String fontName, int size, boolean bold, boolean italic)
  {
    m_font = new Font(fontName, style(bold,italic) , size) ;
    BufferedImage bi
        = new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB);
    m_graphics2D = bi.createGraphics() ;
  }

  public double stringWidth(String str)
  {
    FontRenderContext frc = m_graphics2D.getFontRenderContext();
    TextLayout layout = new TextLayout(str, m_font, frc);
    Rectangle2D rect = layout.getBounds() ;
    return rect.getWidth() ;
  }

  public double stringHeight(String str)
  {
    FontRenderContext frc = m_graphics2D.getFontRenderContext();
    TextLayout layout = new TextLayout(str, m_font, frc);
    Rectangle2D rect = layout.getBounds() ;
    return rect.getHeight() ;
  }

  static private int style(boolean bold, boolean italic)
  {
    int style = Font.PLAIN ;
    if (bold) { style |= Font.BOLD;}
    if (italic) { style |= Font.ITALIC;}
    return style ;
  }

  private Font m_font = null ;
  private Graphics2D m_graphics2D = null;
}


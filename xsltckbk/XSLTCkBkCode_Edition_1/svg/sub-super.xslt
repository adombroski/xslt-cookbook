<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:m="http://www.w3.org/1998/Math/MathML">

 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
                   doctype-system="http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd" 
                   doctype-public="-//W3C//DTD SVG 20001102//EN"/>
	
 <xsl:template match="/">
    <svg width="500pt" height="100pt">
      <xsl:apply-templates/>
    </svg>
  </xsl:template>
  
  <xsl:template match="m:math/m:mrow">
    <text x="1cm" y="1cm" style="font-size: 20pt;">
      <xsl:apply-templates/>
    </text>
  </xsl:template>
  
  <xsl:template match="m:msub">
    <xsl:apply-templates select="*[1]" mode="base"/>
    <xsl:apply-templates select="*[2]" mode="sub"/>
  </xsl:template>

  <xsl:template match="m:msup">
    <xsl:apply-templates select="*[1]" mode="base"/>
    <xsl:apply-templates select="*[2]" mode="sup"/>
  </xsl:template>

  <xsl:template match="m:msubsup">
    <xsl:apply-templates select="*[1]" mode="base"/>
    <xsl:apply-templates select="*[2]" mode="sub"/>
    <xsl:apply-templates select="*[3]" mode="subsup">
      <xsl:with-param name="sub-length" select="string-length(*[2])"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="m:mi | m:mn"   mode="base">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="m:mi | m:mn"   mode="sub">
    <tspan style="baseline-shift: sub; font-size: 50%;">
    <xsl:value-of select="."/>
    </tspan>
  </xsl:template>

  <xsl:template match="m:mi | m:mn"   mode="sup">
    <tspan style="baseline-shift: super; font-size: 50%;">
    <xsl:value-of select="."/>
    </tspan>
  </xsl:template>

  <xsl:template match="m:mi | m:mn"   mode="subsup">
    <xsl:param name="sub-length"/>
    <tspan style="baseline-shift: super; font-size: 50%;" dx="-1em">
    <xsl:value-of select="."/>
    </tspan>
  </xsl:template>
  
</xsl:stylesheet>


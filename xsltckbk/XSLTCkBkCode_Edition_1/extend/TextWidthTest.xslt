<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt" 
xmlns:font="xalan://com.ora.xsltckbk.util.SVGFontMetrics" 
exclude-result-prefixes="font xalan">

<xsl:output method="xml"/>

<xsl:template match="/">
  <svg width="100%" height="100%">
    <xsl:apply-templates/>
  </svg>
</xsl:template>


<xsl:template match="text">
  <xsl:variable name="fontMetrics" select="font:new(@font, @size, boolean(@weight), boolean(@stytle))"/>
  <xsl:variable name="text" select="."/>
  <xsl:variable name="width" select="font:stringWidth($fontMetrics, $text)"/>
  <xsl:variable name="height" select="font:stringHeight($fontMetrics, $text)"/>
  <xsl:variable name="style">
    <xsl:if test="@style">
      <xsl:value-of select="concat('font-style:',@style)"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="weight">
    <xsl:if test="@weight">
      <xsl:value-of select="concat('font-weight:',@weight)"/>
    </xsl:if>
  </xsl:variable>
  <g style="font-family:{@font};font-size:{@size};{$style};{$weight}">
    <!-- Use the SVGFontMetrics info render a rectangle that is -->
    <!-- slightly bigger than the expected size of the text -->
    <!-- Adjust the y position based on the previous text size. -->
    <rect x="10" 
          y="{sum(preceding-sibling::text/@size) * 2}pt" 
          width="{$width + 2}" 
          height="{$height + 2}"
          style="fill:none;stroke: black;stroke-width:0.5;"/>
    <!-- Render the text so it is cenetered in the rectangle -->
    <text x="11" 
          y="{sum(preceding-sibling::text/@size) * 2 + @size div 2 + 2}pt">
      <xsl:value-of select="."/>
    </text>
  </g>
        
</xsl:template>


</xsl:stylesheet>

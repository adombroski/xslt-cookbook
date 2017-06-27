<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu test">

<xsl:import href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<test:xdata>0.0</test:xdata> 
<test:xdata>1.0</test:xdata> 
<test:xdata>2.0</test:xdata> 
<test:xdata>3.0</test:xdata> 
<test:xdata>4.0</test:xdata> 
<test:xdata>5.0</test:xdata> 
<test:xdata>6.0</test:xdata> 

<test:ydata>0.0</test:ydata> 
<test:ydata>1.0</test:ydata> 
<test:ydata>4.0</test:ydata> 
<test:ydata>9.0</test:ydata> 
<test:ydata>16.0</test:ydata> 
<test:ydata>25.0</test:ydata> 
<test:ydata>36.0</test:ydata> 

<test:y2data>0.0</test:y2data> 
<test:y2data>1.0</test:y2data> 
<test:y2data>1.4</test:y2data> 
<test:y2data>1.7</test:y2data> 
<test:y2data>2.0</test:y2data> 
<test:y2data>2.23</test:y2data> 
<test:y2data>2.45</test:y2data> 

<xsl:variable name="w" select="400"/>
<xsl:variable name="h" select="300"/>
<xsl:variable name="pwidth" select="$w * 0.8"/>
<xsl:variable name="pheight" select="$h * 0.8"/>
<xsl:variable name="offsetX" select="($w - $pwidth) div 2"/>
<xsl:variable name="offsetY" select="($h - $pheight) div 2"/>

<xsl:template match="/">

<svg width="{$w}" height="{$h}">

  <xsl:call-template name="svgu:xyPlot">
    <xsl:with-param name="dataY" select="document('')/*/test:ydata"/>  
    <xsl:with-param name="offsetX" select="$offsetX"/>
    <xsl:with-param name="offsetY" select="$offsetY"/>
    <xsl:with-param name="width" select="$pwidth"/>
    <xsl:with-param name="height" select="$pheight"/>
    <xsl:with-param name="maxY" select="40"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:xyPlot">
    <xsl:with-param name="dataY" select="document('')/*/test:y2data"/>  
    <xsl:with-param name="offsetX" select="$offsetX"/>
    <xsl:with-param name="offsetY" select="$offsetY"/>
    <xsl:with-param name="width" select="$pwidth"/>
    <xsl:with-param name="height" select="$pheight"/>
    <xsl:with-param name="maxY" select="40"/>
    <xsl:with-param name="context" select="2"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:xAxis">
    <xsl:with-param name="min" select="0"/>
    <xsl:with-param name="max" select="6"/>
    <xsl:with-param name="offsetX" select="$offsetX"/>
    <xsl:with-param name="offsetY" select="$offsetY"/>
    <xsl:with-param name="width" select="$pwidth"/>
    <xsl:with-param name="height" select="$pheight"/>
    <xsl:with-param name="majorTopExtent" select="$pheight"/>
    <xsl:with-param name="minorTopExtent" select="$pheight"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:yAxis">
    <xsl:with-param name="min" select="0"/>
    <xsl:with-param name="max" select="40"/>
    <xsl:with-param name="offsetX" select="$offsetX"/>
    <xsl:with-param name="offsetY" select="$offsetY"/>
    <xsl:with-param name="width" select="$pwidth"/>
    <xsl:with-param name="height" select="$pheight"/>
    <xsl:with-param name="majorRightExtent" select="$pwidth"/>
    <xsl:with-param name="minorRightExtent" select="$pwidth"/>
  </xsl:call-template>
  
</svg>

</xsl:template>

 <xsl:template name="svgu:xyPlotStyle">
   <xsl:param name="context"/>
   <xsl:param name="scale"/>
   <xsl:choose>
    <xsl:when test="$context = 2">
     <xsl:value-of select="concat('fill: none; stroke: red; stroke-width:',16 div $scale,'; ')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="concat('fill: none; stroke: black; stroke-width:',1 div $scale,'; ')"/>
    </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

</xsl:stylesheet>

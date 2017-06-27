<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:emath="http://www.exslt.org/math" 
  exclude-result-prefixes="svgu">

  <xsl:include href="svg-utils.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
    doctype-public="-//W3C//DTD SVG 1.0/EN"
    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

  <xsl:variable name="width" select="600"/>
  <xsl:variable name="height" select="500"/>
  <xsl:variable name="pwidth" select="$width * 0.8"/>
  <xsl:variable name="pheight" select="$height * 0.8"/>
  <xsl:variable name="offsetX" select="($width - $pwidth) div 2"/>
  <xsl:variable name="offsetY" select="10"/>

  <xsl:variable name="dataMin">
    <xsl:call-template name="emath:min">
      <xsl:with-param name="nodes" select="//Low"/>
    </xsl:call-template>
  </xsl:variable> 

  <xsl:variable name="dataMax">
    <xsl:call-template name="emath:max">
      <xsl:with-param name="nodes" select="//High"/>
    </xsl:call-template>
  </xsl:variable> 

  <xsl:variable name="min" select="$dataMin * 0.9"/>
  <xsl:variable name="max" select="$dataMax * 1.1"/>


  <xsl:template match="/">


  <svg width="{$width}" height="{$height}">

  <text x="{$width div 2}" y="{2 * $offsetY}" style="text-anchor:middle; font-size:24">MSFT Stock Chart</text>
  <text x="{$width div 2}" y="{4 * $offsetY}" style="text-anchor:middle; font-size:12">05/23/2002 to 08/16/2002</text>
  <!-- PRICE -->
  
    <xsl:call-template name="svgu:openHiLoClose">
      <xsl:with-param name="openData" select="*/row/Open"/>            
      <xsl:with-param name="hiData" select="*/row/High"/>            
      <xsl:with-param name="loData" select="*/row/Low"/>            
      <xsl:with-param name="closeData" select="*/row/Close"/>            
      <xsl:with-param name="min" select="$min"/>
      <xsl:with-param name="max" select="$max"/>
      <xsl:with-param name="width" select="$pwidth"/> 
      <xsl:with-param name="height" select="$pheight"/>
      <xsl:with-param name="offsetX" select="$offsetX"/>
      <xsl:with-param name="offsetY" select="$offsetY"/>
      <xsl:with-param name="boundingBox" select="1"/>
    </xsl:call-template>
  
    <xsl:call-template name="svgu:yAxis">
      <xsl:with-param name="offsetX" select="$offsetX"/>
      <xsl:with-param name="offsetY" select="$offsetY"/>
      <xsl:with-param name="width" select="$pwidth"/>
      <xsl:with-param name="height" select="$pheight"/>
      <xsl:with-param name="min" select="$min"/>
      <xsl:with-param name="max" select="$max"/>
      <xsl:with-param name="context" select=" 'price' "/>
    </xsl:call-template>

  <!-- VOLUME -->
  <xsl:variable name="vheight" select="100"/>
    
  <xsl:call-template name="svgu:bars">
    <xsl:with-param name="data" select="*/row/Volume"/>
    <xsl:with-param name="width" select="$pwidth"/> 
    <xsl:with-param name="height" select="$vheight"/>
    <xsl:with-param name="orientation" select="0"/>
    <xsl:with-param name="offsetX" select="$offsetX"/>
    <xsl:with-param name="offsetY" select="$pheight - $offsetY"/>
    <xsl:with-param name="barLabel" select="false()"/>
    <xsl:with-param name="min" select="0"/>
    <xsl:with-param name="max" select="1500000"/>
  </xsl:call-template>
    
  <!-- This is to make the line plot start on first bar and end on last bar -->  
  <xsl:variable name="spacing" select="$pwidth div count(*/row/High) + 1"/>

  <xsl:call-template name="svgu:xyPlot">
    <xsl:with-param name="dataY" select="*/row/Vol10MA"/>  
    <xsl:with-param name="width" select="$pwidth - 2 * $spacing"/>
    <xsl:with-param name="height" select="$vheight"/>
    <xsl:with-param name="offsetX" select="$offsetX + $spacing"/>
    <xsl:with-param name="offsetY" select="$pheight - $offsetY"/>
    <xsl:with-param name="minY" select="0"/>
    <xsl:with-param name="maxY" select="1500000"/>
  </xsl:call-template>
   
    <xsl:call-template name="svgu:yAxis">
      <xsl:with-param name="offsetX" select="$width - $offsetX"/>
      <xsl:with-param name="offsetY" select="$height - $vheight - $offsetY"/>
      <xsl:with-param name="width" select="$pwidth"/>
      <xsl:with-param name="height" select="$vheight"/>
      <xsl:with-param name="min" select="0"/>
      <xsl:with-param name="max" select="1500000"/>
      <xsl:with-param name="context" select=" 'volume' "/>
    </xsl:call-template>
    
  </svg>

</xsl:template>

 <xsl:template name="svgu:barStyle">
    <xsl:text>stroke: black; stroke-wdth: 0.15</xsl:text> 
 </xsl:template>

 <xsl:template name="svgu:xyPlotStyle">
   <xsl:param name="context"/>
   <xsl:param name="scale"/>
   <xsl:value-of select="concat('fill: none; stroke: black; stroke-width:',4 div $scale,'; ')"/>
 </xsl:template>

   <xsl:template name="yAxisLabelStyle">
     <xsl:param name="context"/>
     <xsl:choose>
      <xsl:when test="$context = 'price'">
       <xsl:text>text-anchor:end;font-size:8;baseline-shift:-50%</xsl:text>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>text-anchor:start;font-size:8;baseline-shift:-50%</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
   </xsl:template>

  <!-- Shift the volume labels away from the tick marks -->
   <xsl:template name="yAxisLabelXOffset">
     <xsl:param name="context"/>
     <xsl:if test="$context = 'volume'">
       <xsl:value-of select="6"/>
     </xsl:if>
   </xsl:template>

</xsl:stylesheet>

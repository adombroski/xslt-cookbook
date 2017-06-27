<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu test">

  <xsl:import href="svg-utils.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
    doctype-public="-//W3C//DTD SVG 1.0/EN"
    doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

  <xsl:template match="/">
  
  <xsl:variable name="width" select="300"/>
  <xsl:variable name="height" select="300"/>
  <xsl:variable name="pwidth" select="$width * 0.8"/>
  <xsl:variable name="pheight" select="$height * 0.8"/>
  <xsl:variable name="offsetX" select="($width - $pwidth) div 2"/>
  <xsl:variable name="offsetY" select="($height - $pheight) div 2"/>
  
    <svg width="{$width}" height="{$height}">
    
      <xsl:call-template name="svgu:xAxis">
        <xsl:with-param name="min" select="0"/>
        <xsl:with-param name="max" select="10"/>
        <xsl:with-param name="offsetX" select="$offsetX"/>
        <xsl:with-param name="offsetY" select="$offsetY"/>
        <xsl:with-param name="width" select="$pwidth"/>
        <xsl:with-param name="height" select="$pheight"/>
        <xsl:with-param name="majorTopExtent" select="$pheight"/>
        <xsl:with-param name="minorTopExtent" select="$pheight"/>
      </xsl:call-template>
    
      <xsl:call-template name="svgu:yAxis">
        <xsl:with-param name="min" select="0"/>
        <xsl:with-param name="max" select="10"/>
        <xsl:with-param name="offsetX" select="$offsetX"/>
        <xsl:with-param name="offsetY" select="$offsetY"/>
        <xsl:with-param name="width" select="$pwidth"/>
        <xsl:with-param name="height" select="$pheight"/>
        <xsl:with-param name="majorRightExtent" select="$pwidth"/>
        <xsl:with-param name="minorRightExtent" select="$pwidth"/>
      </xsl:call-template>
      
    </svg>
  
  </xsl:template>

</xsl:stylesheet>

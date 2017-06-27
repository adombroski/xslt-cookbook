<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  exclude-result-prefixes="svgu">

<xsl:include href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<xsl:template match="/">

<svg width="600" height="400">

  <xsl:call-template name="svgu:openHiLoClose">
    <xsl:with-param name="openData" select="*/row/open"/>            
    <xsl:with-param name="hiData" select="*/row/high"/>            
    <xsl:with-param name="loData" select="*/row/low"/>            
    <xsl:with-param name="closeData" select="*/row/close"/>            
    <xsl:with-param name="min" select="30"/>
    <xsl:with-param name="max" select="80"/>
    <xsl:with-param name="width" select="600"/> 
    <xsl:with-param name="height" select="350"/>
    <xsl:with-param name="offsetX" select="20"/>
    <xsl:with-param name="offsetY" select="20"/>
    <xsl:with-param name="boundingBox" select="1"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:yAxis">
    <xsl:with-param name="min" select="30"/>
    <xsl:with-param name="max" select="80"/>
    <xsl:with-param name="offsetX" select="20"/>
    <xsl:with-param name="offsetY" select="20"/>
    <xsl:with-param name="width" select="600"/>
    <xsl:with-param name="height" select="350"/>
  </xsl:call-template>

</svg>

</xsl:template>

</xsl:stylesheet>

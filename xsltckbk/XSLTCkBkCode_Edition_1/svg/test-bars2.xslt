<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu">

<xsl:import href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<test:data>1.0</test:data> 
<test:data>2.0</test:data> 
<test:data>3.0</test:data> 
<test:data>4.0</test:data> 
<test:data>5.0</test:data> 
<test:data>13.0</test:data> 
<test:data>2.7</test:data> 
<test:data>13.9</test:data> 
<test:data>22.0</test:data> 
<test:data>8.5</test:data> 


<xsl:template match="/">

<svg width="400" height="400">

  <xsl:call-template name="svgu:bars">
    <xsl:with-param name="data" select="document('')/*/test:data"/>
    <xsl:with-param name="width" select=" '300' "/> 
    <xsl:with-param name="height" select=" '350' "/>
    <xsl:with-param name="orientation" select=" '0' "/>
    <xsl:with-param name="offsetX" select=" '50' "/>
    <xsl:with-param name="offsetY" select=" '25' "/>
    <xsl:with-param name="boundingBox" select="1"/>
    <xsl:with-param name="barLabel" select="1"/>
    <xsl:with-param name="max" select="25"/>
  </xsl:call-template>
  
</svg>

</xsl:template>

 <xsl:template name="svgu:barLabelStyle">
   <xsl:param name="pos"/>
   <xsl:param name="context"/>
   <xsl:text>text-anchor: middle; font-size: 8</xsl:text>
 </xsl:template>


</xsl:stylesheet>

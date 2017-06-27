<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu">

<xsl:include href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<test:data>87</test:data> 
<test:data>22.0</test:data> 
<test:data>20</test:data> 
<test:data>30</test:data> 
<test:data>40</test:data> 
<test:data>50</test:data> 
<test:data>130</test:data> 
<test:data>13.0</test:data> 
<test:data>27</test:data> 
<test:data>139</test:data> 
<test:data>85</test:data> 
<test:data>1.0</test:data> 
<test:data>22.0</test:data> 
<test:data>35</test:data> 
<test:data>4.0</test:data> 
<test:data>5.0</test:data> 
<test:data>2.7</test:data> 
<test:data>220</test:data> 
<test:data>13.9</test:data> 
<test:data>8.5</test:data> 


<xsl:template match="/">

<svg width="500" height="500">

  <xsl:call-template name="svgu:bars">
    <xsl:with-param name="data" select="document('')/*/test:data[position() &lt; 11]"/>
    <xsl:with-param name="width" select=" '400' "/> 
    <xsl:with-param name="height" select=" '450' "/>
    <xsl:with-param name="orientation" select=" '0' "/>
    <xsl:with-param name="offsetX" select=" '50' "/>
    <xsl:with-param name="offsetY" select=" '25' "/>
    <xsl:with-param name="boundingBox" select="1"/>
    <xsl:with-param name="barWidth" select="2"/>
    <xsl:with-param name="barLabel" select="0"/>
    <xsl:with-param name="max" select="300"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:bars">
    <xsl:with-param name="data" select="document('')/*/test:data[position() > 10]"/>
    <xsl:with-param name="width" select=" '400' "/> 
    <xsl:with-param name="height" select=" '450' "/>
    <xsl:with-param name="orientation" select=" '0' "/>
    <xsl:with-param name="offsetX" select=" '60' "/>
    <xsl:with-param name="offsetY" select=" '25' "/>
    <xsl:with-param name="boundingBox" select="0"/>
    <xsl:with-param name="barWidth" select="2"/>
    <xsl:with-param name="barLabel" select="0"/>
    <xsl:with-param name="max" select="300"/>
  </xsl:call-template>
  
</svg>

</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu test">

<xsl:include href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<test:data>1.0</test:data> 
<test:data>2.0</test:data> 
<test:data>3.0</test:data> 
<test:data>4.0</test:data> 
<test:data>5.0</test:data> 
<test:data>13.0</test:data> 

<xsl:template match="/">

<svg width="500" height="500">

  <xsl:call-template name="svgu:pie">
    <xsl:with-param name="data" select="document('')/*/test:data"/>  
    <xsl:with-param name="cx" select="250"/>  
    <xsl:with-param name="cy" select="250"/>  
    <xsl:with-param name="r" select="100"/>       
    <xsl:with-param name="theta" select="-90"/>  
  </xsl:call-template>

  <xsl:call-template name="svgu:pieLabels">
    <xsl:with-param name="data" select="document('')/*/test:data"/>  
    <xsl:with-param name="cx" select="250"/>  
    <xsl:with-param name="cy" select="250"/>  
    <xsl:with-param name="r" select="125"/>       
    <xsl:with-param name="theta" select="-90"/>  
  </xsl:call-template>
  
</svg>

</xsl:template>

</xsl:stylesheet>

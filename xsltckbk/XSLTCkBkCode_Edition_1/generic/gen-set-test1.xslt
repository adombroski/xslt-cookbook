<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic">

  <xsl:import href="aggregation.xslt"/>
  
  <xsl:output method="text" />
  
  <xsl:template match="/">
    <xsl:call-template name="generic:gen-set">
      <xsl:with-param name="x" select="1"/>
      <xsl:with-param name="func" select=" 'square' "/>
      <xsl:with-param name="incr-param1" select="1"/>
      <xsl:with-param name="test-func" select=" 'less-than-eq' "/>
      <xsl:with-param name="test-param1" select="10"/> 
    </xsl:call-template>
  </xsl:template>

<xsl:template match="node()" mode="generic:gen-set">
<xsl:value-of select="."/>
<xsl:text> </xsl:text>
</xsl:template>

	
</xsl:stylesheet>

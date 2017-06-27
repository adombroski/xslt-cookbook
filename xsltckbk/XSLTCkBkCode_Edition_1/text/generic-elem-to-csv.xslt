<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:csv="http://www.ora.com/XSLTCookbook/namespaces/csv">

<xsl:param name="delimiter" select=" ',' "/>

<xsl:output method="text" />

<xsl:strip-space elements="*"/>
	
<xsl:template match="/">
  <xsl:for-each select="$columns">
    <xsl:value-of select="@name"/>
   <xsl:if test="position() != last()">
      <xsl:value-of select="$delimiter"/>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>&#xa;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="/*/*">
  <xsl:variable name="row" select="."/>
  
  <xsl:for-each select="$columns">
    <xsl:apply-templates select="$row/*[local-name(.)=current()/@elem]" mode="csv:map-value"/>
    <xsl:if test="position() != last()">
    <xsl:value-of select="$delimiter"/>
    </xsl:if>
  </xsl:for-each>

  <xsl:text>&#xa;</xsl:text>
 
</xsl:template>

<xsl:template match="node()" mode="csv:map-value">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>
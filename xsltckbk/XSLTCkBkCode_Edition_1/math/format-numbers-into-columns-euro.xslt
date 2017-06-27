<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings">
	<xsl:output method="text" />

<xsl:include href="../strings/str.dup.xslt"/>

<xsl:variable name="numCols" select="3"/>	

<xsl:decimal-format name="WesternEurope" decimal-separator="," grouping-separator="."/> 

<xsl:template match="numbers">
  <xsl:for-each select="number[position() mod $numCols = 1]">
    <xsl:apply-templates select=". | following-sibling::number[position() &lt; $numCols]" mode="format"/>
    <xsl:text>&#xa;</xsl:text> 
  </xsl:for-each>
</xsl:template>

<xsl:template match="number" name="format" mode="format">
  <xsl:param name="number" select="." />
  <xsl:call-template name="pad">
    <xsl:with-param name="string" select="format-number($number,'#.###,00','WesternEurope')"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pad">
  <xsl:param name="string"/>
  <xsl:param name="width" select="16"/>
  <xsl:call-template name="str:dup">
    <xsl:with-param name="input" select="' '"/>
    <xsl:with-param name="count" select="$width - string-length($string)"/>
  </xsl:call-template>
  <xsl:value-of select="$string"/>
</xsl:template>

	
</xsl:stylesheet>

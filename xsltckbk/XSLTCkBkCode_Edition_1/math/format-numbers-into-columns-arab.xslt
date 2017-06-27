<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings">

<xsl:output method="text"  encoding="UTF-8"/>

<xsl:include href="../strings/str.dup.xslt"/>

<xsl:decimal-format name="Arabic" zero-digit="&#x660;"/> 
	
<xsl:template match="numbers">
  <xsl:for-each select="number">
      <xsl:call-template name="pad">
        <xsl:with-param name="string" select="format-number(.,'#,###.00')"/>
      </xsl:call-template> = <xsl:text/>
      <xsl:value-of select="format-number(.,'#,###.&#x660;&#x660;','Arabic')"/>
     <xsl:text>&#xa;</xsl:text> 
  </xsl:for-each>
</xsl:template>

<xsl:template name="pad">
  <xsl:param name="string"/>
  <xsl:param name="width" select="16"/>
  <xsl:value-of select="$string"/>
  <xsl:call-template name="str:dup">
    <xsl:with-param name="input" select="' '"/>
    <xsl:with-param name="count" select="$width - string-length($string)"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

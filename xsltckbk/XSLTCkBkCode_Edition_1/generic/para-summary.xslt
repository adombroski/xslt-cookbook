<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template name="extract-sentences">
  <xsl:param name="text"/>
  <xsl:param name="num-sentences" select="1"/> 
   <xsl:choose>
    <xsl:when test="$num-sentences >= 1 and contains($text,'.')">
      <xsl:value-of select="substring-before($text,'.')"/>
      <xsl:text>.</xsl:text>
      <xsl:call-template name="extract-sentences">
        <xsl:with-param name="text" select="substring-after($text,'.')"/>
        <xsl:with-param name="num-sentences" select="$num-sentences - 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
  <summary>
    <xsl:apply-templates select=".//para"/>
  </summary>
</xsl:template>

<xsl:template match="para">
  <para>
      <xsl:call-template name="extract-sentences">
        <xsl:with-param name="text" select="."/>
        <xsl:with-param name="num-sentences" select="3"/>
      </xsl:call-template>
    </para>
</xsl:template>
	
</xsl:stylesheet>

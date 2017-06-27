<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="group">
    <xsl:param name="level" select=" '' "/>
    
    <xsl:variable name="number">
      <xsl:value-of select="$level"/>
      <xsl:number count="group" level="single" format="1"/>
    </xsl:variable>
    
    <xsl:text>Group </xsl:text>
    <xsl:value-of select="$number"/>
    <xsl:text>&#xa;</xsl:text>

    <xsl:apply-templates>
      <xsl:with-param name="level" select="concat($number,'.')"/>
    </xsl:apply-templates>
    
  </xsl:template>

  <xsl:template match="person">
    <xsl:param name="level" select=" '' "/>

    <xsl:variable name="number">
      <xsl:value-of select="$level"/>
      <xsl:number count="person" level="single" format="1 "/>
    </xsl:variable>

    <xsl:value-of select="$number"/>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>

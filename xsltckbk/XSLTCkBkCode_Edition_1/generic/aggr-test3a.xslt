<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:output method="xml" indent="yes"/>

<xsl:template match="numbers">

<results>
  <sumSq>
    <xsl:call-template name="sumSqs">
      <xsl:with-param name="nodes" select="number"/>
    </xsl:call-template> 
  </sumSq>

</results> 
  
</xsl:template>

<xsl:template name="sumSqs">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="accum" select="0"/>
  <xsl:choose>
    <xsl:when test="$nodes">
      <xsl:variable name="x" select="$nodes[1]"/>
      <xsl:call-template name="sumSqs">
        <xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
        <xsl:with-param name="accum" select="$accum + $x * $x"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$accum"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

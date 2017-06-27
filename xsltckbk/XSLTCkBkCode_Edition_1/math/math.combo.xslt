<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template name="math:P">
	<xsl:param name="n" select="1"/>
	<xsl:param name="r" select="1"/>
      <xsl:choose>
        <xsl:when test="$n &lt; 0 or $r &lt; 0">NaN</xsl:when>
        <xsl:when test="$n = 0">0</xsl:when>
        <xsl:otherwise>
      	    <xsl:call-template name="prod-range">
    	      <xsl:with-param name="start" select="$r + 1"/>
    	      <xsl:with-param name="end" select="$n"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<xsl:template name="math:C">
	<xsl:param name="n" select="1"/>
	<xsl:param name="r" select="1"/>
      <xsl:choose>
        <xsl:when test="$n &lt; 0 or $r &lt; 0">NaN</xsl:when>
        <xsl:when test="$n = 0">0</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="min" select="($r &lt;= $n - $r) * $r +  ($r > $n - $r) * $n - $r"/>
          <xsl:variable name="max" select="($r >= $n - $r) * $r +  ($r &lt; $n - $r) * $n - $r"/>
          <xsl:variable name="numerator">
            <xsl:call-template name="prod-range">
      	      <xsl:with-param name="start" select="$max + 1"/>
      	      <xsl:with-param name="end" select="$n"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="denominator">
            <xsl:call-template name="math:fact">
              <xsl:with-param name="number" select="$min"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$numerator div $denominator"/>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>


</xsl:stylesheet>

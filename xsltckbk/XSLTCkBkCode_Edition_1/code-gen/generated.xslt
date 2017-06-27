<?xml version="1.0" encoding="UTF-8"?>
<xso:stylesheet xmlns:xso="http://www.w3.org/1999/XSL/Transform" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xslx="http://www.ora.com/XSLTCookbook/ExtendedXSLT" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="foo">
    <xso:choose>
      <xso:when test="bar">
        <xsl:text>You often will find a bar in the neighborhood of foo!</xsl:text>
      </xso:when>
      <xso:when test="baz">
        <xsl:text>A baz is a sure sign of geekdom</xsl:text>
      </xso:when>
      <xso:otherwise>
        <xso:call-template name="loop-1">
          <xso:with-param name="i" select="0"/>
        </xso:call-template>
      </xso:otherwise>
    </xso:choose>
    <xso:call-template name="loop-2">
      <xso:with-param name="i" select="10"/>
    </xso:call-template>
    <xso:choose>
      <xso:when test="foo">
        <xsl:text>foo foo! Nobody says foo foo!</xsl:text>
      </xso:when>
      <xso:otherwise>
        <xsl:text>Well, okay then!</xsl:text>
      </xso:otherwise>
    </xso:choose>
  </xsl:template>
  <xso:template name="loop-1">
    <xso:param name="i"/>
    <xso:if test="$i &lt; 10">
      <xsl:text>Hmmm, nothing to say here but I'll say it 10 times.</xsl:text>
      <xso:call-template name="loop-1">
        <xso:with-param name="i" select="$i + 1"/>
      </xso:call-template>
    </xso:if>
  </xso:template>
  <xso:template name="loop-2">
    <xso:param name="i"/>
    <xso:if test="$i &gt;= 0">
      <xso:call-template name="loop-3">
        <xso:with-param name="i" select="$i"/>
        <xso:with-param name="j" select="10"/>
      </xso:call-template>
      <xso:call-template name="loop-2">
        <xso:with-param name="i" select="$i + -1"/>
      </xso:call-template>
    </xso:if>
  </xso:template>
  <xso:template name="loop-3">
    <xso:param name="i"/>
    <xso:param name="j"/>
    <xso:if test="$j &gt;= 0">
      <xsl:text>
</xsl:text>
      <xsl:value-of select="$i * $j"/>
      <xso:call-template name="loop-3">
        <xso:with-param name="i" select="$i"/>
        <xso:with-param name="j" select="$j + -1"/>
      </xso:call-template>
    </xso:if>
  </xso:template>
</xso:stylesheet>

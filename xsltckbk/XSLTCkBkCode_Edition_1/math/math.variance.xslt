<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://www.ora.com/XSLTCookbook/math">

<xsl:template name="math:variance">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="sum" select="'0'"/>
  <xsl:param name="sum-sq" select="'0'"/>
  <xsl:param name="count" select="'0'"/>
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:value-of select="($sum-sq - ($sum * $sum) div $count) div ($count - 1)"/>
    </xsl:when>
    <xsl:otherwise>
        <!-- call or apply template that will determine value of node unless the node is literally the value to be summed -->
      <xsl:variable name="value" select="$nodes[1]">
      <!--
        <xsl:call-template name="some-function-of-a-node">
          <xsl:with-param name="node" select="$nodes[1]"/>
        </xsl:call-template>
        -->
      </xsl:variable>
      <xsl:call-template name="math:variance">
        <xsl:with-param name="nodes" select="$nodes[position() != 1]"/>
        <xsl:with-param name="sum" select="$sum + $value"/>
        <xsl:with-param name="sum-sq" select="$sum-sq + ($value * $value)"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
  <xsl:call-template name="math:variance">
    <xsl:with-param name="nodes" select="*/*"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

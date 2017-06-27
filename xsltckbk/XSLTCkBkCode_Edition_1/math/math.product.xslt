<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://www.ora.com/XSLTCookbook/math">

<xsl:template name="math:product">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="result" select="1"/>
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:value-of select="$result"/>
    </xsl:when>
    <xsl:otherwise>
        <!-- call or apply template that will determine value of node unless the node is literally the value to be multiplied -->
      <xsl:variable name="value" select="$nodes[1]">
      <!--
        <xsl:call-template name="some-function-of-a-node">
          <xsl:with-param name="node" select="$nodes[1]"/>
        </xsl:call-template>
        -->
      </xsl:variable>
      <xsl:call-template name="math:product">
        <xsl:with-param name="nodes" select="$nodes[position() != 1]"/>
        <xsl:with-param name="result" select="$result * $value"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="math:product-batcher">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="result" select="1"/>
  <xsl:param name="batch-size" select="500"/>
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:value-of select="$result"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="batch-product">
        <xsl:call-template name="math:product">
          <xsl:with-param name="nodes" select="$nodes[position() &lt; $batch-size]"/>
          <xsl:with-param name="result" select="$result"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="math:product-batcher">
          <xsl:with-param name="nodes" select="$nodes[position() >= $batch-size]"/>
          <xsl:with-param name="result" select="$batch-product"/>
          <xsl:with-param name="batch-size" select="$batch-size"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="math:product-dvc">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="result" select="1"/>
  <xsl:param name="dvc-threshold" select="100"/>
  <xsl:choose>
    <xsl:when test="count($nodes) &lt;= $dvc-threshold">
        <xsl:call-template name="math:product">
          <xsl:with-param name="nodes" select="$nodes"/>
          <xsl:with-param name="result" select="$result"/>
        </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="half" select="floor(count($nodes) div 2)"/>
      <xsl:variable name="product1">
        <xsl:call-template name="math:product-dvc">
          <xsl:with-param name="nodes" select="$nodes[position() &lt;= $half]"/>
         <xsl:with-param name="result" select="$result"/>
          <xsl:with-param name="dvc-threshold" select="$dvc-threshold"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="math:product-dvc">
         <xsl:with-param name="nodes" select="$nodes[position() > $half]"/>
         <xsl:with-param name="result" select="$product1"/>
          <xsl:with-param name="dvc-threshold" select="$dvc-threshold"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="/">
  <xsl:call-template name="math:product-batcher">
    <xsl:with-param name="nodes" select="*/*"/>
    <xsl:with-param name="batch-size" select="3"/>
  </xsl:call-template>
  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="math:product-dvc">
    <xsl:with-param name="nodes" select="*/*"/>
    <xsl:with-param name="dvc-threshold" select="2"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

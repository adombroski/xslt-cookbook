<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://www.ora.com/XSLTCookbook/math">



<xsl:template name="math:median1">
  <xsl:param name="nodes" select="/.."/>
  <xsl:variable name="count" select="count($nodes)"/>
  <xsl:variable name="middle1" select="floor(($count + 1) div 2)"/>
  <xsl:variable name="middle2" select="ceiling(($count + 1) div 2)"/>

  <xsl:variable name="m1">
    <xsl:for-each select="$nodes">
      <xsl:sort data-type="number"/>
      <xsl:if test="position() = $middle1">
        <xsl:value-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="m2">
    <xsl:choose>
      <xsl:when test="$middle1 = $middle2">
        <xsl:value-of select="$m1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$nodes">
          <xsl:sort data-type="number"/>
          <xsl:if test="position() = $middle2">
            <xsl:value-of select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- The median -->
  <xsl:value-of select="($m1 + $m2) div 2"/>
 </xsl:template>

<xsl:template name="math:median2">
  <xsl:param name="nodes" select="/.."/>
  <xsl:variable name="count" select="count($nodes)"/>
  <xsl:variable name="middle" select="ceiling($count div 2)"/>
  <xsl:variable name="even" select="not($count mod 2)"/>


  <xsl:variable name="m1">
    <xsl:for-each select="$nodes">
      <xsl:sort data-type="number"/>
      <xsl:if test="position() = $middle">
        <xsl:value-of select=". + ($even * ./following-sibling::*[1])"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <!-- The median -->
  <xsl:value-of select="$m1 div ($even + 1)"/>
 </xsl:template>


<xsl:template match="/">

  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="math:median1">
    <xsl:with-param name="nodes" select="*/*"/>
  </xsl:call-template>
  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="math:median2">
    <xsl:with-param name="nodes" select="*/*"/>
  </xsl:call-template>
  
</xsl:template>

</xsl:stylesheet>

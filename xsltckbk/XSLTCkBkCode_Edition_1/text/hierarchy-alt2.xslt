<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="text.hierarchy.xslt"/>

<!--Ignore attributes -->
<xsl:template match="@*"/>
<xsl:template match="*" mode="begin-attributes"/>
<xsl:template match="*" mode="end-attributes"/>

<xsl:template match="*"	mode="name">
  <!--Display element loacl name-->
  <xsl:text>[</xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <!--Follow by a colon+space if a leaf -->
  <xsl:text>] </xsl:text>
</xsl:template>

<xsl:template match="*" mode="value">
  <xsl:if test="not(*)">
    <xsl:value-of select="."/>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="indent">
  <xsl:for-each select="ancestor::*">
    <xsl:choose>
      <xsl:when test="following-sibling::*"> | </xsl:when>
      <xsl:otherwise><xsl:text>   </xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="*"> o-</xsl:when>
    <xsl:when test="following-sibling::*"> +-</xsl:when>
    <xsl:otherwise> `-</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="line-break">
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>

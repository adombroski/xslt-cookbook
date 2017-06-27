<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="tree-control.xslt"/>

<xsl:param name="collapse"/>
<xsl:variable name="collapse-test" select="concat(' ',$collapse,' ')"/>

<xsl:template match="*"	mode="name">
    <xsl:if test="not(ancestor::*[contains($collapse-test,concat(' ',local-name(.),' '))])">
      <xsl:apply-imports/>
    </xsl:if>
</xsl:template>

<xsl:template match="*" mode="value">
    <xsl:if test="not(ancestor::*[contains($collapse-test,concat(' ',local-name(.),' '))])">
      <xsl:apply-imports/>
    </xsl:if>
</xsl:template>

<xsl:template match="*" mode="line-break">
    <xsl:if test="not(ancestor::*[contains($collapse-test,concat(' ',local-name(.),' '))])">
      <xsl:apply-imports/>
    </xsl:if>
</xsl:template>

<xsl:template match="*" mode="indent">
  <xsl:choose>
    <xsl:when test="self::*[contains($collapse-test,concat(' ',local-name(.),' '))]">
      <xsl:for-each select="ancestor::*">
        <xsl:text>   </xsl:text>
      </xsl:for-each>
      <xsl:text> x-</xsl:text>
    </xsl:when>
    <xsl:when test="ancestor::*[contains($collapse-test,concat(' ',local-name(.),' '))]"/>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

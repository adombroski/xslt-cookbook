<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ren="http://www.ora.com/namespaces/rename">

<xsl:import href="copy.xslt"/>

<!--Override in importing stylesheet -->
<xsl:variable name="lookup"  select="/.."/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">
  <xsl:choose>
    <xsl:when test="$lookup/ren:element[@from=name(current())]">
      <xsl:element name="{$lookup/ren:element[@from=name(current())]/@to}">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*">
  <xsl:choose>
    <xsl:when test="$lookup/ren:attribute[@from=name(current())]">
      <xsl:attribute name="{$lookup/ren:attribute[@from=name(current())]/@to}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

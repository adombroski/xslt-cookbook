<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="copy.xslt"/>
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="people">
  <people>
    <xsl:apply-templates select="class[1]" />
  </people>
</xsl:template>

<xsl:template match="class">
  <xsl:element name="{@name}">
    <xsl:apply-templates select="following-sibling::*[1][self::person]" />
  </xsl:element>
  <xsl:apply-templates select="following-sibling::class[1]" />
</xsl:template>

<xsl:template match="person">
  <xsl:copy-of select="." />
  <xsl:apply-templates select="following-sibling::*[1][self::person]" />
</xsl:template>
  
</xsl:stylesheet>

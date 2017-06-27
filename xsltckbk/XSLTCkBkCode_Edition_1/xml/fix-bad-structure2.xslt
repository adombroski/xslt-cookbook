<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="copy.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

<xsl:key name="people" match="person" 
         use="preceding-sibling::class[1]/@name" />

<xsl:template match="people">
  <people>
    <xsl:apply-templates select="class" />
  </people>
</xsl:template>

<xsl:template match="class">
  <xsl:element name="{@name}">
    <xsl:copy-of select="key('people', @name)" />
  </xsl:element>
</xsl:template>
  
</xsl:stylesheet>

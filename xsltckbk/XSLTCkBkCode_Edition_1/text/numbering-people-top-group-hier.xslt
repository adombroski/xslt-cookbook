<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="people/group">
    <xsl:text>Group </xsl:text>
    <xsl:number count="group"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="person">
    <xsl:number count="group | person" level="multiple" format="1.1.1 "/> 
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:font="java:com.ora.xsltckbk.util.FontMetrics">

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:variable name="fontMetrics" select="font:new('Serif', 12)"/>
  <xsl:value-of select="font:stringWidth($fontMetrics,'The rain in Spain falls mainly in the plain')"/>
</xsl:template>
  
</xsl:stylesheet>

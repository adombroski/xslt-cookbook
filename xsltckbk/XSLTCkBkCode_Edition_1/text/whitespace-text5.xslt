<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:template match="numbers">
Without xml:space="preserve":
<xsl:apply-templates mode="without-preserve"/>
With xml:space="preserve":
<xsl:apply-templates mode="with-preserve"/>
</xsl:template>	

<xsl:template match="number" mode="without-preserve">
  <xsl:value-of select="."/><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="number" mode="with-preserve" xml:space="preserve">
  <xsl:value-of select="."/><xsl:text> </xsl:text>
</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text"/>
<xsl:strip-space elements="*"/>

<xsl:template match="numbers">
Without empty text element:
<xsl:apply-templates mode="without"/>
With empty text element:
<xsl:apply-templates mode="with"/>
</xsl:template>	

<xsl:template match="number" mode="without">
  <xsl:value-of select="."/>,
</xsl:template>

<xsl:template match="number" mode="with">
  <xsl:value-of select="."/>,<xsl:text/>
</xsl:template>
	
</xsl:stylesheet>

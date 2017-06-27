<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="apply">
		<xsl:value-of select="local-name(*[1])"/>
		<xsl:text>(</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>)</xsl:text>
		<xsl:if test="following-sibling::*">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="ci|cn">
		<xsl:value-of select="."/>
		<xsl:if test="following-sibling::*">,</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>

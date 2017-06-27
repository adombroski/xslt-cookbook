<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="salesperson">
			<xsl:apply-templates/>
	</xsl:template>

	
	<xsl:template match="product">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select=".." mode="insertParent"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*" mode="insertParent">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

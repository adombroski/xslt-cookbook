<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="people/person"/>
	</xsl:template>
	
	<xsl:template match="person[@name='John Smith']">
		<xsl:value-of select="@age"/>
	</xsl:template>
	
	<xsl:template match="person"/>
	
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" />

	<xsl:strip-space elements="*"/>
	
<xsl:template match="/">
	<xsl:text>&#xd;&#xa;Kay Order&#xd;&#xa;</xsl:text>
	<xsl:for-each select="list/*">
		<xsl:sort select="(position()-1)  mod (ceiling(last() div 3))"/>
		<xsl:value-of select="."/><xsl:text>&#xd;&#xa;	</xsl:text>
	</xsl:for-each>
	<xsl:text>&#xd;&#xa;Sal Order&#xd;&#xa;	</xsl:text>
	<xsl:for-each select="list/*">
		<xsl:sort select="(position() - 1) mod 3"/>
		<xsl:value-of select="."/><xsl:text>&#xd;&#xa;	</xsl:text>
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:for-each select="//employee">
		<xsl:sort select="count(ancestor::*)" order="ascending"/>
		<xsl:variable name="level" select="count(ancestor::*)"/>
		<xsl:choose>
			<xsl:when test="$level = 0">
				<xsl:value-of select="@name"/><xsl:text> is the head honco.&#xA;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@name"/><xsl:text> has </xsl:text><xsl:value-of select="$level"/><xsl:text> boss(es) to knock off.&#xA;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
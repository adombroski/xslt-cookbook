<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" />
<xsl:strip-space elements="*"/>

<xsl:template match="employee[employee]">
<xsl:value-of select="@name"/>
<xsl:text>&#xA;</xsl:text>
<xsl:call-template name="dup">
	<xsl:with-param name="input" select=" '-' "/>
	<xsl:with-param name="count" select="80"/>
</xsl:call-template>
<xsl:text>&#xA;</xsl:text>
<xsl:for-each select="employee[(position() - 1) mod 2 = 0]">
	<xsl:value-of select="@name"/>
	<xsl:call-template name="dup">
		<xsl:with-param name="input" select=" ' ' "/>
		<xsl:with-param name="count" select="40 - string-length(@name)"/>
	</xsl:call-template>
	<xsl:value-of select="following-sibling::*[1]/@name"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:for-each>
<xsl:text>&#xA;</xsl:text>
<xsl:apply-templates/>
</xsl:template>

<xsl:template name="dup">
<xsl:param name="input"/>
<xsl:param name="count" select="1"/>
<xsl:choose>
	<xsl:when test="not($count) or not($input)"/>
	<xsl:when test="$count = 1">
		<xsl:value-of select="$input"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:if test="$count mod 2">
			<xsl:value-of select="$input"/>
		</xsl:if>
		<xsl:call-template name="dup">
			<xsl:with-param name="input" 
				select="concat($input,$input)"/>
			<xsl:with-param name="count" 
				select="floor($count div 2)"/>
		</xsl:call-template>	
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>

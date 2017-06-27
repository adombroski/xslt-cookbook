<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:us="http://www.oreilly.com/TheXSLTCoobook/nampespaces/us">

	<xsl:strip-space elements="*"/>
	
	<xsl:output method="text" />

	<xsl:key name="state" match="us:state" use="@abbrev"/>
	
	<xsl:template match="person">
		<xsl:value-of select="@name"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="address">
		<xsl:variable name="state" select="@state"/>
		<xsl:value-of select="@line1"/>
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="@line2">
		<xsl:value-of select="@line2"/>
		<xsl:text>&#xa;</xsl:text>
		</xsl:if>
		<xsl:value-of select="@city"/>
		<xsl:text>, </xsl:text>
		<xsl:for-each select="document('states.xml')">
			<xsl:value-of select="key('state',$state)/@name"/>
		</xsl:for-each>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@zip"/><xsl:text>&#xa;&#xa;</xsl:text>
	</xsl:template>
	
	<xsl:template match="text()"/>
	
</xsl:stylesheet>

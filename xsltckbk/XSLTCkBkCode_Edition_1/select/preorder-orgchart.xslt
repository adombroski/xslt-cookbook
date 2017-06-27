<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/employee" priority="10">
		<xsl:value-of select="@name"/><xsl:text> is the head of the company. </xsl:text>
		<xsl:call-template name="HeShe"/><xsl:text> manages </xsl:text>
		<xsl:call-template name="manages"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="employee[employee]">
		<xsl:text>&#xa;&#xa;</xsl:text>
		<xsl:value-of select="@name"/><xsl:text> is a manager. </xsl:text>
		<xsl:call-template name="HeShe"/> <xsl:text> manages </xsl:text>
		<xsl:call-template name="manages"/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="employee">
		<xsl:if test="position()=1"><xsl:text>&#xa;</xsl:text></xsl:if>
		<xsl:value-of select="@name"/><xsl:text> has no worries. </xsl:text>
		<xsl:text>&#xa;</xsl:text>
	</xsl:template>

	<xsl:template name="HeShe">
		<xsl:choose>
			<xsl:when test="@sex = 'male' ">
				<xsl:text>He</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>She</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="manages">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="position() &lt; last() - 1 and last() > 2">
					<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:when test="position() = last() - 1  and last() > 1">
					<xsl:value-of select="@name"/><xsl:text> and </xsl:text>
				</xsl:when>
				<xsl:when test="position() = last()">
					<xsl:value-of select="@name"/><xsl:text>. </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@name"/>
				</xsl:otherwise>
			</xsl:choose> 
		</xsl:for-each>
	</xsl:template>

		
</xsl:stylesheet>

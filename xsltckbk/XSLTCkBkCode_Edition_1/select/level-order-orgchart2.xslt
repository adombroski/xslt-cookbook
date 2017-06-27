<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" version="1.0" encoding="UTF-8"/>

<xsl:strip-space elements="*"/>
	
<xsl:template match="/employee">
	<xsl:call-template name="level-order"/>
</xsl:template>

<xsl:template name="level-order">
<xsl:param name="max-depth" select="10"/>
<xsl:param name="current-depth" select="0"/>

<xsl:choose>
	<xsl:when test="$current-depth &lt;= $max-depth">
		<xsl:variable name="text">
			<xsl:call-template name="level-order-aux">
				<xsl:with-param name="level" select="$current-depth"/>
				<xsl:with-param name="actual-level" select="$current-depth"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="normalize-space($text)">
			<xsl:value-of select="$text"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:call-template name="level-order">
				<xsl:with-param name="current-depth" select="$current-depth + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:when>
</xsl:choose>

</xsl:template>

<xsl:template name="level-order-aux">
	<xsl:param name="level" select="0"/>
	<xsl:param name="actual-level" select="0"/>
	<xsl:choose>
		<xsl:when test="$level = 0">
		<xsl:choose>
			<xsl:when test="$actual-level = 0">
				<xsl:value-of select="@name"/><xsl:text> is the head honco.&#xA;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@name"/><xsl:text> has </xsl:text><xsl:value-of select="$actual-level"/><xsl:text> boss(es) to knock off.&#xA;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="employee">
				<xsl:call-template name="level-order-aux">
					<xsl:with-param name="level" select="$level - 1"/>
					<xsl:with-param name="actual-level" select="$actual-level"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>


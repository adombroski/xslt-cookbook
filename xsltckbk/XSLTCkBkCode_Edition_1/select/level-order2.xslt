<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>

<xsl:template match="/*">
	<xsl:call-template name="level-order"/>
</xsl:template>

<xsl:template name="level-order">
<xsl:param name="max-level" select="10"/>
<xsl:param name="current-depth" select="1"/>

<xsl:choose>
	<xsl:when test="$current-depth &lt;= $max-level">
		<xsl:call-template name="level-order-aux">
			<xsl:with-param name="level" select="$current-depth"/>
			<xsl:with-param name="actual-level" select="$current-depth"/>
		</xsl:call-template>
		<xsl:call-template name="level-order">
			<xsl:with-param name="current-depth" select="$current-depth + 1"/>
		</xsl:call-template>
	</xsl:when>
</xsl:choose>

</xsl:template>

<xsl:template name="level-order-aux">
	<xsl:param name="level" select="1"/>
	<xsl:param name="actual-level" select="1"/>
	<xsl:choose>
		<xsl:when test="$level = 1">
			<xsl:value-of select="concat(@name,'-',$actual-level)"/><xsl:text>&#xa;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="*">
				<xsl:call-template name="level-order-aux">
					<xsl:with-param name="level" select="$level - 1"/>
					<xsl:with-param name="actual-level" select="$actual-level"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>


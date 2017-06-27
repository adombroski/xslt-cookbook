<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://exslt.org/math" 
	extension-element-prefixes="math">


<xsl:template name="math:power">
	<xsl:param name="base"/>
	<xsl:param name="power"/>
	<xsl:choose>
		<xsl:when test="$power = 0">
			<xsl:value-of select="1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="temp">
				<xsl:call-template name="math:power">
					<xsl:with-param name="base" select="$base"/>
					<xsl:with-param name="power" select="$power - 1"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$base * $temp"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

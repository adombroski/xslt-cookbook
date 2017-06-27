<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math"
 xmlns:test="http://www.ora.com/XSLTCookbook/test">

<xsl:import href="math.max.xslt"/>

<xsl:template name="math:highest">
	<xsl:param name="nodes" select="/.."/>

	<xsl:variable name="max">
		<xsl:call-template name="math:max">
			<xsl:with-param name="nodes" select="$nodes"/>
		</xsl:call-template>
	</xsl:variable> 
	<xsl:choose>
		<xsl:when test="number($max) = $max">
			<xsl:copy-of select="$nodes[. = $max]"/>
		</xsl:when>
	</xsl:choose>
	<xsl:otherwise/>
</xsl:template>

</xsl:stylesheet>

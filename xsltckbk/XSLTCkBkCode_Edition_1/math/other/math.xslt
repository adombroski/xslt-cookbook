<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://exslt.org/math" 
	extension-element-prefixes="math" id="math:math">

<xsl:include href="math.abs.xslt"/>
<xsl:include href="math.constant.xslt"/>
<xsl:include href="math.exp.xslt"/>
<xsl:include href="math.highest.xslt"/>
<xsl:include href="math.log.xslt"/>
<xsl:include href="math.lowest.xslt"/>
<xsl:include href="math.max.xslt"/>
<xsl:include href="math.min.xslt"/>
<xsl:include href="math.power.xslt"/>
<xsl:include href="math.sqrt.xslt"/>

<!--TEST CODE -->
<xsl:template match="xsl:stylesheet[@id='math:math'] | xsl:include[@href='math.xslt']">

<xsl:message>
TESTING math
</xsl:message>

	<xsl:for-each select="document('')/*/xsl:include">
		<xsl:apply-templates select="."/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="xsl:include" priority="-10">
	<xsl:message>
	WARNING: <xsl:value-of select="@href"/> has no test code.
	</xsl:message>
</xsl:template>

</xsl:stylesheet>

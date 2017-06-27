<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://exslt.org/math" 
	extension-element-prefixes="math" id="math:math">

<xsl:include href="math.max.test.xslt"/>
<xsl:include href="math.min.test.xslt"/>

<!--TEST CODE -->
<xsl:template match="/ | xsl:include[@href='math.test.xslt']">

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

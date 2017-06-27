<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>

<xsl:template match="/">
	<xsl:for-each select="//node">
		<xsl:sort select="count(ancestor::node)" order="ascending"/>
		<xsl:value-of select="concat(@name,'&#x0a;')"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>


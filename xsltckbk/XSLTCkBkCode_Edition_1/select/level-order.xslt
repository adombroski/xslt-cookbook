<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>

<xsl:template match="/">
	<xsl:for-each select="//*">
		<xsl:sort select="count(ancestor::*)" order="ascending"/>
		<xsl:value-of select="concat(@name,count(ancestor::*),'&#x0a;')"/>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>


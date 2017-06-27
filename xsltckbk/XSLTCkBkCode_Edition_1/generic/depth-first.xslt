<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="node">
	<xsl:param name="depth" select=" '0' "/>
	<xsl:apply-templates>
		<xsl:with-param name="depth" select="$depth + 1"/>
	</xsl:apply-templates>
	<xsl:value-of select="concat(substring('          ',1,$depth),@name,'&#x0a;')"/>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>


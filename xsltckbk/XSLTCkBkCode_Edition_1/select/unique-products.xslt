<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<products>
		<xsl:for-each select="//product[not(@sku=preceding::product/@sku)]">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</products>
</xsl:template>	

</xsl:stylesheet>

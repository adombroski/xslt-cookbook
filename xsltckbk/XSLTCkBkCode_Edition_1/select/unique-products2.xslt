<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	
	<xsl:variable name="products">
		<xsl:for-each select="//product">
			<xsl:sort select="@sku"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	
	<products>
		<xsl:for-each select="$products/product">
			<xsl:variable name="pos" select="position()"/>
			<xsl:if test="$pos = 1 or @sku != $products/product[$pos - 1]/@sku">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</products>
	
</xsl:template>	

</xsl:stylesheet>

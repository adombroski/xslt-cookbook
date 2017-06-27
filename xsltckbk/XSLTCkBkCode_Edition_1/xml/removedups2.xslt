<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xt="http://www.jclark.com/xt">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
		
	<xsl:template match="root">
		
		<root>
			<xsl:for-each select="leaf[not(@value=preceding-sibling::leaf[1]/@value)]">
					<xsl:sort select="@value"/>
					<xsl:copy-of select="."/>
			</xsl:for-each>
		</root>
	</xsl:template>
	
</xsl:stylesheet>

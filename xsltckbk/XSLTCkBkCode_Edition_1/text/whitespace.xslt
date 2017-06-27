<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:strip-space elements="name email author review"/>
	
	<xsl:template match="comment">
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
</xsl:stylesheet>

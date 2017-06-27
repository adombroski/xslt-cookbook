<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="person">
	  <xsl:value-of select="@name"/>,<xsl:text/>
	  <xsl:value-of select="@age"/>,<xsl:text/>
	  <xsl:value-of select="@sex"/>,<xsl:text/>
	  <xsl:value-of select="@smoker"/>
	  <xsl:text>&#xa;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:vxd="urn:schemas-microsoft-com:office:visio">
	<xsl:output method="text" />

<xsl:strip-space elements="*"/>

<xsl:template match="/">
	<xsl:apply-templates select="vxd:VisioDocument/vxd:Pages/vxd:Page/vxd:Shapes/vxd:Shape"/>
</xsl:template>


<xsl:template match="vxd:Shape">
	<xsl:value-of select="@ID"/>-<xsl:value-of select="@NameU"/><xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template match="text()"/>
	
</xsl:stylesheet>

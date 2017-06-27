<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vdx="urn:schemas-microsoft-com:office:visio">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="docName" select="/VisioDocument/DocumentProperties/Title"/>

<xsl:template match="vdx:Page">
	<xsl:variable name="pageName" select="concat($docName,@NameU)"/>
<!--	<xsl:document href="{$pageName}"> -->
		<xsl:variable name="pageWidthUnit" select="vdx:PageSheet/vdx:PageProps/vdx:PageWidth/@Unit"/>
		<xsl:variable name="pageWidth" select="concat(vdx:PageSheet/vdx:PageProps/vdx:PageWidth,$pageWidthUnit)"/>
		<xsl:variable name="pageHeightUnit" select="vdx:PageSheet/vdx:PageProps/vdx:PageHeight/@Unit"/>
		<xsl:variable name="pageHeight" select="concat(vdx:PageSheet/vdx:PageProps/vdx:PageHeight,$pageHeightUnit)"/>
		<svg width="{$pageWidth}" height="{$pageHeight}">
			<xsl:apply-templates/>
		</svg>
<!--	</xsl:document> -->
</xsl:template>

<xsl:template match="vdx:Shape">
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>

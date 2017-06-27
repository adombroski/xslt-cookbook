<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:cgen="http://www.siac.com/namespaces/repository/C++gen" xmlns:elt="http://www.siac.com/namespaces/repository/elementTemplate" xmlns:rep="http://www.siac.com/namespaces/repository" xmlns="http://www.siac.com/namespaces/repository">

	<xsl:output method="text" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="*/rep:Constants/rep:Enumerator[@name='DEPTH_BID']"/>
	</xsl:template>
	
	<xsl:template match="rep:Enumerator">
		<xsl:value-of select="@value"/>
	</xsl:template>
	
</xsl:stylesheet>

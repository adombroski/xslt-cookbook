<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../query/copy.xslt"/>

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	
	<xsl:template match="@*">
	  <xsl:element name="{local-name()}">
	    <xsl:value-of select="."/>
	  </xsl:element> 
	</xsl:template>
	
</xsl:stylesheet>

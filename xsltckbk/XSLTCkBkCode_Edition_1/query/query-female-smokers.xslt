<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="copy.xslt"/>

      <xsl:strip-space elements="people"/>
      
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="person[@sex = 'f' and @smoker='yes']">
	  <xsl:apply-imports/>
	</xsl:template>

	<xsl:template match="person"/>
	
</xsl:stylesheet>

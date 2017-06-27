<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="copy.xslt"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="friends | coworkers">
    <xsl:copy>
      <xsl:variable name="file" select="concat(local-name(),'.xml')"/>
      <xsl:copy-of select="document($file)/*/*"/>
    </xsl:copy>
  </xsl:template>
	
</xsl:stylesheet>

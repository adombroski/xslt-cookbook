<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="copy.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="doc2file"/>
  
  <xsl:variable name="doc2" select="document($doc2file)"/>
	
  <xsl:template match="person">
    <xsl:copy>
      <xsl:for-each select="@*">
        <xsl:element name="{local-name()}">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
      <xsl:variable name="matching-person" select="$doc2/*/person[@name=concat(current()/@firstname,' ', current()/@lastname)]"/>
      <xsl:element name="smoker">
        <xsl:value-of select="$matching-person/@sex"/>
      </xsl:element>
      <xsl:element name="sex">
        <xsl:value-of select="$matching-person/@smoker"/>
      </xsl:element>
    </xsl:copy>
</xsl:template>
	
</xsl:stylesheet>

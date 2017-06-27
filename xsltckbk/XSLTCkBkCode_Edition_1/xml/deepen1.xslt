<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
  <xsl:import href="copy.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="people">
    <union>
      <xsl:for-each select="person[@class='union']">
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </union>
    <salaried>
      <xsl:for-each select="person[@class='salaried']">
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </salaried>
  </xsl:template>  	

</xsl:stylesheet>

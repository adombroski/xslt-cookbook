<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="unique-cities" select="//@city[not(. = ../preceding::*/@city)]"/>

<xsl:variable name="city-ordering">
  <xsl:for-each select="$unique-cities">
    <xsl:sort select="."/>
    <city name="{.}" order="{position()}"/>
  </xsl:for-each>
</xsl:variable> 	

<xsl:template match="/">
  <result>
    <xsl:for-each select="database/suppliers/*">
      <xsl:variable name="s" select="."/>
      <xsl:for-each select="/database/parts/*">
        <xsl:variable name="p" select="."/>
        <xsl:if test="$city-ordering/*[@name = $s/@city]/@order > $city-ordering/*[@name = $p/@city]/@order">
        <supplier-city-follows-part-city>
          <xsl:copy-of select="$s"/>
          <xsl:copy-of select="$p"/>
        </supplier-city-follows-part-city>
      </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </result>
</xsl:template>
  
</xsl:stylesheet>

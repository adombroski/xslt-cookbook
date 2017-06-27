<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
  <xsl:import href="copy.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:variable name="classes" select="/*/*/@class[not(. = ../preceding-sibling::*/@class)]"/>
  
  <xsl:template match="/*">
    <xsl:for-each select="$classes">
      <xsl:variable name="class-name" select="."/>
      <xsl:element name="{$class-name}">
        <xsl:for-each select="/*/*[@class=$class-name]">
          <xsl:copy>
            <xsl:apply-templates/>
          </xsl:copy>
        </xsl:for-each>
      </xsl:element>
   </xsl:for-each>
  </xsl:template>  	

</xsl:stylesheet>

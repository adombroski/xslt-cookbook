<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
 version="1.1" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="text"/>
 <xsl:variable name="PI" select="4.0 * Math:atan(1.0)" 
               xmlns:Math="java:java.lang.Math"/>
               

  <xsl:template match="/">
    <xsl:value-of select="$PI"/>
  </xsl:template>
  
</xsl:stylesheet>
	

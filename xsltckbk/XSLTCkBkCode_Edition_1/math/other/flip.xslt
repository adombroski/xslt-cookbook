<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:test="http://www.ora.com/XSLTCookbook/test">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/">
 <test:test xmlns:test="http://www.ora.com/XSLTCookbook/test">
  <xsl:for-each select="test:test/test:data">
    <xsl:sort data-type="number" order="descending" select="."/>
    <xsl:copy-of select="."/>
  </xsl:for-each>
 </test:test>

</xsl:template>
	
	
</xsl:stylesheet>

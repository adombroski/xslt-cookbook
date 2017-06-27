<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  exclude-result-prefixes="svgu">

<xsl:include href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<xsl:template match="/">

<svg width="500" height="500">
  <xsl:call-template name="svgu:pie-slice">
    <xsl:with-param name="theta" select="80"/>
    <xsl:with-param name="delta" select="12"/>
  </xsl:call-template>
</svg>

</xsl:template>

</xsl:stylesheet>

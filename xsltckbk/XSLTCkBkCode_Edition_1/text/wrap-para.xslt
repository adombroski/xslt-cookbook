<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">

<xsl:include href="text.wrap.xslt"/>

<xsl:strip-space elements="*"/>
<xsl:output method="text"/>

<xsl:template match="p">
  <xsl:apply-templates select="." mode="text:wrap">
    <xsl:with-param name="width" select="40"/>
      <xsl:with-param name="align" select=" 'center' "/>
    <xsl:with-param name="align-width" select="60"/>
  </xsl:apply-templates>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>

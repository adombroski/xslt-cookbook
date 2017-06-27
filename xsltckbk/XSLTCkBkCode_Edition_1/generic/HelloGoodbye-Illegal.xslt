<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- THIS IS NOT LEGAL XSLT -->

<xsl:output method="text"/>

<xsl:template match="/">
  <!-- We can call templates by name -->
  <xsl:call-template name="sayIt">
    <xsl:with-param name="aTempl" select=" 'sayHello' "/>
  </xsl:call-template>
  
  <xsl:call-template name="sayIt">
    <xsl:with-param name="aTempl" select=" 'sayGoodby' "/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="sayIt">
  <xsl:param name="aTemple"/>
  <!--But not when the name is indirectly specified with a variable -->
  <xsl:call-template name="$aTemple"/>
</xsl:template>

<xsl:template name="sayHello">
  <xsl:text>Hello!&#xa;</xsl:text>
</xsl:template>

<xsl:template name="sayGoodby">
    <xsl:text>Goodby!&#xa;</xsl:text>
</xsl:template>


</xsl:stylesheet>

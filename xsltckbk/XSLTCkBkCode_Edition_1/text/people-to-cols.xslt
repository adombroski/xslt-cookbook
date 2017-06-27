<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">


<xsl:include href="text.justify.xslt"/>

<xsl:output method="text" />

<xsl:strip-space elements="*"/>

<xsl:template match="people">
Name                 Age    Sex   Smoker
--------------------|------|-----|---------
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="person">

  <xsl:call-template name="text:justify">
    <xsl:with-param name="value" select="@name"/>
    <xsl:with-param name="width" select="20"/>
  </xsl:call-template>
 <xsl:text>|</xsl:text>
  <xsl:call-template name="text:justify">
    <xsl:with-param name="value" select="@age"/>
    <xsl:with-param name="width" select="6"/>
    <xsl:with-param name="align" select=" 'right' "/>
  </xsl:call-template>
 <xsl:text>|</xsl:text>
  <xsl:call-template name="text:justify">
    <xsl:with-param name="value" select="@sex"/>
    <xsl:with-param name="width" select="6"/>
    <xsl:with-param name="align" select=" 'center' "/>
  </xsl:call-template>
 <xsl:text>|</xsl:text>
  <xsl:call-template name="text:justify">
    <xsl:with-param name="value" select="@smoker"/>
    <xsl:with-param name="width" select="9"/>
    <xsl:with-param name="align" select=" 'center' "/>
  </xsl:call-template>
  <xsl:text>
</xsl:text>  
</xsl:template>

</xsl:stylesheet>

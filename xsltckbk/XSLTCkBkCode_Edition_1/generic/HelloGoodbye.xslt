<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:f="http://www.ora.com/XSLTCookbook/namespaces/func">

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:call-template name="sayIt">
    <xsl:with-param name="aTempl" select=" 'sayHello' "/>
  </xsl:call-template>
  <xsl:call-template name="sayIt">
    <xsl:with-param name="aTempl" select=" 'sayGoodby' "/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="sayIt">
  <xsl:param name="aTempl"/>
  <!--Applay templates selecting a tag element that is unique to the template we want to invoke -->
  <xsl:apply-templates select="document('')/*/f:func[@name=$aTempl]"/>
</xsl:template>

<!-- A tagged template consists of a tag element and a template that matches that tagged element -->
<f:func name="sayHello"/>
<xsl:template match="f:func[@name='sayHello']">
  <xsl:text>Hello!&#xa;</xsl:text>
</xsl:template>

<!-- Another tagged template -->
<f:func name="sayGoodby"/>
<xsl:template match="f:func[@name='sayGoodby']">
  <xsl:text>Goodby!&#xa;</xsl:text>
</xsl:template>


</xsl:stylesheet>

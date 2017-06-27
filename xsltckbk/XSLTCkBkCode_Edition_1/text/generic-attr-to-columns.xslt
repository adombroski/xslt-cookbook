<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings"
 xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">

<xsl:include href="text.justify.xslt"/>

<xsl:param name="gutter" select=" ' ' "/>

<xsl:output method="text"/>

<xsl:strip-space elements="*"/>

<xsl:variable name="columns" select="/.."/>

<xsl:template match="/">
  <xsl:for-each select="$columns">
    <xsl:call-template name="text:justify" >
      <xsl:with-param name="value" select="@name"/>
      <xsl:with-param name="width" select="@width"/>
      <xsl:with-param name="align" select=" 'left' "/>
    </xsl:call-template>
    <xsl:value-of select="$gutter"/>
  </xsl:for-each>
  <xsl:text>&#xa;</xsl:text>
  <xsl:for-each select="$columns">
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '-' "/>
      <xsl:with-param name="count" select="@width"/>
    </xsl:call-template>
    <xsl:call-template name="str:dup">
      <xsl:with-param name="input" select=" '-' "/>
      <xsl:with-param name="count" select="string-length($gutter)"/>
    </xsl:call-template>
  </xsl:for-each>
  <xsl:text>&#xa;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="/*/*">
  <xsl:variable name="row" select="."/>

  <xsl:for-each select="$columns">
    <xsl:variable name="value">
      <xsl:apply-templates select="$row/@*[local-name(.)=current()/@attr]" mode="text:map-col-value"/>
    </xsl:variable>
    <xsl:call-template name="text:justify" >
      <xsl:with-param name="value" select="$value"/>
      <xsl:with-param name="width" select="@width"/>
      <xsl:with-param name="align" select="@align"/>
    </xsl:call-template>
    <xsl:value-of select="$gutter"/>
  </xsl:for-each>

  <xsl:text>&#xa;</xsl:text>
 
</xsl:template>

<xsl:template match="@*" mode="text:map-col-value">
  <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
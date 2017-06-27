<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text" 
  xmlns:exsl="http://exslt.org/common">


<xsl:output method="text" />

<xsl:include href="../text/text.matrix.xslt"/>

<xsl:variable name="elements">
  <xsl:for-each select="//*[name(.) = name(preceding::*)]">
    <xsl:sort select="name()"/>
    <elem><xsl:value-of select="name()"/></elem>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="element-nodes"  select="exsl:node-set($elements)"/>

<xsl:variable name="attributes">
  <xsl:for-each select="//@*">
    <xsl:sort select="name()"/>
    <xsl:value-of select="name()"/>
  </xsl:for-each>
</xsl:variable>

<xsl:variable name="attribute-nodes"  select="exsl:node-set($attributes)"/>

<xsl:template match="/">
  <xsl:text>Elements&#xa;</xsl:text>

  <xsl:call-template name="text:col-major">
    <xsl:with-param name="nodes" select="$element-nodes/*"/>
    <xsl:with-param name="num-cols" select="2"/>
    <xsl:with-param name="width" select="35"/>
  </xsl:call-template>

  <xsl:text>&#xa;Attributes&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>

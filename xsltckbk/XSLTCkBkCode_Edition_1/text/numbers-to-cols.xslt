<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">

<xsl:output method="text" />

<xsl:include href="text.matrix.xslt"/>

<xsl:template match="numbers">
Five columns of numbers in row major order:
<xsl:text/>
  <xsl:call-template name="text:row-major">
    <xsl:with-param name="nodes" select="number"/>
    <xsl:with-param name="align" select=" 'right' "/>
    <xsl:with-param name="num-cols" select="5"/>
    <xsl:with-param name="gutter" select=" ' | ' "/>
  </xsl:call-template>

Five columns of numbers in column major order:
<xsl:text/>
  <xsl:call-template name="text:col-major">
    <xsl:with-param name="nodes" select="number"/>
    <xsl:with-param name="align" select=" 'right' "/>
    <xsl:with-param name="num-cols" select="5"/>
    <xsl:with-param name="gutter" select=" ' | ' "/>
  </xsl:call-template>
  
</xsl:template>

  
</xsl:stylesheet>

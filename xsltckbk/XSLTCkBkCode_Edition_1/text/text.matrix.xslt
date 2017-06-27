<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text" extension-element-prefixes="text">

  <xsl:output method="text"/>
  
  <xsl:include href="text.justify.xslt" />
  
  <xsl:template name="text:row-major">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="num-cols" select="2"/>
    <xsl:param name="width" select="10"/>
    <xsl:param name="align" select=" 'left' "/>
    <xsl:param name="gutter" select=" ' ' "/>

    <xsl:if test="$nodes">
        <xsl:call-template name="text:row">
          <xsl:with-param name="nodes" select="$nodes[position() &lt;= $num-cols]"/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="align" select="$align"/>
          <xsl:with-param name="gutter" select="$gutter"/>
        </xsl:call-template>
        <!-- process remaining rows -->
        <xsl:call-template name="text:row-major">
          <xsl:with-param name="nodes" select="$nodes[position() > $num-cols]"/> 
          <xsl:with-param name="num-cols" select="$num-cols"/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="align" select="$align"/>
          <xsl:with-param name="gutter" select="$gutter"/>
        </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="text:col-major">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="num-cols" select="2"/>
    <xsl:param name="width" select="10"/>
    <xsl:param name="align" select=" 'left' "/>
    <xsl:param name="gutter" select=" ' ' "/>


    <xsl:if test="$nodes">
        <xsl:call-template name="text:row">
          <xsl:with-param name="nodes" select="$nodes[(position() - 1) mod ceiling(last() div $num-cols) = 0]"/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="align" select="$align"/>
          <xsl:with-param name="gutter" select="$gutter"/>
        </xsl:call-template>
        
        <!-- process remaining rows -->
        <xsl:call-template name="text:col-major">
          <xsl:with-param name="nodes" select="$nodes[(position() - 1) mod ceiling(last() div $num-cols) != 0]"/> 
          <xsl:with-param name="num-cols" select="$num-cols"/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="align" select="$align"/>
          <xsl:with-param name="gutter" select="$gutter"/>
        </xsl:call-template>
    </xsl:if>
    
  </xsl:template>

<xsl:template name="text:row">
    <xsl:param name="nodes" select="/.."/>
    <xsl:param name="width" select="10"/>
    <xsl:param name="align" select=" 'left' "/>
    <xsl:param name="gutter" select=" ' ' "/>
  
  <xsl:for-each select="$nodes">
    <xsl:call-template name="text:justify">
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="width" select="$width"/>
      <xsl:with-param name="align" select="$align"/>
    </xsl:call-template>
    <xsl:value-of select="$gutter"/>
  </xsl:for-each>
  
  <xsl:text>&#xa;</xsl:text>
  
</xsl:template>

</xsl:stylesheet>


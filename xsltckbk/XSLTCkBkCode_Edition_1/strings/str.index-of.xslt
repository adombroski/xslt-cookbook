<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings" >

  <xsl:output method="text"/>
   
  <xsl:template match="/">
    <xsl:call-template name="str:index-of">
      <xsl:with-param name="input" select=" '123456789' "/>
      <xsl:with-param name="substr" select=" '78' "/>
    </xsl:call-template>
    <xsl:text>&#xa;</xsl:text>
    <xsl:call-template name="str:index-of">
      <xsl:with-param name="input" select=" '123456789' "/>
      <xsl:with-param name="substr" select=" '90' "/>
    </xsl:call-template>
  </xsl:template>
  
   <xsl:template name="str:index-of">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <xsl:choose>
      <xsl:when test="contains($input, $substr)">
        <xsl:value-of select="string-length(substring-before($input, $substr))+1"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

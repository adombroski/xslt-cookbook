<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt" exclude-result-prefixes="generic">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>

<!-- Extend the available generic functions -->
<xsl:variable name="generic:generics" select="$generic:public-generics | document('')/*/generic:*"/>

<!--A generic function for extracting sentences -->
<generic:func name="extract-sentences" param1="1"/>
<xsl:template match="generic:func[@name='extract-sentences']" name="generic:extract-sentences">
  <xsl:param name="x"/>
  <xsl:param name="param1" select="@param1"/> 
   <xsl:choose>
    <xsl:when test="$param1 >= 1 and contains($x,'.')">
      <xsl:value-of select="substring-before($x,'.')"/>
      <xsl:text>.</xsl:text>
      <xsl:call-template name="generic:extract-sentences">
        <xsl:with-param name="x" select="substring-after($x,'.')"/>
        <xsl:with-param name="param1" select="$param1 - 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">

<summary>
    <xsl:call-template name="generic:map">
      <xsl:with-param name="nodes" select="//para"/>
      <xsl:with-param name="func" select=" 'extract-sentences' "/>
      <xsl:with-param name="func-param1" select="3"/>
    </xsl:call-template>
</summary>
  
</xsl:template>

<xsl:template match="/ | node() | @*" mode="generic:map">
  <para>
    <xsl:copy-of select="."/>
  </para>
</xsl:template>


</xsl:stylesheet>

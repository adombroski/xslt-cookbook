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

<!--Add a generic element function for computing reciprocal -->
<generic:func name="length"/>
<xsl:template match="generic:func[@name='length']">
  <xsl:param name="x"/>
  <xsl:value-of select="string-length($x)"/>
</xsl:template>

<!--Test map functionality -->
<xsl:template match="/">

<para-lengths>
    <xsl:call-template name="generic:map">
      <xsl:with-param name="nodes" select="//para"/>
      <xsl:with-param name="func" select=" 'length' "/>
    </xsl:call-template>
</para-lengths>
  
</xsl:template>

<xsl:template match="/ | node() | @*" mode="generic:map">
  <length>
    <xsl:copy-of select="."/>
  </length>
</xsl:template>


</xsl:stylesheet>

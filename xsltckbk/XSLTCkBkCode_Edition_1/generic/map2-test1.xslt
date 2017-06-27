<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt" exclude-result-prefixes="generic">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>


<!--Test map2 functionality -->
<xsl:template match="numbers">

<results>

<sum>
  <xsl:call-template name="generic:map2">
    <xsl:with-param name="nodes1" select="number[position() mod 2 = 0]"/>
    <xsl:with-param name="nodes2" select="number[position() mod 2 = 1]"/>
    <xsl:with-param name="func" select=" 'sum' "/>
  </xsl:call-template>
</sum>
</results> 
  
</xsl:template>

</xsl:stylesheet>

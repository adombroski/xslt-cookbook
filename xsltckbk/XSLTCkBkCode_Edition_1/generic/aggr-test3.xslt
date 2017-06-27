<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate"
  extension-element-prefixes="generic">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>


<xsl:template match="numbers">

<results>
  <sumSq>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="func" select=" 'square' "/>
    </xsl:call-template>
  </sumSq>
</results> 
  
</xsl:template>

</xsl:stylesheet>

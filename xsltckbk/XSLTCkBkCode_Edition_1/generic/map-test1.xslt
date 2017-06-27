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
<generic:func name="reciprocal"/>
<xsl:template match="generic:func[@name='reciprocal']">
	<xsl:param name="x"/>
	<xsl:value-of select="1 div $x"/>
</xsl:template>

<!--Test map functionality -->
<xsl:template match="numbers">

<results>

<incr>
  <xsl:call-template name="generic:map">
    <xsl:with-param name="nodes" select="number"/>
    <xsl:with-param name="func" select=" 'incr' "/>
  </xsl:call-template>
</incr>
<incr10>
    <xsl:call-template name="generic:map">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="func" select=" 'incr' "/>
      <xsl:with-param name="func-param1" select="10"/>
   </xsl:call-template>
</incr10>
<recip>
      <xsl:call-template name="generic:map">
        <xsl:with-param name="nodes" select="number"/>
        <xsl:with-param name="func" select=" 'reciprocal' "/>
     </xsl:call-template>
</recip>
</results> 
  
</xsl:template>

</xsl:stylesheet>

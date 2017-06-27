<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY % standard SYSTEM "../strings/standard.ent">
	%standard;
]>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate"
  extension-element-prefixes="generic aggr">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>

<!-- Extend the available generic functions -->
<xsl:variable name="aggr:generics" select="$aggr:public-generics | document('')/*/generic:*"/>

<!--Add a generic element function for converting first character of $x to uppercase -->
<generic:func name="upperFirst"/>
<xsl:template match="generic:func[@name='upperFirst']">
	<xsl:param name="x"/>
	<xsl:variable name="upper" select="translate(substring($x,1,1),&LOWER_TO_UPPER;)"/>
	<xsl:value-of select="concat($upper, substring($x,2))"/>
</xsl:template>

<!--Add generic agregator that concatenates -->
<generic:aggr-func name="concat" identity=""/>
<xsl:template match="generic:aggr-func[@name='concat']">
	<xsl:param name="x"/>
	<xsl:param name="accum"/>
	<xsl:value-of select="concat($accum,$x)"/>
</xsl:template>

<!--Test aggregation functionality -->
<xsl:template match="strings">

<results>

  <camelCase>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="string"/>
      <xsl:with-param name="aggr-func" select=" 'concat' "/>
      <xsl:with-param name="func" select=" 'upperFirst' "/>
    </xsl:call-template>
 </camelCase>

</results> 
  
</xsl:template>

</xsl:stylesheet>

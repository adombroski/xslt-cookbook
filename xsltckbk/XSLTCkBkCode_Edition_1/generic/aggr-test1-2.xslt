<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate"
  xmlns:my="sal"
  extension-element-prefixes="generic aggr">

<xsl:import href="aggregation2.xslt"/>

<xsl:output method="xml" indent="yes"/>

<xsl:key name="generic:aggr-funcs" match="my:aggr-func" use="@name"/>  
<xsl:key name="generic:funcs" match="my:func" use="@name"/>  

<!-- Extend the available generic functions -->
<xsl:variable name="aggr:generics" select="document('')/*/generic:* | $aggr:public-generics"/>

<!--Add a generic element function for computing reciprocal -->
<my:func name="reciprocal"/>
<xsl:template match="my:func[@name='reciprocal']">
	<xsl:param name="x"/>
	<xsl:value-of select="1 div $x"/>
</xsl:template>


<!--Test aggregation functionality -->
<xsl:template match="numbers">

<results>

  <!-- Sum the numbers -->  
  <sum>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
    </xsl:call-template>
 </sum>

  <!-- Sum the squares -->
  <sumSq>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="func" select=" 'square' "/>
    </xsl:call-template>
  </sumSq>
  
  <!-- Product of the reciprocals -->
  <prodRecip>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="aggr-func" select=" 'product' "/>
      <xsl:with-param name="func" select=" 'reciprocal' "/>
    </xsl:call-template>
  </prodRecip>

  <!-- Maximum -->
  <max>
      <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="aggr-func" select=" 'max' "/>
    </xsl:call-template>
  </max>

  <!-- Minimum -->
  <min>
      <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="aggr-func" select=" 'min' "/>
    </xsl:call-template>
  </min>

</results> 
  
</xsl:template>

</xsl:stylesheet>

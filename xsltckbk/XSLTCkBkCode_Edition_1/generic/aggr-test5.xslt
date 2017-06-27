<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="generic aggr exslt">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>

<!-- Extend the available generic functions -->
<xsl:variable name="aggr:generics" select="$aggr:public-generics | document('')/*/generic:*"/>

<!--Add generic agregators for computing the min and the max values in a node set-->
<generic:aggr-func name="avg" identity="0"/>
<xsl:template match="generic:aggr-func[@name='avg']">
	<xsl:param name="x"/>
	<xsl:param name="accum"/>
	<xsl:param name="i"/>
	<xsl:value-of select="(($i - 1) * $accum + $x) div $i"/>
</xsl:template>

<generic:aggr-func name="variance" identity=""/>
<xsl:template match="generic:aggr-func[@name='variance']">
  <xsl:param name="x"/>
  <xsl:param name="accum"/>
  <xsl:param name="i"/>
	
  <xsl:choose>
    <xsl:when test="$accum = @identity">
      <!-- Initialize the sum, sum of squares and variance. The variance of a single number is zero -->
      <variance sum="{$x}" sumSq="{$x * $x}">0</variance>
    </xsl:when>
    <xsl:otherwise>
      <!--Use node-set to convert $accum to a nodes set containing the variance element -->
      <xsl:variable name="accumElem" select="exslt:node-set($accum)"/>
      <!-- Aggregate the sum of $x component -->
      <xsl:variable name="sum" select="$accumElem/*/@sum + $x"/>
      <!-- Aggregate the sum of $x squared component -->
      <xsl:variable name="sumSq" select="$accumElem/*/@sumSq + $x * $x"/>
      <!--Return the element with attributes and the current variance as its value -->
      <variance sum="{$sum}" sumSq="{$sumSq}">
        <xsl:value-of select="($sumSq - ($sum * $sum) div $i) div ($i - 1)"/>
      </variance>
    </xsl:otherwise>
  </xsl:choose>
 
</xsl:template>


<!--Test aggregation functionality -->
<xsl:template match="numbers">

<results>

  <!-- Average -->  
  <avg>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="aggr-func" select=" 'avg' "/>
    </xsl:call-template>
 </avg>

  <!-- Average of the squares -->
  <avgSq>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="func" select=" 'square' "/>
      <xsl:with-param name="aggr-func" select=" 'avg' "/>
    </xsl:call-template>
  </avgSq>

  <!-- Variance -->
  <variance>
    <xsl:call-template name="aggr:aggregation">
      <xsl:with-param name="nodes" select="number"/>
      <xsl:with-param name="aggr-func" select=" 'variance' "/>
    </xsl:call-template>
  </variance>

</results> 
  
</xsl:template>

</xsl:stylesheet>

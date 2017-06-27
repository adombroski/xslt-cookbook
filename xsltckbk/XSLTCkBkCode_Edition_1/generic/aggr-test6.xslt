<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic" xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate" xmlns:exslt="http://exslt.org/common" extension-element-prefixes="generic aggr">

  <xsl:import href="aggregation.xslt"/>
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Extend the available generic functions -->
  <xsl:variable name="aggr:generics" select="$aggr:public-generics | document('')/*/generic:*"/>
  
  <!-- Extend the primitives to compute commision-->
  <generic:func name="commision"/>
  <xsl:template match="generic:func[@name='commision']">
    <xsl:param name="x"/>
    <!-- defer actual computation to a polymorphic template using mode commision -->
    <xsl:apply-templates select="$x" mode="commision"/>
  </xsl:template>
  
  <!-- By default salespeople get 2% commsison and no base salary -->
  <xsl:template match="salesperson" mode="commision">
    <xsl:value-of select="0.02 * sum(product/@totalSales)"/>
  </xsl:template>
  
  <!-- salespeople with seniority > 4 get $10000.00 base + 0.5% commsison -->
  <xsl:template match="salesperson[@seniority > 4]" mode="commision" priority="1">
    <xsl:value-of select="10000.00 + 0.05 * sum(product/@totalSales)"/>
  </xsl:template>
  
  <!-- salespeople with seniority > 8 get (seniority * $2000.00) base + 0.8% commsison -->
  <xsl:template match="salesperson[@seniority > 8]" mode="commision" priority="2">
    <xsl:value-of select="@seniority * 2000.00 + 0.08 * 
		sum(product/@totalSales)"/>
  </xsl:template>
  
  <xsl:template match="salesBySalesperson">
    <results>
      <result>
        <xsl:text>Total commision = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*"/>
          <xsl:with-param name="aggr-func" select=" 'sum' "/>
          <xsl:with-param name="func" select=" 'commision' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Min commision = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*"/>
          <xsl:with-param name="aggr-func" select=" 'min' "/>
          <xsl:with-param name="func" select=" 'commision' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Max commision = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*"/>
          <xsl:with-param name="aggr-func" select=" 'max' "/>
          <xsl:with-param name="func" select=" 'commision' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Avg commision = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*"/>
          <xsl:with-param name="aggr-func" select=" 'avg' "/>
          <xsl:with-param name="func" select=" 'commision' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Avg sales = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*/product/@totalSales"/>
          <xsl:with-param name="aggr-func" select=" 'avg' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Min sales = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*/product/@totalSales"/>
          <xsl:with-param name="aggr-func" select=" 'min' "/>
        </xsl:call-template>
      </result>
      <result>
        <xsl:text>Max sales = </xsl:text>
        <xsl:call-template name="aggr:aggregation">
          <xsl:with-param name="nodes" select="*/product/@totalSales"/>
          <xsl:with-param name="aggr-func" select=" 'max' "/>
        </xsl:call-template>
      </result>
    </results>
  </xsl:template>
  
</xsl:stylesheet>

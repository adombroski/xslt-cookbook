<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:aggr="http://www.ora.com/XSLTCookbook/namespaces/aggregate"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="generic aggr exslt">

  <xsl:import href="aggregation.xslt"/>
  
  <xsl:output method="xml" indent="yes"/>

  <xsl:template name="factorial">
    <xsl:param name="n" select="0"/>
    
    <xsl:call-template name="aggr:bounded-aggregation">
      <xsl:with-param name="x" select="$n"/>
      <xsl:with-param name="test-func" select=" 'greater-than' "/>
      <xsl:with-param name="test-param1" select="0"/> 
      <xsl:with-param name="incr-func" select=" 'decr' "/>
      <xsl:with-param name="aggr-func" select=" 'product' "/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="prod-range">
    <xsl:param name="start" select="1"/>
    <xsl:param name="end" select="1"/>
    
    <xsl:call-template name="aggr:bounded-aggregation">
      <xsl:with-param name="x" select="$start"/>
      <xsl:with-param name="test-func" select=" 'less-than-eq' "/>
      <xsl:with-param name="test-param1" select="$end"/> 
      <xsl:with-param name="incr-func" select=" 'incr' "/>
      <xsl:with-param name="aggr-func" select=" 'product' "/>
    </xsl:call-template>

  </xsl:template>


<xsl:template match="/">

  <results>
  
    <factorial n="0">
      <xsl:call-template name="factorial"/>
    </factorial>
    
    <factorial n="1">
      <xsl:call-template name="factorial">
        <xsl:with-param name="n" select="1"/>
      </xsl:call-template>
    </factorial>

    <factorial n="5">
      <xsl:call-template name="factorial">
        <xsl:with-param name="n" select="5"/>
      </xsl:call-template>
    </factorial>

    <factorial n="20">
      <xsl:call-template name="factorial">
        <xsl:with-param name="n" select="20"/>
      </xsl:call-template>
    </factorial>

    <product start="1" end="20">
      <xsl:call-template name="prod-range">
        <xsl:with-param name="start" select="1"/>
        <xsl:with-param name="end" select="20"/>
      </xsl:call-template>
    </product>

    <product start="10" end="20">
      <xsl:call-template name="prod-range">
        <xsl:with-param name="start" select="10"/>
        <xsl:with-param name="end" select="20"/>
      </xsl:call-template>
    </product>


  </results>

</xsl:template>
  
</xsl:stylesheet>

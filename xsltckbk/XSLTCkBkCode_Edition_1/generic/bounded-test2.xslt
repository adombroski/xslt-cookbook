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

  <xsl:template name="integrate">
    <xsl:param name="from" select="0"/>
    <xsl:param name="to" select="1"/>
    <xsl:param name="func" select=" 'identity' "/>
    <xsl:param name="delta" select="($to - $from) div 100"/>
    
    <xsl:call-template name="aggr:bounded-aggregation">
      <xsl:with-param name="x" select="$from"/>
      <xsl:with-param name="func" select=" 'f-of-x-dx' "/>
      <xsl:with-param name="func-param1">
        <params f-of-x="{$func}" dx="{$delta}"/>
      </xsl:with-param>
      <xsl:with-param name="test-func" select=" 'less-than' "/>
      <xsl:with-param name="test-param1" select="$to"/> 
      <xsl:with-param name="incr-func" select=" 'incr' "/>
      <xsl:with-param name="incr-param1" select="$delta"/> 
      <xsl:with-param name="aggr-func" select=" 'sum' "/>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="integrate2">
    <xsl:param name="from" select="0"/>
    <xsl:param name="to" select="1"/>
    <xsl:param name="func" select=" 'identity' "/>
    <xsl:param name="delta" select="($to - $from) div 100"/>
    
    <xsl:call-template name="aggr:bounded-aggregation">
      <xsl:with-param name="x" select="$from"/>
      <xsl:with-param name="func" select=" 'f-of-x-dx-2' "/>
      <xsl:with-param name="func-param1">
        <params f-of-x="{$func}" dx="{$delta}"/>
      </xsl:with-param>
      <xsl:with-param name="test-func" select=" 'less-than' "/>
      <xsl:with-param name="test-param1" select="$to"/> 
      <xsl:with-param name="incr-func" select=" 'incr' "/>
      <xsl:with-param name="incr-param1" select="$delta"/> 
      <xsl:with-param name="aggr-func" select=" 'sum' "/>
    </xsl:call-template>

  </xsl:template>

  <generic:func name="f-of-x-dx"/>
  <xsl:template match="generic:func[@name='f-of-x-dx']">
  	<xsl:param name="x"/>
  	<xsl:param name="param1"/>
  	
      <xsl:variable name="f-of-x">
        <xsl:apply-templates select="$aggr:generics[self::generic:func and @name = exslt:node-set($param1)/*/@f-of-x]">
          <xsl:with-param name="x" select="$x"/>
        </xsl:apply-templates>
  	</xsl:variable>
  	
  	<xsl:value-of select="$f-of-x * exslt:node-set($param1)/*/@dx"/>
  </xsl:template>

  <generic:func name="f-of-x-dx-2"/>
  <xsl:template match="generic:func[@name='f-of-x-dx-2']">
  	<xsl:param name="x"/>
  	<xsl:param name="param1"/>
  	
  	<xsl:variable name="func" select="exslt:node-set($param1)/*/@f-of-x"/>
  	<xsl:variable name="dx" select="exslt:node-set($param1)/*/@dx"/>
  	
      <xsl:variable name="f-of-x">
        <xsl:apply-templates select="$aggr:generics[self::generic:func and @name = $func]">
          <xsl:with-param name="x" select="$x"/>
        </xsl:apply-templates>
  	</xsl:variable>

      <xsl:variable name="f-of-x-plus-dx">
        <xsl:apply-templates select="$aggr:generics[self::generic:func and @name = $func]">
          <xsl:with-param name="x" select="$x + $dx"/>
        </xsl:apply-templates>
  	</xsl:variable>

      <!-- This is just the absolute value of $f-of-x-plus-dx - $f-of-x -->   	
  	<xsl:variable name="abs-diff" select="(1 - 2 *(($f-of-x-plus-dx - $f-of-x) &lt; 0)) * ($f-of-x-plus-dx - $f-of-x)"/>
  	
  	<xsl:value-of select="$f-of-x * $dx + ($abs-diff * $dx) div 2"/>
  	
  </xsl:template>


  <xsl:template match="/">

  <results>
  
    <integrate desc="intgr x from 0 to 1">
      <xsl:call-template name="integrate"/>
    </integrate>

    <integrate desc="intgr x from 0 to 1 with more precision">
      <xsl:call-template name="integrate">
        <xsl:with-param name="delta" select="0.001"/>
      </xsl:call-template>
    </integrate>

    <integrate desc="intgr x from 0 to 1 with better algorithm">
      <xsl:call-template name="integrate2"/>
    </integrate>

    <integrate desc="intgr x**2 from 0 to 1">
      <xsl:call-template name="integrate">
        <xsl:with-param name="func" select=" 'square' "/>
      </xsl:call-template>
    </integrate>

    <integrate desc="intgr x**2 from 0 to 1 with better algorithm">
      <xsl:call-template name="integrate2">
        <xsl:with-param name="func" select=" 'square' "/>
      </xsl:call-template>
    </integrate>
    
  </results>

</xsl:template>
  
</xsl:stylesheet>

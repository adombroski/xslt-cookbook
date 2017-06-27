<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  extension-element-prefixes="generic">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>

<!-- Extend the available generic functions -->
<xsl:variable name="generic:generics" select="$generic:public-generics | document('')/*/generic:*"/>

  <generic:func name="pow" n="1"/>
  <xsl:template match="generic:func[@name='pow' and @n='1']">
  	<xsl:param name="x"/>
  	<xsl:message>pow1</xsl:message>
  	<xsl:value-of select="$x"/>
  </xsl:template>

  <generic:func name="pow" n="2"/>
  <xsl:template match="generic:func[@name='pow' and @n='2']">
  	<xsl:param name="x"/>
  	<xsl:message>pow2</xsl:message>
  	<xsl:value-of select="$x * $x"/>
  </xsl:template>

  <generic:func name="pow" n="4"/>
  <xsl:template match="generic:func[@name='pow' and @n='4']">
  	<xsl:param name="x"/>
  	<xsl:message>pow4</xsl:message>
  	<xsl:value-of select="$x * $x * $x * $x"/>
  </xsl:template>

  <generic:func name="pow" n="8"/>
  <xsl:template match="generic:func[@name='pow' and @n='8']">
  	<xsl:param name="x"/>
  	<xsl:message>pow8</xsl:message>
  	<xsl:value-of select="$x * $x * $x * $x * $x * $x * $x * $x"/>
  </xsl:template>

  <generic:func name="pow" n="*"/>
  <xsl:template match="generic:func[@name='pow' and @n='*']">
  	<xsl:param name="x"/>
 	<xsl:param name="i"/> 
  	<xsl:message>pow*=<xsl:value-of select="$i"/></xsl:message>
 	<xsl:variable name="n1" select="floor($i div 2)"/>
 	<xsl:variable name="n2" select="ceiling($i div 2)"/>
 	<xsl:variable name="a">
          <xsl:apply-templates select="($generic:generics[self::generic:func and @name = 'pow' and (@n=$n1 or @n = '*')])[1]">
            <xsl:with-param name="x" select="$x"/>
 	     <xsl:with-param name="i" select="$n1"/> 
          </xsl:apply-templates>
 	</xsl:variable>
 	<xsl:variable name="b">
          <xsl:apply-templates select="($generic:generics[self::generic:func and @name = 'pow' and (@n=$n2 or @n = '*')])[1]">
            <xsl:with-param name="x" select="$x"/>
 	     <xsl:with-param name="i" select="$n2"/> 
          </xsl:apply-templates>
 	</xsl:variable>
 	<xsl:value-of select="$a * $b"/>
  </xsl:template>

  <xsl:template match="numbers">
    <results>
      <!-- Polynomial -->  
      <polynomial>
        <xsl:call-template name="generic:pos-aggregation">
          <xsl:with-param name="nodes" select="number"/>
          <xsl:with-param name="func" select=" 'pow' "/>
        </xsl:call-template>
     </polynomial>
    
    </results>
  </xsl:template>


</xsl:stylesheet>

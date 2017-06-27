<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic">

  <xsl:import href="aggregation.xslt"/>

  <xsl:output method="xml" indent="yes"/>

  <!-- Extend the available generic functions -->
  <xsl:variable name="generic:generics" select="$generic:public-generics | document('')/*/generic:*"/>

  <!-- These values give good random results but you can tweak -->
  <xsl:variable name="a" select="16807"/>
  <xsl:variable name="c" select="0"/>
  <xsl:variable name="m"  select="2147483647"/>

  <!-- Store the root for later use -->
  <xsl:variable name="doc" select="/"/>

  <!-- The random generator -->
  <generic:func name="linear-congruential"/>
  <xsl:template match="generic:func[@name='linear-congruential']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="($a * $x + $c) mod $m"/>
  </xsl:template>

  <xsl:template match="/">
  <names>
      <xsl:call-template name="generic:gen-nested">
        <xsl:with-param name="x" select="1"/>
        <xsl:with-param name="func" select=" 'linear-congruential' "/>
        <xsl:with-param name="n" select="100"/>
        <!-- Don't include initial seed -->
        <xsl:with-param name="result" select="/.."/>
      </xsl:call-template>
    </names>
  </xsl:template>

<xsl:template match="node()" mode="generic:gen-nested">
  
  <!-- Restrict the range to 1 through 100 -->
  <xsl:variable name="random" select=". mod 99 + 1"/>
  
   <name>
    <xsl:value-of select="$doc/names/name[$random]"/>
  </name>
  
</xsl:template>
    	 
</xsl:stylesheet>

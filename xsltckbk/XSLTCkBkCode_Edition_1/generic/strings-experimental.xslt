<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <generic:slice-func name="front-half"/>
  <xsl:template match="generic:func[@name='front-half']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,1, floor(string-length($x) div 2))"/>
  </xsl:template>

  <generic:slice-func name="rear-half"/>
  <xsl:template match="generic:func[@name='rear-half']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,floor(string-length($x) div 2)+1)"/>
  </xsl:template>

  <generic:slice-func name="first-char"/>
  <xsl:template match="generic:func[@name='first-char']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,1, 1)"/>
  </xsl:template>

  <generic:slice-func name="back"/>
  <xsl:template match="generic:func[@name='back']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,2)"/>
  </xsl:template>

  <generic:slice-func name="last-char"/>
  <xsl:template match="generic:func[@name='last-char']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,string-length($x))"/>
  </xsl:template>

  <generic:slice-func name="front"/>
  <xsl:template match="generic:func[@name='front']">
  	<xsl:param name="x"/>
  	<xsl:value-of select="substring($x,1,string-length($x)-1)"/>
  </xsl:template>

	
  <xsl:template name="aggr:stringProc">
    <xsl:param name="input"/>
    <xsl:param name="slicer1-func" select=" 'front-half' "/>
    <xsl:param name="slicer2-func" select=" 'rear-half' "/>
    <xsl:param name="func1" select=" 'identity' "/>
    <xsl:param name="func2" select="$func1"/>
    
    <xsl:if test="$input">
    
      <xsl:variable name="front">
          <xsl:apply-templates select="$aggr:generics[self::generic:slice-func and @name = $slicer1-func]">
            <xsl:with-param name="x" select="$input"/>
          </xsl:apply-templates>
      </xsl:variable>
      
      <xsl:variable name="rear">
          <xsl:apply-templates select="$aggr:generics[self::generic:slice-func and @name = $slicer2-func]">
            <xsl:with-param name="x" select="$input"/>
          </xsl:apply-templates>
      </xsl:variable>
      
      <xsl:variable name="temp1">
          <xsl:apply-templates select="$aggr:generics[self::generic:func and @name = $func1]">
            <xsl:with-param name="x" select="$front"/>
          </xsl:apply-templates>
      </xsl:variable>
      
      <xsl:variable name="temp2">
          <xsl:apply-templates select="$aggr:generics[self::generic:func and @name = $func2]">
            <xsl:with-param name="x" select="$rear"/>
          </xsl:apply-templates>
      </xsl:variable>
      
      <xsl:call-template name="aggr:stringProc">
        <xsl:with-param name="input" select="$temp1"/>
        <xsl:param name="slicer1-func" select="$slicer1-func"/>
        <xsl:param name="slicer2-func" select="$slicer2-func"/>
        <xsl:param name="func1" select="$func1"/>
        <xsl:param name="func2" select="$func2"/>
      </xsl:call-template>
      <xsl:call-template name="aggr:stringProc">
        <xsl:with-param name="input" select="$temp2"/>
        <xsl:param name="slicer1-func" select="$slicer1-func"/>
        <xsl:param name="slicer2-func" select="$slicer2-func"/>
        <xsl:param name="func1" select="$func1"/>
        <xsl:param name="func2" select="$func2"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

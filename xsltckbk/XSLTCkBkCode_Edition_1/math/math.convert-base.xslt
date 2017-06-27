<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://www.ora.com/XSLTCookbook/namespaces/math" extension-element-prefixes="math">

<xsl:output method="text" />

<xsl:template match="/">
  <xsl:call-template name="math:convert-base">
    <xsl:with-param name="number" select=" '1001101' "/>
    <xsl:with-param name="from-base" select="2"/>
    <xsl:with-param name="to-base" select="16"/>
  </xsl:call-template>
</xsl:template>

<xsl:variable name="math:base-lower" select="'0123456789abcdefghijklmnopqrstuvwxyz'"/>
<xsl:variable name="math:base-upper" select="'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	

<xsl:template name="math:convert-base">
  <xsl:param name="number"/>
  <xsl:param name="from-base"/>
  <xsl:param name="to-base"/>
  
  <xsl:variable name="number-base10">
    <xsl:call-template name="math:convert-to-base-10">
      <xsl:with-param name="number" select="$number"/>
      <xsl:with-param name="from-base" select="$from-base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="math:convert-from-base-10">
    <xsl:with-param name="number" select="$number-base10"/>
    <xsl:with-param name="to-base" select="$to-base"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="math:convert-to-base-10">
  <xsl:param name="number"/>
  <xsl:param name="from-base"/>

  <xsl:variable name="num" select="translate($number,$math:base-upper, $math:base-lower)"/>
  <xsl:variable name="valid-in-chars" select="substring($math:base-lower,1,$from-base)"/>
  
  <xsl:choose>
    <xsl:when test="$from-base &lt; 2 or $from-base > 36">NaN</xsl:when>
    <xsl:when test="not($num) or translate($num,$valid-in-chars,'')">NaN</xsl:when>
    <xsl:when test="$from-base = 10">
      <xsl:value-of select="$number"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:convert-to-base-10-impl">
        <xsl:with-param name="number" select="$num"/>
        <xsl:with-param name="from-base" select="$from-base"/>
        <xsl:with-param name="from-chars" select="$valid-in-chars"/>
     </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="math:convert-to-base-10-impl">
  <xsl:param name="number"/>
  <xsl:param name="from-base"/>
  <xsl:param name="from-chars"/>

  <xsl:param name="result" select="0"/>

  <xsl:variable name="value" select="string-length(substring-before($from-chars,substring($number,1,1)))"/>

  <xsl:variable name="total" select="$result * $from-base + $value"/>
  
  <xsl:choose>
    <xsl:when test="string-length($number) = 1">
      <xsl:value-of select="$total"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:convert-to-base-10-impl">
        <xsl:with-param name="number" select="substring($number,2)"/>
        <xsl:with-param name="from-base" select="$from-base"/>
        <xsl:with-param name="from-chars" select="$from-chars"/>
        <xsl:with-param name="result" select="$total"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="math:convert-from-base-10">
  <xsl:param name="number"/>
  <xsl:param name="to-base"/>

  <xsl:choose>
    <xsl:when test="$to-base &lt; 2 or $to-base > 36">NaN</xsl:when>
    <xsl:when test="number($number) != number($number)">NaN</xsl:when>
    <xsl:when test="$to-base = 10">
      <xsl:value-of select="$number"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="math:convert-from-base-10-impl">
        <xsl:with-param name="number" select="$number"/>
        <xsl:with-param name="to-base" select="$to-base"/>
     </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="math:convert-from-base-10-impl">
  <xsl:param name="number"/>
  <xsl:param name="to-base"/>
  <xsl:param name="result"/>
  
  <xsl:variable name="to-base-digit" select="substring($math:base-lower,$number mod $to-base + 1,1)"/>
  
  <xsl:choose>
    <xsl:when test="$number >= $to-base">
      <xsl:call-template name="math:convert-from-base-10-impl">
        <xsl:with-param name="number" select="floor($number div $to-base)"/>
        <xsl:with-param name="to-base" select="$to-base"/>
        <xsl:with-param name="result" select="concat($to-base-digit,$result)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($to-base-digit,$result)"/>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>

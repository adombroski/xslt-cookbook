<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dbg="http://www.ora.com/XSLTCookbook/ns/debug">

  <xsl:include href="trace.xslt"/>
  
  <xsl:output method="text"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/employee" priority="10">
    <xsl:call-template name="dbg:trace"/>
    <xsl:apply-templates/>
    <xsl:value-of select="@name"/>
    <xsl:text> is the head of the company. </xsl:text>
    <xsl:call-template name="reportsTo"/>
    <xsl:call-template name="HimHer"/>
    <xsl:text>. </xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="employee[employee]">
    <xsl:call-template name="dbg:trace"/>
    <xsl:apply-templates/>
    <xsl:call-template name="dbg:trace"/>
    <xsl:value-of select="@name"/>
    <xsl:text> is a manager. </xsl:text>
    <xsl:call-template name="reportsTo"/>
    <xsl:call-template name="HimHer"/>
    <xsl:text>. </xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="employee">
    <xsl:call-template name="dbg:trace"/>
    <xsl:text>Nobody reports to </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>. &#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template name="HimHer">
    <xsl:choose>
      <xsl:when test="@sex = 'male' ">
        <xsl:text>him</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>her</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="reportsTo">
    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="position() &lt; last() - 1 and last() > 2">
          <xsl:value-of select="@name"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="position() = last() - 1  and last() > 1">
          <xsl:value-of select="@name"/>
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:when test="position() = last() and last() = 1">
          <xsl:value-of select="@name"/>
          <xsl:text> reports to </xsl:text>
        </xsl:when>
        <xsl:when test="position() = last()">
          <xsl:value-of select="@name"/>
          <xsl:text> report to </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>

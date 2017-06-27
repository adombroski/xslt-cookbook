<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">

<xsl:import href="vset.ops.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="person" mode="vset:element-equality">
  <xsl:param name="other"/>
  <xsl:if test="@name = $other/@name">  
    <xsl:value-of select="true()"/>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
  <xsl:variable name="males" select="//person[@sex='m']"/>
  <xsl:variable name="smokers" select="//person[@smoker='yes']"/>
  <xsl:variable name="empty" select="//person[@smoker='foo']"/>
  <results>
    <set1>
      <xsl:copy-of select="$males"/>
    </set1>
    <set2>
      <xsl:copy-of select="$smokers"/>
    </set2>
    <union name='males or smokers'>
      <xsl:call-template name="vset:union">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$smokers"/>
      </xsl:call-template>
    </union>
    <union name='males'>
      <xsl:call-template name="vset:union">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$empty"/>
      </xsl:call-template>
    </union>
    <union name='smokers'>
      <xsl:call-template name="vset:union">
        <xsl:with-param name="nodes1" select="$empty"/>
        <xsl:with-param name="nodes2" select="$smokers"/>
      </xsl:call-template>
    </union>
    <intersection name='male smokers'>
      <xsl:call-template name="vset:intersection">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$smokers"/>
      </xsl:call-template>
    </intersection>
    <intersection name='empty1'>
      <xsl:call-template name="vset:intersection">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$empty"/>
      </xsl:call-template>
    </intersection>
    <intersection name='empty2'>
      <xsl:call-template name="vset:intersection">
        <xsl:with-param name="nodes1" select="$empty"/>
        <xsl:with-param name="nodes2" select="$smokers"/>
      </xsl:call-template>
    </intersection>
    <difference name='males - smokers'>
      <xsl:call-template name="vset:difference">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$smokers"/>
      </xsl:call-template>
    </difference>
    <difference name='smokers - males'>
      <xsl:call-template name="vset:difference">
        <xsl:with-param name="nodes1" select="$smokers"/>
        <xsl:with-param name="nodes2" select="$males"/>
      </xsl:call-template>
    </difference>
    <difference name='males - males'>
      <xsl:call-template name="vset:difference">
        <xsl:with-param name="nodes1" select="$males"/>
        <xsl:with-param name="nodes2" select="$males"/>
      </xsl:call-template>
    </difference>
  </results>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svgu="http://www.ora.com/XSLTCookbook/ns/svg-utils"
  xmlns:test="http://www.ora.com/XSLTCookbook/ns/test"
  exclude-result-prefixes="svgu">

<xsl:include href="svg-utils.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" 
  doctype-public="-//W3C//DTD SVG 1.0/EN"
  doctype-system="http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"/>

<test:o>-10</test:o>
<test:o>-9</test:o>
<test:o>-8</test:o>
<test:o>-9</test:o>
<test:o>-8</test:o>
<test:o>-7</test:o>
<test:o>-6</test:o>
<test:o>1</test:o>
<test:o>2</test:o>
<test:o>2.8</test:o>

<test:h>-10</test:h>
<test:h>-8</test:h>
<test:h>-7</test:h>
<test:h>-8</test:h>
<test:h>-5</test:h>
<test:h>-6</test:h>
<test:h>-4</test:h>
<test:h>1.3</test:h>
<test:h>2.7</test:h>
<test:h>3.2</test:h>

<test:l>-11</test:l>
<test:l>-10</test:l>
<test:l>-9</test:l>
<test:l>-11</test:l>
<test:l>-10</test:l>
<test:l>-8</test:l>
<test:l>-7</test:l>
<test:l>-2</test:l>
<test:l>0</test:l>
<test:l>1</test:l>

<test:c>-11</test:c>
<test:c>-9.1</test:c>
<test:c>-8</test:c>
<test:c>-8.5</test:c>
<test:c>-7.6</test:c>
<test:c>-7.1</test:c>
<test:c>-6.3</test:c>
<test:c>1.2</test:c>
<test:c>2.2</test:c>

<xsl:template match="/">

<svg width="500" height="500">

  <xsl:call-template name="svgu:openHiLoClose">
    <xsl:with-param name="openData" select="document('')/*/test:o"/>            
    <xsl:with-param name="hiData" select="document('')/*/test:h"/>            
    <xsl:with-param name="loData" select="document('')/*/test:l"/>            
    <xsl:with-param name="closeData" select="document('')/*/test:c"/>            
    <xsl:with-param name="width" select="460"/> 
    <xsl:with-param name="height" select="460"/>
    <xsl:with-param name="offsetX" select="20"/>
    <xsl:with-param name="offsetY" select="20"/>
    <xsl:with-param name="boundingBox" select="1"/>
  </xsl:call-template>

  <xsl:call-template name="svgu:yAxis">
    <xsl:with-param name="min" select="-11"/>
    <xsl:with-param name="max" select="3"/>
    <xsl:with-param name="offsetX" select="20"/>
    <xsl:with-param name="offsetY" select="20"/>
    <xsl:with-param name="width" select="460"/>
    <xsl:with-param name="height" select="460"/>
  </xsl:call-template>

</svg>

</xsl:template>

</xsl:stylesheet>

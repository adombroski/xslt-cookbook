<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:generic="http://www.ora.com/XSLTCookbook/namespaces/generic"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt" exclude-result-prefixes="generic">

<xsl:import href="aggregation.xslt"/>

<xsl:output method="xml" indent="yes"/>

<!--Test map functionality -->
<xsl:template match="numbers">

<results>

<less-than-5>
  <xsl:call-template name="generic:map">
    <xsl:with-param name="nodes" select="number"/>
    <xsl:with-param name="func" select=" 'less-than' "/>
    <xsl:with-param name="func-param1" select="5"/>
  </xsl:call-template>
</less-than-5>

<greater-than-5>
  <xsl:call-template name="generic:map">
    <xsl:with-param name="nodes" select="number"/>
    <xsl:with-param name="func" select=" 'greater-than' "/>
    <xsl:with-param name="func-param1" select="5"/>
  </xsl:call-template>
</greater-than-5>

</results>

  
</xsl:template>


<xsl:template match="/ | node() | @*" mode="generic:map">
  <xsl:if test="string(.)">
    <node>
      <xsl:copy-of select="."/>
    </node>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

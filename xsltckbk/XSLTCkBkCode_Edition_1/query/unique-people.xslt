<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">

<xsl:import href="vset.ops.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
  <people>
    <xsl:call-template name="vset:union">
      <xsl:with-param name="node-set1" select="//person"/>
      <xsl:with-param name="node-set2" select="document('people2.xml')//person"/>
    </xsl:call-template>
  </people>
</xsl:template>

<!--Define person equality as having the same name -->
<xsl:template match="person" mode="vset:element-equality">
  <xsl:param name="other"/>
  <xsl:if test="@name = $other/@name">  
    <xsl:value-of select="true()"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

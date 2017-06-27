<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset">


<xsl:import href="../query/vset.ops.xslt"/>

<xsl:output method="xml" indent="yes"/>

<xsl:param name="doc2"/> 

<xsl:template match="/*">
  <xsl:copy>
    <xsl:call-template name="vset:union">
      <xsl:with-param name="nodes1" select="*"/>
      <xsl:with-param name="nodes2" select="document($doc2)/*/*"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

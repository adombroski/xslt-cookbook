<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
Find Martha's spouse. 

Solution in XQuery:

<result>
  {
    for $m in document("census.xml")//person[@name = "Martha"]
    return shallow($m/@spouse=>person)
  }
</result>
-->

<xsl:strip-space elements="*"/>
<xsl:template match="person[@spouse='Martha']">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
  </xsl:copy>
</xsl:template>

<!-- or else
<xsl:template match="person[@name='Martha']">
  <xsl:for-each select="id(@spouse)">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
  </xsl:copy>
  </xsl:for-each>
</xsl:template>
-->


</xsl:stylesheet>

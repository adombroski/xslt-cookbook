<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="text.hierarchy.xslt"/>

<!--Ignore attributes -->
<xsl:template match="@*"/>
<xsl:template match="*" mode="begin-attributes"/>
<xsl:template match="*" mode="end-attributes"/>

<xsl:template match="*"	mode="name">
  <!--Display element level number-->
  <xsl:value-of select="count(preceding-sibling::*) + 1"/> 
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="*" mode="value">
  <xsl:if test="not(*)">
    <xsl:value-of select="."/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

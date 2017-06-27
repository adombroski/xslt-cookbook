<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings"
  xmlns:text="http://www.ora.com/XSLTCookbook/namespaces/text">

<xsl:import href="generic-attr-to-columns.xslt"/>

<!--Defines the mapping from attributes to columns -->
<xsl:variable name="columns" select="document('')/*/text:column"/>

<text:column name="Name" width="20" align="left" attr="name"/>
<text:column name="Age" width="6" align="right" attr="age"/>
<text:column name="Gender" width="6" align="left" attr="sex"/>
<text:column name="Smoker" width="6" align="left" attr="smoker"/>

<!-- Handle custom attribute mappings -->

<xsl:template match="@sex" mode="text:map-col-value">
  <xsl:choose>
    <xsl:when test=".='m'">male</xsl:when>
    <xsl:when test=".='f'">female</xsl:when>
    <xsl:otherwise>error</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:csv="http://www.ora.com/XSLTCookbook/namespaces/csv">

<xsl:import href="generic-attr-to-csv.xslt"/>

<!--Defines the mapping from attributes to columns -->
<xsl:variable name="columns" select="document('')/*/csv:column"/>

<csv:column name="Name" attr="name"/>
<csv:column name="Age" attr="age"/>
<csv:column name="Gender" attr="sex"/>
<csv:column name="Smoker" attr="smoker"/>


<!-- Handle custom attribute mappings -->

<xsl:template match="@sex" mode="csv:map-value">
  <xsl:choose>
    <xsl:when test=".='m'">male</xsl:when>
    <xsl:when test=".='f'">female</xsl:when>
    <xsl:otherwise>error</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

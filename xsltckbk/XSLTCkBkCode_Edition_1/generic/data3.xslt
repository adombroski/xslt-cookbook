<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="data" exclude-result-prefixes="xsl" >

<xsl:import href="data2.xslt"/>

<xsl:output method="xml" indent="yes"/>

<d:data value="13"/>
<d:data value="17"/>
<d:data value="23"/>

<xsl:variable name="data3-public-data" select="document('')/*/d:* | $data2-public-data" />
<xsl:variable name="data" select="$data3-public-data"/>

<xsl:template match="/">
  <demo xmlns:d="data">
    <xsl:copy-of select="$data"/>
  </demo>
</xsl:template>

</xsl:stylesheet>

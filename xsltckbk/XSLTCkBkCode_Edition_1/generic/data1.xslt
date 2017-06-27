<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:d="data">

<xsl:output method="xml" indent="yes"/>

<d:data value="1"/>
<d:data value="2"/>
<d:data value="3"/>

<xsl:variable name="data1-public-data" select="document('')/*/d:*"/>
<xsl:variable name="data" select="$data1-public-data"/>

<xsl:template match="/">
  <demo>
    <xsl:copy-of select="$data"/>
  </demo>
</xsl:template>


</xsl:stylesheet>

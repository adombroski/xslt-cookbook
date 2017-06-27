<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="copy.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8"/>

<xsl:template match="@lastname">
  <xsl:attribute name="surname">
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>

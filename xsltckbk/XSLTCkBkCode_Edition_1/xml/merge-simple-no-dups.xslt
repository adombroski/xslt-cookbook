<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="doc2"/> 

<xsl:template match="/*">
  <xsl:copy>
    <xsl:copy-of select="* | document($doc2)/*/*"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

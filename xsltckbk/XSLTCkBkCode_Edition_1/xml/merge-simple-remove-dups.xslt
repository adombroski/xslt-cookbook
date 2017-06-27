<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="doc2"/> 

<xsl:template match="/*">
  <xsl:copy>
    <xsl:for-each select="(* | document($doc2)/*/*)[not(@lastname = preceding::person/@lastname)]">
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

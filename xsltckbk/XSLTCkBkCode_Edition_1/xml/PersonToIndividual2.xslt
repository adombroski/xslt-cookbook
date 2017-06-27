<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="copy.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8"/>

<xsl:template match="person">
  <xsl:element name="individual">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


</xsl:stylesheet>

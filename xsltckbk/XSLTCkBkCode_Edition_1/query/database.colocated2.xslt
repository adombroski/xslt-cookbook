<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/">
<result>
  <xsl:for-each select="database/suppliers/*">
    <xsl:apply-templates select="/database/parts/*[@city=current()/@city]">
      <xsl:with-param name="supplier" select="."/>
    </xsl:apply-templates>
  </xsl:for-each>
</result>
</xsl:template>

<xsl:template match="part">
  <xsl:param name="supplier"/>
  <colocated>
    <xsl:copy-of select="$supplier"/>
    <xsl:copy-of select="."/>
  </colocated>
</xsl:template>
  
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="part-city" match="part" use="@city"/>

<xsl:template match="/">
  <result>
    <xsl:for-each select="database/suppliers/*">
      <xsl:variable name="supplier" select="."/>
      <xsl:for-each select="key('part-city',$supplier/@city)">
      <colocated>
        <xsl:copy-of select="$supplier"/>
        <xsl:copy-of select="."/>
      </colocated>
      </xsl:for-each>
    </xsl:for-each>
  </result>
</xsl:template>


</xsl:stylesheet>

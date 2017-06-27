<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:variable name="cols" select="/*/*/*/ss:Row[1]/ss:Cell/ss:Data"/>

<xsl:template match="ss:Table">
  <table>
    <xsl:apply-templates/>
  </table>
</xsl:template>	

<xsl:template match="ss:Table/ss:Row[1]"/>

<xsl:template match="ss:Row">
  <row>
    <xsl:for-each select="ss:Cell">
      <xsl:variable name="pos" select="position()"/>
      <xsl:element name="{$cols[$pos]}">
        <xsl:value-of select="ss:Data"/>
      </xsl:element>
    </xsl:for-each>
  </row>
</xsl:template>	

<xsl:template match="text()"/>

</xsl:stylesheet>

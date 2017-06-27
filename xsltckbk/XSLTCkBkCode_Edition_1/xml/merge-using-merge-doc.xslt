<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:variable name="docs" select="/*/doc"/>

<xsl:template match="mergeDocs">
	<xsl:apply-templates select="doc[1]"/>
</xsl:template>

<xsl:template match="doc">
  <xsl:variable name="path" select="@path"/>
  <xsl:for-each select="document($path)/*">
    <xsl:copy>
      <xsl:copy-of select="@* | *"/>
      <xsl:for-each select="$docs[position() > 1]">
          <xsl:copy-of select="document(@path)/*/*"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:for-each> 
</xsl:template>

</xsl:stylesheet>

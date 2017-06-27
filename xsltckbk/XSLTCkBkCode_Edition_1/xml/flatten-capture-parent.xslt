<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="copy.xslt"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="yes"/>
      
  <!--discard parents of person elements --> 
  <xsl:template match="*[person]">
  	<xsl:apply-templates/>
  </xsl:template>

<xsl:template match="person">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(..)"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

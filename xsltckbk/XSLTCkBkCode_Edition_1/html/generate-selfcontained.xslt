<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xso="dummy">

<xsl:namespace-alias stylesheet-prefix="xso" result-prefix="xsl"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:param name="datafile"/>
<xsl:param name="outfile"/>

<xsl:template match="/">

  <xsl:text>&#xa;</xsl:text>
  <xsl:processing-instruction name="xml-stylesheet">
   <xsl:text>type="text/xsl" href="</xsl:text><xsl:value-of select="$outfile"/>"<xsl:text/>  
  </xsl:processing-instruction>

 <xsl:copy-of select="node()"/>  
   
</xsl:template>

<xsl:template match="xsl:stylesheet">

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    
    <xsl:apply-templates/>
    
    <xso:template match="xsl:stylesheet">
      <xso:apply-templates select="{name(document($datafile)/*)}"/>
    </xso:template>

  <xsl:copy-of select="document($datafile)"/>
  
  </xsl:copy>

</xsl:template>

</xsl:stylesheet>

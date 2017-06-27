<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="copy.xslt"/>
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>
	
  <xsl:template match="class">
    <!--All people following this class element -->
    <xsl:variable name="nodes1" select="following-sibling::person"/>
    <!--All people following the next class element -->
    <xsl:variable name="nodes2" select="following-sibling::class/following-sibling::person"/>
    <xsl:element name="{@name}">
      <xsl:copy-of select="$nodes1[count(. | $nodes2) != count($nodes2)]"/>
     </xsl:element> 
  </xsl:template>

<xsl:template match="person"/>

</xsl:stylesheet>

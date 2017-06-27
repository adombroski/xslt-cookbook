<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" />

<xsl:strip-space elements="*"/>

<xsl:template match="/">
    <xsl:variable name="pi" select="3.1415926535897932"/>
    <xsl:variable name="pi3" select="333333331.00627668029982"/>
    
    <xsl:value-of select="$pi"/>
    <xsl:text>&#xa;Round </xsl:text>	
    <xsl:value-of select="round($pi * 10000) div 10000"/>
    <xsl:text>&#xa;Ceiling </xsl:text>
    <xsl:value-of select="ceiling($pi * 10000) div 10000"/>
    <xsl:text>&#xa;Floor </xsl:text>
    <xsl:value-of select="floor($pi * 10000) div 10000"/>
    <xsl:text>&#xa;#.#### </xsl:text>
    <xsl:value-of select="format-number($pi,'#.####')"/>
    <xsl:text>&#xa;#.#### </xsl:text>
    <xsl:value-of select="format-number($pi3,'#.####')"/>
    <xsl:text>&#xa;Round </xsl:text>	
    <xsl:value-of select="round($pi * 10000000000000000) div 10000000000000000"/>
    <xsl:text>&#xa;String manipulation </xsl:text>	
    <xsl:value-of select="concat(substring-before($pi,'.'),
                       '.', 
                       substring(substring-after($pi,'.'),1,4))"/>

  <xsl:variable name="whole"  select="substring-before($pi,'.')"/>
  <xsl:variable name="frac"  select="substring-after($pi,'.')"/>
   <xsl:text>&#xa;String rounding </xsl:text>	
  <xsl:value-of select="concat($whole,
                         '.', 
                         substring($frac,1,3),
  			     round(substring($frac,4,2) div 10))"/>
  
  <xsl:text>&#xa;Trunc </xsl:text>	
  <xsl:variable name="pi-to-5-sig" select="format-number($pi,'#.#####')"/>
  <xsl:value-of select="substring($pi-to-5-sig,1,string-length($pi-to-5-sig) -1)"/>

  </xsl:template>

</xsl:stylesheet>

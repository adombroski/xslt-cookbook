<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" />

<xsl:variable name="numCols" select="3"/>	


<xsl:template match="numbers">
  <xsl:for-each select="number[position() mod $numCols = 1]">
    <xsl:apply-templates 
         select=". | following-sibling::number[position() &lt; $numCols]" 
         mode="format"/>
    <xsl:text>&#xa;</xsl:text> 
  </xsl:for-each>
</xsl:template>

<xsl:template match="number" name="format" mode="format">
  <xsl:param name="number" select="." />
  <xsl:text> $ </xsl:text>
  <xsl:call-template name="leading-zero-to-space">
    <xsl:with-param name="input" 
                    select="format-number($number,
                                          ' 0000000.00 ;(0000000.00)')"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="leading-zero-to-space">
  <xsl:param name="input"/>
  <xsl:choose>
    <xsl:when test="starts-with($input,' 0')">
    <xsl:value-of select="' '"/>
    <xsl:call-template name="leading-zero-to-space">
      <xsl:with-param name="input" select="concat(' ',substring-after($input,' 0'))"/>
    </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($input,'(0')">
    <xsl:value-of select="' '"/>
    <xsl:call-template name="leading-zero-to-space">
      <xsl:with-param name="input" select="concat('(',substring-after($input,'(0'))"/>
    </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$input"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

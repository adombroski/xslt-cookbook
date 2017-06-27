<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:output method="text"/>

<xsl:template match="class">
class <xsl:value-of select="name"/> <xsl:apply-templates select="bases"/>
{
public:

  <xsl:value-of select="name"/>() ;
  ~<xsl:value-of select="name"/>() ;
  <xsl:value-of select="name"/>(const <xsl:value-of select="name"/>&amp; other) ;
  <xsl:value-of select="name"/>&amp; operator =(const <xsl:value-of select="name"/>&amp; other) ;
} ;
</xsl:template>	

<xsl:template match="bases">
<xsl:text>: public </xsl:text>
<xsl:for-each select="base">
  <xsl:value-of select="."/>
  <xsl:if test="position() != last()">
    <xsl:text>, public </xsl:text>
  </xsl:if>
</xsl:for-each>
</xsl:template>

<xsl:template match="text()"/>

</xsl:stylesheet>

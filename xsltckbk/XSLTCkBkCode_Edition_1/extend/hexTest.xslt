<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xalan="http://xml.apache.org/xslt" 
xmlns:hex="xalan://com.ora.xsltckbk.util.HexConverter" 
exclude-result-prefixes="hex xalan">


<xsl:template match="group">
enum <xsl:value-of select="@name"/> 
{
  <xsl:apply-templates mode="enum"/>
} ;
</xsl:template> 

<xsl:template match="constant" mode="enum">
  <xsl:variable name="rep">
    <xsl:call-template name="getRep"/>
  </xsl:variable>
  <xsl:value-of select="@name"/> = <xsl:value-of select="$rep"/>
  <xsl:if test="following-sibling::constant">
    <xsl:text>,</xsl:text>
  </xsl:if>
</xsl:template> 

<xsl:template match="constant">
  <xsl:variable name="rep">
    <xsl:call-template name="getRep"/>
  </xsl:variable>
const int <xsl:value-of select="@name"/> = <xsl:value-of select="$rep"/> ;
</xsl:template> 

<xsl:template name="getRep">
  <xsl:choose>
    <xsl:when test="@rep = 'hex'">
      <xsl:value-of select="hex:toHex(@value)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@value"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

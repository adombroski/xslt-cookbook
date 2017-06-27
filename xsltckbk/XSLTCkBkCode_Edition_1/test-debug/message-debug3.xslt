<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                         xmlns:dbg="http://www.ora.com/XSLTCookbook/ns/debug">

<xsl:param name="dbg:debugOn" select="false()"/>

<xsl:template match="someElement[someChild = 'someValue']">
  [<xsl:value-of select="$dbg:debugOn"  />]
  <xsl:param name="myParam"/>
  <xsl:if test="$dbg:debugOn">
    <xsl:message>Matched someElement[someChild = 'someValue']</xsl:message>
    <xsl:message>$myParam=[<xsl:value-of select="$myParam"/>]</xsl:message>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>

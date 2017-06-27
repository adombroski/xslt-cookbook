<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:vxd="urn:schemas-microsoft-com:office:visio" 
  xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset" extension-element-prefixes="vset">

  <xsl:import href="vset.ops.xslt"/> 

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
  <xsl:template match="/">
  <UniqueShapes>
      <xsl:call-template name="vset:intersection">
        <xsl:with-param name="nodes1" select="//vxd:Pages/*/*/vxd:Shape"/>
        <xsl:with-param name="nodes2" select="//vxd:Pages/*/*/vxd:Shape"/>
      </xsl:call-template> 
    </UniqueShapes>
  </xsl:template>
  
  <xsl:template match="vxd:Shape" mode="vset:intersection">
    <xsl:copy-of select="." />
  </xsl:template>

<xsl:template match="vxd:Shape" mode="vset:element-equality">
  <xsl:param name="other"/>
  <xsl:choose>
    <xsl:when test="@Master and $other/@Master and @Master = $other/@Master">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:when test="not(@Master) or not($other/@Master)">
      <xsl:variable name="geom1">
        <xsl:for-each select="vxd:Geom//*/@*">
          <xsl:value-of select="."/>
        </xsl:for-each>
     </xsl:variable> 
      <xsl:variable name="geom2">
        <xsl:for-each select="$other/vxd:Geom//*/@*">
          <xsl:value-of select="."/>
        </xsl:for-each>
     </xsl:variable> 
      <xsl:if test="$geom1 = $geom2">
        <xsl:value-of select="true()"/>
      </xsl:if>
    </xsl:when>
  </xsl:choose>
</xsl:template>

 
</xsl:stylesheet>

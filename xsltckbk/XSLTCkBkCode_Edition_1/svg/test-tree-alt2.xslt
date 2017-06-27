<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="test-tree-alt1.xslt"/>
  
  <xsl:template name="drawConnections">
    <xsl:param name="xParent"/>
    <xsl:param name="yParent"/>
    <xsl:param name="widthParent"/>
    <xsl:param name="heightParent"/>
    <xsl:param name="children"/>
    <xsl:call-template name="drawStraightConnections">
      <xsl:with-param name="xParent" select="$xParent"/>
      <xsl:with-param name="yParent" select="$yParent"/>
      <xsl:with-param name="widthParent" select="$widthParent"/>
      <xsl:with-param name="heightParent" select="$heightParent"/>
      <xsl:with-param name="children" select="$children"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>

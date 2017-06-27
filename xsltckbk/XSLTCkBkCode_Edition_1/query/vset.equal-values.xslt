<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:vset="http:/www.ora.com/XSLTCookbook/namespaces/vset" extension-element-prefixes="vset">
	
<xsl:template name="vset:equal-text-values">
  <xsl:param name="nodes1" select="/.."/>
  <xsl:param name="nodes2" select="/.."/>
  <xsl:choose>
   <!--Empty node-sets have equal values -->
    <xsl:when test="not($nodes1) and not($nodes2)">
      <xsl:value-of select="true()"/>
      </xsl:when>
    <!--Node sets of unequal sizes can not have equal values -->
    <xsl:when test="count($nodes1) != count($nodes2)"/>
    <!--If an element of nodes1 is present in nodes2 then the node sets 
	have equal values if the node sets without the common element have equal 
	values -->
    <xsl:when test="$nodes1[1] = $nodes2">
      <xsl:call-template name="vset:equal-text-values">
          <xsl:with-param name="nodes1" select="$nodes1[position()>1]"/>
          <xsl:with-param name="nodes2" select="$nodes2[not(. = $nodes1[1])]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template name="vset:equal-text-values-ignore-dups">
  <xsl:param name="nodes1" select="/.."/>
  <xsl:param name="nodes2" select="/.."/>
  <xsl:choose>
   <!--Empty node-sets have equal values -->
    <xsl:when test="not($nodes1) and not($nodes2)">
      <xsl:value-of select="true()"/>
      </xsl:when>
    <!--If an element of nodes1 is present in nodes2 then the node sets 
	have equal values if the node sets without the common element have equal 
	values -->
    <xsl:when test="$nodes1[1] = $nodes2">
      <xsl:call-template name="vset:equal-text-values">
          <xsl:with-param name="nodes1" select="$nodes1[not(. = $nodes1[1])]"/>
          <xsl:with-param name="nodes2" select="$nodes2[not(. = $nodes1[1])]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

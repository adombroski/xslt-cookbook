<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:query="http://www.ora.com/XSLTCookbook/namespaces/query" exclude-result-prefixes="query">
	
<xsl:template name="query:equal-values">
  <xsl:param name="nodes1" select="/.."/>
  <xsl:param name="nodes2" select="/.."/>
  <xsl:choose>
   <!--Empty node-sets have equal values -->
    <xsl:when test="not($nodes1) and not($nodes2)">
      <xsl:value-of select="true()"/>
      </xsl:when>
    <!--Node sets of unequal sizes can not have equal values -->
    <xsl:when test="count($nodes1) != count($nodes2)"/>
    <!--If an element of node set 1 is present in node set 2 then the node sets have
         equal values if the node sets without the common element have equal values -->
    <xsl:when test="$nodes1[1] = $nodes2">
      <xsl:call-template name="query:equal-values">
          <xsl:with-param name="nodes1" select="$nodes1[position()>1]"/>
          <xsl:with-param name="nodes2" select="$nodes2[. != $nodes1[1]]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

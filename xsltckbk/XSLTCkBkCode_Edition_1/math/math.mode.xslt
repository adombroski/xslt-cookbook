<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:math="http://www.ora.com/XSLTCookbook/math" xmlns:test="test">

<xsl:output method="text"/>

<xsl:template name="math:mode">
  <xsl:param name="nodes" select="/.."/>
  <xsl:param name="max" select="0"/>
  <xsl:param name="mode" select="/.."/>

  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:copy-of select="$mode"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="first" select="$nodes[1]"/>
	<xsl:variable name="try" select="$nodes[. = $first]"/>
      <xsl:variable name="count" select="count($try)"/>
      <!-- Recurse with nodes not equal to first -->
      <xsl:call-template name="math:mode">
        <xsl:with-param name="nodes" select="$nodes[not(. = $first)]"/>
        <!-- If we have found a node that is more frequent then 
		pass the count otherwise pass the old max count -->
        <xsl:with-param name="max" 
		select="($count > $max) * $count + not($count > $max) * $max"/>
        <!-- Compute the new mode as ... -->
        <xsl:with-param name="mode">
          <xsl:choose>
            <!-- the first element in try if we found a new max -->
            <xsl:when test="$count > $max">
		   <xsl:copy-of select="$try[1]"/>
            </xsl:when>
            <!-- the old mode union the first element in try if we 
			found an equivalent count to current max -->
            <xsl:when test="$count = $max">
            <xsl:message>trouble?</xsl:message>
		   <xsl:copy-of select="$mode | $try[1]"/>
            </xsl:when>
            <!-- othewise the old mode stays the same -->
            <xsl:otherwise>
              <xsl:copy-of select="$mode"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<test:data>1</test:data>
<test:data>2</test:data>
<test:data>1</test:data>
<test:data>1</test:data>
<test:data>1</test:data>
<test:data>1</test:data>
<test:data>1</test:data>
<test:data>2</test:data>
<test:data>2</test:data>
<test:data>2</test:data>
<test:data>2</test:data>
<test:data>2</test:data>

<test:data>2</test:data>

<test:data>2</test:data>



<xsl:template match="/">

  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="math:mode">
    <xsl:with-param name="nodes" select="*/*"/>
  </xsl:call-template>
  
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>&#xa;</xsl:text>
  <xsl:call-template name="math:mode">
    <xsl:with-param name="nodes" select="document('')/*/test:data"/>
  </xsl:call-template>
  
</xsl:template>


</xsl:stylesheet>

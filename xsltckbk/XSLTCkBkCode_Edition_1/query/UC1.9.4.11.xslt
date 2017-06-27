<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
List the names of all Joe's descendants. Show each descendant as an element with the descendant's name as content and his or her marital status and number of children as attributes. Sort the descendants in descending order by number of children, and secondarily in alphabetical order by name. 

Solution in XQuery:

define function descrip (element $e) returns element
{
    let $kids := $e/* union $e/@spouse=>person/*
    let $mstatus :=  if ($e[@spouse]) then "Yes" else "No"
    return
        <person married={ $mstatus } nkids={ count($kids) }>{ $e/@name/text() }</person>
}

define function descendants (element $e)
{
    if (empty($e/* union $e/@spouse=>person/*))
    then $e
    else $e union descendants($e/* union $e/@spouse=>person/*)
}

descrip(descendants(//person[@name = "Joe"])) sortby(@nkids descending, .)

-->

<xsl:variable name="everyone" select="//person"/>

<xsl:template match="census">
  <result>
    <xsl:apply-templates select="//person[@name='Joe']"/>
  </result>
</xsl:template>

<xsl:template match="person">
  
  <xsl:variable name="all-desc">
    <xsl:call-template name="descendants">
      <xsl:with-param name="nodes" select="."/>
    </xsl:call-template>
  </xsl:variable>
    
  <xsl:for-each select="exsl:node-set($all-desc)/*">
    <xsl:sort select="count(./* | $everyone[@name = current()/@spouse]/*)" order="descending" data-type="number"/>
    <xsl:sort select="@name"/>

    <xsl:variable name="mstatus" select="normalize-space(substring('No Yes',boolean(@spouse) * 3+1,3))"/>
    <person married="{$mstatus}" nkids="{count(./* | $everyone[@name = current()/@spouse]/*)}"><xsl:value-of select="@name"/></person> 
  </xsl:for-each>
</xsl:template>

<xsl:template name="descendants">
  <xsl:param name="nodes"/>
  <xsl:param name="descendants" select="/.."/>
  
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:copy-of select="$descendants"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="descendants">
        <xsl:with-param name="nodes" select="$nodes[position() > 1] | $nodes[1]/person | id($nodes[1]/@spouse)/person"/>
        <xsl:with-param name="descendants" select="$descendants | $nodes[1]/person | id($nodes[1]/@spouse)/person"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

</xsl:stylesheet>

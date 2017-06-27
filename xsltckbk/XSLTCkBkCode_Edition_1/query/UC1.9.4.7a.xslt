<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
List name-pairs of grandparents and grandchildren. 

Solution in XQuery:

<result>
  {
    for $b in document("census.xml")//person,
        $c in $b/person | $b/@spouse=>person/person,
        $g in $c/person | $c/@spouse=>person/person
    return
        <grandparent name={ $b/@name } grandchild={ $g/@name }/>
  }
</result>
-->

<xsl:template match="census">
  <result>
    <!-- For each grandparent -->
    <xsl:for-each select="//person[person/person]">
      <!--Select children -->
      <xsl:apply-templates select="/person | id(@spouse)/person">
        <xsl:with-param name="grandparent" select="."/>
      </xsl:apply-templates>
    </xsl:for-each>
  </result>
</xsl:template>

<xsl:template match="person">
  <xsl:param name="grandparent"/>
    <xsl:for-each select="person | id(@spouse)/person">
      <grandparent name="{$grandparent/@name}" grandchild="{@name"/>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>

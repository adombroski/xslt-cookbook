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

<xsl:strip-space elements="*"/>
<xsl:template match="census">
  <result>
    <xsl:for-each select="//person[not(./person)]">
      <xsl:variable name="spouse" select="id(@spouse)"/>
      <xsl:if test="not ($spouse) or not($spouse/person)">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </result>
</xsl:template>

</xsl:stylesheet>

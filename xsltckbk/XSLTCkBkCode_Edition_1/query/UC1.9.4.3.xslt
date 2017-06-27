<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
Find parents of athletes. 

Solution in XQuery:

<result>
  {
    for $p in document("census.xml")//person,
        $s in $p/@spouse=>person
    where $p/person/@job = "Athlete" or $s/person/@job = "Athlete"
    return shallow($p)
  }
</result>
-->

<xsl:template match="census">
  <result>
    <xsl:for-each select="//person[person]">
      <xsl:variable name="spouse" select="id(@spouse)"/>
      <xsl:if test="./person/@job = 'Athlete' or $spouse/person/@job = 'Athlete'">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
        </xsl:copy>
      </xsl:if>
    </xsl:for-each>
  </result>
</xsl:template>

</xsl:stylesheet>

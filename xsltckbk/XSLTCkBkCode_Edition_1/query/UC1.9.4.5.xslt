<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
List names of parents and children who have the same job, and their jobs.

Solution in XQuery:

<result>
    {
        for $p in document("census.xml")//person,
            $c in $p/person[@job = $p/@job]
        return
            <match parent={ $p/@name } child={ $c/@name } job={ $c/@job } />
    }
    {
        for $p in document("census.xml")//person,
            $c in $p/@spouse=>person/person[@job = $p/@job]
        return
            <match parent={ $p/@name } child={ $c/@name } job={ $c/@job } />
    }
</result>
-->

<xsl:template match="census">
  <result>
    <xsl:for-each select="//person[person]">
      <xsl:variable name="spouse" select="id(@spouse)"/>

      <xsl:apply-templates select="person[@job = current()/@job]">
        <xsl:with-param name="parent" select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="person[@job = $spouse/@job]">
        <xsl:with-param name="parent" select="$spouse/@name"/>
      </xsl:apply-templates>
      
    </xsl:for-each>
  </result>
</xsl:template>

<xsl:template match="person">
  <xsl:param name="parent"/>
  <match parent="{$parent}"  child="{@name}" job="{@job}"/>
</xsl:template>

</xsl:stylesheet>

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
  <xsl:variable name="everyone"  select="//person"/>
  <result>
    <!-- For each grandchild -->
    <xsl:for-each select="$everyone[../../../person]">
        <!-- Get the grandparent1 (guaranteed to exist by for each -->
        <grandparent name="{../../@name}" grandchild="{@name}"/>
        <!-- Get the grandparent2 is grandparent1's  spouse if listed -->
        <xsl:if test="../../@spouse">
          <grandparent name="{../../@spouse}" grandchild="{@name}"/>
        </xsl:if>
       <!-- Get the names of this person's parent's spouse (i.e. their mother or father as the case may be) --> 
        <xsl:variable name="spouse-of-parent" select="../@spouse"/>
        <!-- Get parents of spouse-of-parent, if present -->
        <xsl:variable name="gp3" select="$everyone[person/@name=$spouse-of-parent]"/>
        <xsl:if test="$gp3">
          <grandparent name="{$gp3/@name}" grandchild="{@name}"/>
          <xsl:if test="$gp3/@spouse">
            <grandparent name="{$gp3/@spouse}" grandchild="{@name}"/>
          </xsl:if>
        </xsl:if>
    </xsl:for-each>
  </result>
</xsl:template>

</xsl:stylesheet>

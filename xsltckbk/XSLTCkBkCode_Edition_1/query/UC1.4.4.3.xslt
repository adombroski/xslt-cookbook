<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:variable name="ratings">
  <xsl:for-each select="document('users.xml')//user_tuple/rating">
    <xsl:sort select="." data-type="text"/>
    <xsl:if test="not(. = ./preceding::rating)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:for-each>
</xsl:variable>
<!--
Find cases where a user with a rating worse (alphabetically, greater) than "C" is offering an item with a reserve price of more than 1000.

Solution in XQuery:

<result>
  {
    for $u in document("users.xml")//user_tuple
    for $i in document("items.xml")//item_tuple
    where $u/rating > "C" 
       and $i/reserve_price > 1000 
       and $i/offered_by = $u/userid
    return
        <warning>
            { $u/name }
            { $u/rating }
            { $i/description }
            { $i/reserve_price }
        </warning>
  }
</result>
-->

<xsl:template match="items">
<result>
  <xsl:for-each select="item_tuple[reserve_price > 1000]">

  <xsl:variable name="user" select="document('users.xml')//user_tuple[userid = current()/offered_by]"/>

  <xsl:if test="string-length(substring-before($ratings,$user/rating)) > string-length(substring-before($ratings,'C'))">
    <warning>
      <xsl:copy-of select="$user/name"/>
      <xsl:copy-of select="$user/rating"/>
      <xsl:copy-of select="description"/>
      <xsl:copy-of select="reserve_price"/>
    </warning>
  </xsl:if>    
  </xsl:for-each>
</result>
</xsl:template>

</xsl:stylesheet>

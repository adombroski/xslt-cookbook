<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
List item numbers and descriptions of items that have no bids.

Solution in XQuery:

<result>
  {
    for $i in document("items.xml")//item_tuple
    where not(some $b in document("bids.xml")//bid_tuple 
                        satisfies $b/itemno = $i/itemno)
    return
        <no_bid_item>
            { $i/itemno }
            { $i/description }
        </no_bid_item>
  }
</result>
-->

<xsl:template match="items">
<result>
  <xsl:for-each select="item_tuple">

  <xsl:if test="not(document('bids.xml')//bid_tuple[itemno = current()/itemno])">
    <no_bid_item>
      <xsl:copy-of select="itemno"/>
      <xsl:copy-of select="description"/>
    </no_bid_item>
  </xsl:if>    
  
  </xsl:for-each>
</result>
</xsl:template>

</xsl:stylesheet>

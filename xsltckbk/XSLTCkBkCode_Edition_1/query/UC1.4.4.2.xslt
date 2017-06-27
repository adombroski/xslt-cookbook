<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:include href="../math/math.max.xslt"/>

<!--
For all bicycles, list the item number, description, and highest bid (if any), ordered by item number.

Solution in XQuery:

<result>
  {
    for $i in document("items.xml")//item_tuple
    let $b := document("bids.xml")//bid_tuple[itemno = $i/itemno]
    where contains($i/description, "Bicycle")
    return
        <item_tuple>
            { $i/itemno }
            { $i/description }
            <high_bid>{ max($b/bid) }</high_bid>
        </item_tuple>
    sortby(itemno)
  }
</result> 
-->

<xsl:template match="items">

<result>
  <xsl:for-each select="item_tuple[contains(description,'Bicycle')]">
    <xsl:sort select="itemno" data-type="number"/>
  
  <xsl:variable name="bids" select="document('bids.xml')//bid_tuple[itemno=current()/itemno]/bid"/>
  <xsl:variable name="high-bid">
    <xsl:call-template name="math:max">
      <xsl:with-param name="nodes" select="$bids"/>
    </xsl:call-template>
  </xsl:variable> 
  
  <xsl:copy>
    <xsl:copy-of select="itemno"/>
    <xsl:copy-of select="description"/>
    <high_bid><xsl:if test="$bids"><xsl:value-of select="$high-bid"/></xsl:if></high_bid>
  </xsl:copy>
    
  </xsl:for-each>
</result>
</xsl:template>

</xsl:stylesheet>

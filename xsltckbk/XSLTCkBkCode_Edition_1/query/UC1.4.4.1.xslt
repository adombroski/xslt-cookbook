<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:date="http://www.ora.com/XSLTCookbook/namespaces/date" extension-element-prefixes="date">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<xsl:include href="../date/date.date-time.xslt"/>

<!-- To make the result come out like the W3C example -->
<xsl:param name="today" select="'1999-01-21'"/>

<!--
List the item number and description of all bicycles that currently have an auction in progress, ordered by item number.

Solution in XQuery:

<result>
  {
    for $i in document("items.xml")//item_tuple
    where $i/start_date <= date()
      and $i/end_date >= date() 
      and contains($i/description, "Bicycle")
    return
        <item_tuple>
            { $i/itemno }
            { $i/description }
        </item_tuple>
    sortby (itemno)
  }
</result>
-->

<xsl:template match="items">

  <xsl:variable name="today-abs">
    <xsl:call-template name="date:date-to-absolute-day">
      <xsl:with-param name="date" select="$today"/>
    </xsl:call-template>
  </xsl:variable> 

<result>
  <xsl:for-each select="item_tuple">
    <xsl:sort select="itemno" data-type="number"/>
    
    <xsl:variable name="start-abs">
      <xsl:call-template name="date:date-to-absolute-day">
        <xsl:with-param name="date" select="start_date"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="end-abs">
      <xsl:call-template name="date:date-to-absolute-day">
        <xsl:with-param name="date" select="end_date"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$start-abs &lt;= $today-abs and $end-abs >= $today-abs and contains(description, 'Bicycle')">
      <xsl:copy>
        <xsl:copy-of select="itemno"/>
        <xsl:copy-of select="description"/>
      </xsl:copy>
    </xsl:if>
    
  </xsl:for-each>
</result>
</xsl:template>

</xsl:stylesheet>

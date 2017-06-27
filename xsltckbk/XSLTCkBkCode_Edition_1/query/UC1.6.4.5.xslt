<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:math="http://www.exslt.org/math"  extension-element-prefixes="math">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--
1.6.4.5 Q5
For each news item that is relevant to the Gorilla Corporation, create an "item summary" element. The content of the item summary is the content of the title, date, and first paragraph of the news item, separated by periods. A news item is relevant if the name of the company is mentioned anywhere within the content of the news item. 

Solution in XQuery:

for $item in //news_item
where contains(string($item/content), "Gorilla Corporation")
return
    <item_summary>
        { $item/title/text() }.
        { $item/date/text() }.
        { string(($item//par)[1]) }
    </item_summary>
-->

<xsl:template match="news">
<result>
  <xsl:for-each select="news_item[contains(content,'Gorilla Corporation')]">
    <item_summary>
      <xsl:value-of select="normalize-space(title)"/>. <xsl:text/>
      <xsl:value-of select="normalize-space(date)"/>. <xsl:text/>
      <xsl:value-of select="normalize-space(content/par[1])"/>
   </item_summary>
  </xsl:for-each>
</result>
</xsl:template>

</xsl:stylesheet>

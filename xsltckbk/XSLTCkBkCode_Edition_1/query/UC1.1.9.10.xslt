<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:math="http://www.exslt.org/math" exclude-result-prefixes="math">

<xsl:include href="../math/math.min.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!-- In the document "prices.xml", find the minimum price for each book, in the form of a "minprice" element with the book title as its title attribute. -->

<!--
<results>
  {
    let $doc := document("prices.xml")
    for $t in distinct-values($doc//book/title)
    let $p := $doc//book[title = $t]/price
    return
      <minprice title={ $t/text() }>
        <price>{ min(decimal($p/text())) }</price>
      </minprice>
  }
</results>
-->

<xsl:template match="/">
<results>
  <xsl:for-each select="//book/title[not(. = ./preceding::title)]">
    <xsl:variable name="min-price">
      <xsl:call-template name="math:min">
        <xsl:with-param name="nodes" select="//book[title = current()]/price"/>
      </xsl:call-template>
    </xsl:variable>
    <minprice title="{.}">
      <price><xsl:value-of select="$min-price"/></price>
    </minprice>
  </xsl:for-each>
</results>
</xsl:template>

</xsl:stylesheet>

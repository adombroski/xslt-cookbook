<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!-- For each book found at both bn.com and amazon.com, list the title of the book and its price from each source.

  -->

<!--
<books-with-prices>
  {
    for $b in document("www.bn.com/bib.xml")//book,
        $a in document("www.amazon.com/reviews.xml")//entry
    where $b/title = $a/title
    return
        <book-with-prices>
            { $b/title }
            <price-amazon>{ $a/price/text() }</price-amazon>
            <price-bn>{ $b/price/text() }</price-bn>
        </book-with-prices>
  }
</books-with-prices>
-->

<xsl:variable name="bn" select="document('bib.xml')"/>
<xsl:variable name="amazon" select="document('reviews.xml')"/>

<!--Solution 1 -->
<xsl:template match="/" priority="1">
  <books-with-prices>
  <xsl:for-each select="$bn//book[title = $amazon//entry/title]">
    <book-with-prices>
      <xsl:copy-of select="title"/>
      <price-amazon><xsl:value-of select="$amazon//entry[title=current()/title]/price"/></price-amazon>
      <price-bn><xsl:value-of select="price"/></price-bn>
    </book-with-prices>
  </xsl:for-each>
  </books-with-prices>
</xsl:template>

<!--Solution 2-->
<xsl:template match="/" priority="10">
  <books-with-prices>
  <xsl:for-each select="$bn//book">
    <xsl:variable name="bn-book" select="."/>
    <xsl:for-each select="$amazon//entry[title=$bn-book/title]">
      <book-with-prices>
        <xsl:copy-of select="title"/>
        <price-amazon><xsl:value-of select="price"/></price-amazon>
        <price-bn><xsl:value-of select="$bn-book/price"/></price-bn>
      </book-with-prices>
    </xsl:for-each>
  </xsl:for-each>
  </books-with-prices>
</xsl:template>

</xsl:stylesheet>

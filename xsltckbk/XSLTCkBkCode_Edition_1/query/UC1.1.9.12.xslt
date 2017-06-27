<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:query="http://www.ora.com/XSLTCookbook/namespaces/query" exclude-result-prefixes="query">

<xsl:include href="query.equal-values.xslt"/>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

<!--Find pairs of books that have different titles but the same set of authors (possibly in a different order).-->

<!--
<bib>
  {
    for $book1 in document("www.bn.com/bib.xml")//book,
        $book2 in document("www.bn.com/bib.xml")//book
    let $aut1 := $book1/author sortby(last, first),
        $aut2 := $book2/author sortby(last, first)
    where $book1 precedes $book2
    and not($book1/title = $book2/title)
    and sequence-value-equal($aut1, $aut2) 
    return
        <book-pair>
            { $book1/title }
            { $book2/title }
        </book-pair>
  }
</bib>
-->

	
<xsl:template match="bib">
  <xsl:copy>
    <xsl:for-each select="book[author]">
      <xsl:variable name="book1" select="."/>
      <xsl:for-each select="./following-sibling::book[author]">
        <xsl:variable name="same-authors">
          <xsl:call-template name="query:equal-values">
            <xsl:with-param name="nodes1" select="$book1/author"/>
            <xsl:with-param name="nodes2" select="author"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string($same-authors)">
          <book-pair>
            <xsl:copy-of select="$book1/title"/>
            <xsl:copy-of select="title"/>
          </book-pair>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<!--For each book that has at least one author, list the title and first two authors, and an empty "et-al" element if the book has additional authors. -->

<!--
<bib>
  {
    for $b in document("www.bn.com/bib.xml")//book
    where count($b/author) > 0
    return
        <book>
            { $b/title }
            {
                for $a in $b/author[position()<=2]  
                return $a
            }
            {
                if (count($b/author) > 2)
                then <et-al/>
                else ()
            }
        </book>
  }
</bib>
  -->

<xsl:template match="bib">
  <xsl:copy>
    <xsl:for-each select="book[author]">
      <xsl:copy>
        <xsl:copy-of select="title"/>
        <xsl:copy-of select="author[position() &lt;=2]"/>
        <xsl:if test="author[3]">
        <et-al/>
        </xsl:if>
      </xsl:copy>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>	

</xsl:stylesheet>
